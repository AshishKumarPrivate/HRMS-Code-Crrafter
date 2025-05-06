class AddEmpWorkModel {
  bool? success;
  String? message;
  Data? data;

  AddEmpWorkModel({this.success, this.message, this.data});

  AddEmpWorkModel.fromJson(Map<String, dynamic> json) {
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
  int? iV;
  String? company;
  String? createdAt;
  String? department;
  String? jobPosition;
  String? joiningDate;
  String? reportingManager;
  String? salary;
  String? shiftInformation;
  String? updatedAt;
  String? workLocation;
  String? workType;

  Data(
      {this.sId,
        this.employeeId,
        this.iV,
        this.company,
        this.createdAt,
        this.department,
        this.jobPosition,
        this.joiningDate,
        this.reportingManager,
        this.salary,
        this.shiftInformation,
        this.updatedAt,
        this.workLocation,
        this.workType});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    iV = json['__v'];
    company = json['company'];
    createdAt = json['createdAt'];
    department = json['department'];
    jobPosition = json['jobPosition'];
    joiningDate = json['joiningDate'];
    reportingManager = json['reportingManager'];
    salary = json['salary'];
    shiftInformation = json['shiftInformation'];
    updatedAt = json['updatedAt'];
    workLocation = json['workLocation'];
    workType = json['workType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['employeeId'] = this.employeeId;
    data['__v'] = this.iV;
    data['company'] = this.company;
    data['createdAt'] = this.createdAt;
    data['department'] = this.department;
    data['jobPosition'] = this.jobPosition;
    data['joiningDate'] = this.joiningDate;
    data['reportingManager'] = this.reportingManager;
    data['salary'] = this.salary;
    data['shiftInformation'] = this.shiftInformation;
    data['updatedAt'] = this.updatedAt;
    data['workLocation'] = this.workLocation;
    data['workType'] = this.workType;
    return data;
  }
}
