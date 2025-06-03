class AdminFilterAttendanceModel {
  String? message;
  bool? success;
  int? count;
  List<Data>? data;

  AdminFilterAttendanceModel(
      {this.message, this.success, this.count, this.data});

  AdminFilterAttendanceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? employeeId;
  bool? isHalfDay;
  bool? isFullDay;
  bool? checkIn;
  String? date;
  String? createdAt;
  String? updatedAt;
  String? loginTime;
  String? status;
  String? logoutTime;
  String? workingHours;
  String? otTime;
  Employee? employee;

  Data(
      {this.sId,
        this.employeeId,
        this.isHalfDay,
        this.isFullDay,
        this.checkIn,
        this.date,
        this.createdAt,
        this.updatedAt,
        this.loginTime,
        this.status,
        this.logoutTime,
        this.workingHours,
        this.otTime,
        this.employee});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    isHalfDay = json['isHalfDay'];
    isFullDay = json['isFullDay'];
    checkIn = json['checkIn'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    loginTime = json['loginTime'];
    status = json['status'];
    logoutTime = json['logoutTime'];
    workingHours = json['workingHours'];
    otTime = json['otTime'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['employeeId'] = this.employeeId;
    data['isHalfDay'] = this.isHalfDay;
    data['isFullDay'] = this.isFullDay;
    data['checkIn'] = this.checkIn;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['loginTime'] = this.loginTime;
    data['status'] = this.status;
    data['logoutTime'] = this.logoutTime;
    data['workingHours'] = this.workingHours;
    data['otTime'] = this.workingHours;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    return data;
  }
}

class Employee {
  String? name;
  String? email;
  String? mobile;

  Employee({this.name, this.email, this.mobile});

  Employee.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}
