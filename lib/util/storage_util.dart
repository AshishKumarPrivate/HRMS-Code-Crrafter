import 'package:shared_preferences/shared_preferences.dart';

class  StorageHelper {
  static final StorageHelper _singleton = StorageHelper._internal();
  static const String _orderDetailsKey = 'order_details';

  factory StorageHelper() {
    return _singleton;
  }

  StorageHelper._internal();
  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
   Future<void> savePunchIn(DateTime? time) async {
    await prefs.setString('punchIn', time?.toIso8601String() ?? '');
  }

   Future<void> savePunchOut(DateTime? time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('punchOut', time?.toIso8601String() ?? '');
  }

   Future<void> saveWorkingSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('workingSeconds', seconds);
  }

   Future<DateTime?> getPunchIn() async {
    final prefs = await SharedPreferences.getInstance();
    final inStr = prefs.getString('punchIn') ?? '';
    return inStr.isNotEmpty ? DateTime.tryParse(inStr) : null;
  }

   Future<DateTime?> getPunchOut() async {
    final prefs = await SharedPreferences.getInstance();
    final outStr = prefs.getString('punchOut') ?? '';
    return outStr.isNotEmpty ? DateTime.tryParse(outStr) : null;
  }

   Future<int> getWorkingSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('workingSeconds') ?? 0;
  }
   Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('punchIn');
    await prefs.remove('punchOut');
    await prefs.remove('workingSeconds');
  }

   setUserAccessToken(String token) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_access_token', token);
  }

   Future<String> getUserAccessToken()async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_access_token') ?? "";
  }
  /// 🔐 Logout and clear user data
   Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or use `remove(...)` for selected keys
  }

   Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }
   Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? "";
  }


   Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }
   Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email') ?? "";
  }
   Future<void> setUserRole(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', email);
  }
   Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role') ?? "";
  }

}
