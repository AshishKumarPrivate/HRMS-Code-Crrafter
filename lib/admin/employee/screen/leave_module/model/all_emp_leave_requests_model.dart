class AllEmpLeaveRequestsListModel {
  bool? success;
  String? message;
  List<Data>? data;

  AllEmpLeaveRequestsListModel({this.success, this.message, this.data});

  AllEmpLeaveRequestsListModel.fromJson(Map<String, dynamic> json) {
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
  EmployeeId? employeeId;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? status;
  String? description;
  String? breakDown;
  String? appliedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.employeeId,
        this.leaveType,
        this.startDate,
        this.endDate,
        this.status,
        this.description,
        this.breakDown,
        this.appliedAt,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'] != null
        ? new EmployeeId.fromJson(json['employeeId'])
        : null;
    leaveType = json['leaveType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    description = json['description'];
    breakDown = json['breakDown'];
    appliedAt = json['appliedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.employeeId != null) {
      data['employeeId'] = this.employeeId!.toJson();
    }
    data['leaveType'] = this.leaveType;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['status'] = this.status;
    data['description'] = this.description;
    data['breakDown'] = this.breakDown;
    data['appliedAt'] = this.appliedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
