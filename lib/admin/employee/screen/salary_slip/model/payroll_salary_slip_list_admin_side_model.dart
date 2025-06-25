class PayrollSalarySlipListAdminSideModel {
  bool? success;
  String? message;
  int? count;
  List<Data>? data;

  PayrollSalarySlipListAdminSideModel(
      {this.success, this.message, this.count, this.data});

  PayrollSalarySlipListAdminSideModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
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
    data['success'] = this.success;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? employeeName;
  String? email;
  String? salary;
  int? presentDays;
  int? absentDays;
  int? totalWorkingDays;
  String? estimateSalary;
  String? month;

  Data(
      {this.employeeName,
        this.email,
        this.salary,
        this.presentDays,
        this.absentDays,
        this.totalWorkingDays,
        this.estimateSalary,
        this.month});

  Data.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    email = json['email'];
    salary = json['salary'];
    presentDays = json['presentDays'];
    absentDays = json['absentDays'];
    totalWorkingDays = json['totalWorkingDays'];
    estimateSalary = json['estimate_salary']?.toString();
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeName'] = this.employeeName;
    data['email'] = this.email;
    data['salary'] = this.salary;
    data['presentDays'] = this.presentDays;
    data['absentDays'] = this.absentDays;
    data['totalWorkingDays'] = this.totalWorkingDays;
    data['estimate_salary'] = this.estimateSalary;
    data['month'] = this.month;
    return data;
  }
}
