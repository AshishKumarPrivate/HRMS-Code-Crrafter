class ApplyLeaveModelResponse {
  bool? success;
  String? message;
  Leave? leave;

  ApplyLeaveModelResponse({this.success, this.message, this.leave});

  ApplyLeaveModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    leave = json['leave'] != null ? new Leave.fromJson(json['leave']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.leave != null) {
      data['leave'] = this.leave!.toJson();
    }
    return data;
  }
}

class Leave {
  String? employeeId;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? status;
  String? description;
  String? breakDown;
  String? sId;
  String? appliedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Leave(
      {this.employeeId,
        this.leaveType,
        this.startDate,
        this.endDate,
        this.status,
        this.description,
        this.breakDown,
        this.sId,
        this.appliedAt,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Leave.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    leaveType = json['leaveType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    description = json['description'];
    breakDown = json['breakDown'];
    sId = json['_id'];
    appliedAt = json['appliedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['leaveType'] = this.leaveType;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['status'] = this.status;
    data['description'] = this.description;
    data['breakDown'] = this.breakDown;
    data['_id'] = this.sId;
    data['appliedAt'] = this.appliedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
