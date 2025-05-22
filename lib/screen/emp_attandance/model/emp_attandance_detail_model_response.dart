class EmpAttancanceDetailModelResponse {
  bool? success;
  String? message;
  Data? data;

  EmpAttancanceDetailModelResponse({this.success, this.message, this.data});

  EmpAttancanceDetailModelResponse.fromJson(Map<String, dynamic> json) {
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
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? sId;
  EmployeeId? employeeId;
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

  Result(
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

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'] != null
        ? new EmployeeId.fromJson(json['employeeId'])
        : null;
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
    if (this.employeeId != null) {
      data['employeeId'] = this.employeeId!.toJson();
    }
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

class EmployeeId {
  String? sId;
  String? name;
  String? email;
  String? mobile;

  EmployeeId({this.sId, this.name, this.email, this.mobile});

  EmployeeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}
