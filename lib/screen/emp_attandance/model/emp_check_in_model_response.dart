class EmpPunchInModel {
  bool? success;
  String? message;
  AddEmployee? addEmployee;

  EmpPunchInModel({this.success, this.message, this.addEmployee});

  EmpPunchInModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    addEmployee = json['addEmployee'] != null
        ? new AddEmployee.fromJson(json['addEmployee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.addEmployee != null) {
      data['addEmployee'] = this.addEmployee!.toJson();
    }
    return data;
  }
}

class AddEmployee {
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

  AddEmployee(
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
        this.status});

  AddEmployee.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
