class UpdateEmpWorkDetailModel {
  bool? success;
  String? message;
  Result? result;

  UpdateEmpWorkDetailModel({this.success, this.message, this.result});

  UpdateEmpWorkDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? sId;
  String? employeeId;
  int? iV;
  String? company;
  String? createdAt;
  String? department;
  String? jobPosition;
  String? joiningDate;
  String? salary;
  String? updatedAt;
  String? workLocation;
  String? workType;

  Result(
      {this.sId,
        this.employeeId,
        this.iV,
        this.company,
        this.createdAt,
        this.department,
        this.jobPosition,
        this.joiningDate,
        this.salary,
        this.updatedAt,
        this.workLocation,
        this.workType});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    iV = json['__v'];
    company = json['company'];
    createdAt = json['createdAt'];
    department = json['department'];
    jobPosition = json['jobPosition'];
    joiningDate = json['joiningDate'];
    salary = json['salary'];
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
    data['salary'] = this.salary;
    data['updatedAt'] = this.updatedAt;
    data['workLocation'] = this.workLocation;
    data['workType'] = this.workType;
    return data;
  }
}
