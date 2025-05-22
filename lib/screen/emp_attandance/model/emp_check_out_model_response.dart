class EmpCheckOUTModelResponse {
  bool? success;
  String? message;
  Data? data;

  EmpCheckOUTModelResponse({this.success, this.message, this.data});

  EmpCheckOUTModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? loginTime;
  String? status;
  String? logoutTime;
  String? workingHours;

  Data(
      {this.sId,
        this.employeeId,
        this.isHalfDay,
        this.isFullDay,
        this.checkIn,
        this.date,
        this.iV,
        this.createdAt,
        this.updatedAt,
        this.loginTime,
        this.status,
        this.logoutTime,
        this.workingHours});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    isHalfDay = json['isHalfDay'];
    isFullDay = json['isFullDay'];
    checkIn = json['checkIn'];
    date = json['date'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    loginTime = json['loginTime'];
    status = json['status'];
    logoutTime = json['logoutTime'];
    workingHours = json['workingHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['employeeId'] = this.employeeId;
    data['isHalfDay'] = this.isHalfDay;
    data['isFullDay'] = this.isFullDay;
    data['checkIn'] = this.checkIn;
    data['date'] = this.date;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['loginTime'] = this.loginTime;
    data['status'] = this.status;
    data['logoutTime'] = this.logoutTime;
    data['workingHours'] = this.workingHours;
    return data;
  }
}
