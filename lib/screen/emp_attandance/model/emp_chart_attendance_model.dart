class AttendanceChartModel {
  final bool success;
  final List<AttendanceChartItem> chart;

  AttendanceChartModel({
    required this.success,
    required this.chart,
  });

  factory AttendanceChartModel.fromJson(Map<String, dynamic> json) {
    return AttendanceChartModel(
      success: json['success'],
      chart: List<AttendanceChartItem>.from(
        json['chart'].map((x) => AttendanceChartItem.fromJson(x)),
      ),
    );
  }
}

class AttendanceChartItem {
  final String date;
  final dynamic status;

  AttendanceChartItem({
    required this.date,
    required this.status,
  });

  factory AttendanceChartItem.fromJson(Map<String, dynamic> json) {
    final statusJson = json['status'];
    if (statusJson is String) {
      return AttendanceChartItem(
        date: json['date'],
        status: statusJson,
      );
    } else if (statusJson is Map<String, dynamic>) {
      return AttendanceChartItem(
        date: json['date'],
        status: StatusData.fromJson(statusJson),
      );
    } else {
      return AttendanceChartItem(
        date: json['date'],
        status: null,
      );
    }
  }
}

class StatusData {
  final String id;
  final String employeeId;
  final bool? checkIn;
  final String? date;
  final bool? isFullDay;
  final bool? isHalfDay;
  final String? loginTime;
  final String? logoutTime;
  final String? workingHours;
  final String? status;

  StatusData({
    required this.id,
    required this.employeeId,
    this.checkIn,
    this.date,
    this.isFullDay,
    this.isHalfDay,
    this.loginTime,
    this.logoutTime,
    this.workingHours,
    this.status,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      id: json['_id'],
      employeeId: json['employeeId'],
      checkIn: json['checkIn'],
      date: json['date'],
      isFullDay: json['isFullDay'],
      isHalfDay: json['isHalfDay'],
      loginTime: json['loginTime'],
      logoutTime: json['logoutTime'],
      workingHours: json['workingHours'],
      status: json['status'],
    );
  }
}
