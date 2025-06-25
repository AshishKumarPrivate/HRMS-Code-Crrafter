import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Define an enum to represent the various states of location access
enum LocationStatus {
  initial, // Default state before any attempt
  loading,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  error,
}

class LocationService extends ChangeNotifier with WidgetsBindingObserver {
  String _locationMessage = "Location not available.";
  String _addressMessage = "Tap to get location.";
  LocationStatus _status = LocationStatus.initial;
  Position? _currentPosition; // Store the raw position data

  String get locationMessage => _locationMessage;
  String get addressMessage => _addressMessage;
  LocationStatus get status => _status;
  Position? get currentPosition => _currentPosition;
  // Add a variable to track the last known app lifecycle state
  AppLifecycleState? _lastLifecycleState;
  bool _hasFetchedLocationOnce = false;
  bool get hasFetchedLocationOnce => _hasFetchedLocationOnce;


  LocationService() {
    // Add this instance as a WidgetsBindingObserver when it's created
    WidgetsBinding.instance.addObserver(this);
    _lastLifecycleState = WidgetsBinding.instance.lifecycleState;
  }

  // Private helper to update state and notify listeners
  void _updateState({
    String? newLocationMessage,
    String? newAddressMessage,
    LocationStatus? newStatus,
    Position? newPosition,
  }) {
    if (newLocationMessage != null) {
      _locationMessage = newLocationMessage;
    }
    if (newAddressMessage != null) {
      _addressMessage = newAddressMessage;
    }
    if (newStatus != null) {
      _status = newStatus;
    }
    if (newPosition != null) {
      _currentPosition = newPosition;
    }
    notifyListeners();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("LocationService: App Lifecycle State Changed: $state (Previous: $_lastLifecycleState)");

    // Only re-fetch location if the app is resuming from an inactive or paused state.
    // This typically covers scenarios where the app was in the background
    // or the user navigated away (e.g., to settings).
    // It avoids re-fetching for brief overlays like notification drawers.
    if (state == AppLifecycleState.resumed) {
      if (_lastLifecycleState == AppLifecycleState.inactive ||
          _lastLifecycleState == AppLifecycleState.paused) {
        debugPrint("LocationService: Resumed from inactive/paused. Re-checking location.");

        _hasFetchedLocationOnce = true;
        getLocationAndAddress();
      } else {
        debugPrint("LocationService: Resumed from state other than inactive/paused. No re-fetch.");
      }
    }
    // Update the last state for the next check
    _lastLifecycleState = state;
  }

  Future<void> getLocationAndAddress({bool shouldOpenSettings = false}) async {
    if (_hasFetchedLocationOnce && !shouldOpenSettings) {
      debugPrint("LocationService: Already fetched once, skipping.");
      return;
    }
    // Prevent re-fetching if we are already in the process of fetching and not explicitly refreshing
    if (_status == LocationStatus.loading && !shouldOpenSettings) {
      debugPrint("LocationService: Already fetching, skipping duplicate call.");
      return;
    }
    _updateState(
      newStatus: LocationStatus.loading,
      newLocationMessage: "Fetching location...",
      newAddressMessage: "Fetching address...",
    );

    try {
      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // If disabled, prompt user to enable and set status
        _updateState(
          newStatus: LocationStatus.serviceDisabled,
          newLocationMessage: "Location services disabled.",
          newAddressMessage: "Please enable GPS on your device.",
        );
        // Optionally, open settings. We will return true if settings opened
        // and let the user decide. The UI can then re-trigger this method.
        if (shouldOpenSettings) {
          await Geolocator.openLocationSettings();
        }
        return;
      }

      // 2. Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // User denied, set status and message
          _updateState(
            newStatus: LocationStatus.denied,
            newLocationMessage: "Location permission denied.",
            newAddressMessage: "Please grant permission to get your location.",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // User permanently denied, set status and message
        _updateState(
          newStatus: LocationStatus.deniedForever,
          newLocationMessage: "Location permission permanently denied.",
          newAddressMessage: "Please enable location from app settings.",
        );
        // Prompt to open settings. User can re-trigger after visiting settings.
        if (shouldOpenSettings) {
          await Geolocator.openAppSettings();
        }
        return;
      }

      // If we reach here, permissions are granted and service is enabled
      // 3. Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20), // Increased timeout
      );

      _updateState(
        newPosition: position,
        newLocationMessage: "Lat: ${position.latitude}\nLon: ${position.longitude}",
      );

      // 4. Convert Lat/Long to Address
      String address = await _getAddressFromLatLng(position);
      _updateState(
        newStatus: LocationStatus.granted, // Only set granted if everything succeeded
        newAddressMessage: address,
      );

      _hasFetchedLocationOnce = true;
    } catch (e) {
      // Catch any other errors during the process
      _updateState(
        newStatus: LocationStatus.error,
        newLocationMessage: "Error getting location.",
        newAddressMessage: "Error: ${e.toString()}",
      );
    } finally {
      // No need to set isLoading to false directly, status takes care of it
    }
  }

  /// Private method to convert a [Position] to a human-readable address.
  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // Customize the address format here
        return "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}";
      } else {
        return "No address found for these coordinates.";
      }
    } catch (e) {
      return "Error getting address: ${e.toString()}";
    }
  }
}