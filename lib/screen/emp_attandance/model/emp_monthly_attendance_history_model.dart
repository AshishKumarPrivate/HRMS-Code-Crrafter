class EmpMonthlyAttancanceHistoryModel {
  bool? success;
  String? message;
  List<Data>? data;

  EmpMonthlyAttancanceHistoryModel({this.success,this.message, this.data});

  EmpMonthlyAttancanceHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? employeeId;
  int? iV;
  bool? checkIn;
  String? createdAt;
  String? date;
  bool? isFullDay;
  bool? isHalfDay;
  String? loginTime;
  String? status;
  String? updatedAt;
  String? logoutTime;
  String? workingHours;

  Data(
      {this.sId,
        this.employeeId,
        this.iV,
        this.checkIn,
        this.createdAt,
        this.date,
        this.isFullDay,
        this.isHalfDay,
        this.loginTime,
        this.status,
        this.updatedAt,
        this.logoutTime,
        this.workingHours});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    iV = json['__v'];
    checkIn = json['checkIn'];
    createdAt = json['createdAt'];
    date = json['date'];
    isFullDay = json['isFullDay'];
    isHalfDay = json['isHalfDay'];
    loginTime = json['loginTime'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    logoutTime = json['logoutTime'];
    workingHours = json['workingHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['employeeId'] = this.employeeId;
    data['__v'] = this.iV;
    data['checkIn'] = this.checkIn;
    data['createdAt'] = this.createdAt;
    data['date'] = this.date;
    data['isFullDay'] = this.isFullDay;
    data['isHalfDay'] = this.isHalfDay;
    data['loginTime'] = this.loginTime;
    data['status'] = this.status;
    data['updatedAt'] = this.updatedAt;
    data['logoutTime'] = this.logoutTime;
    data['workingHours'] = this.workingHours;
    return data;
  }
}
