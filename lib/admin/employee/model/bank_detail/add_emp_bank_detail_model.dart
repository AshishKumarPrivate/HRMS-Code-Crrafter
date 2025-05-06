class AddEmpBankDetailsModel {
  bool? success;
  String? message;
  Data? data;

  AddEmpBankDetailsModel({this.success, this.message, this.data});

  AddEmpBankDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? bankName;
  String? accountNumber;
  String? branch;
  String? ifscCode;
  String? bankCode;
  String? bankAddress;
  String? country;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.employeeId,
        this.bankName,
        this.accountNumber,
        this.branch,
        this.ifscCode,
        this.bankCode,
        this.bankAddress,
        this.country,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    branch = json['branch'];
    ifscCode = json['ifscCode'];
    bankCode = json['bankCode'];
    bankAddress = json['bankAddress'];
    country = json['country'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['employeeId'] = this.employeeId;
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['branch'] = this.branch;
    data['ifscCode'] = this.ifscCode;
    data['bankCode'] = this.bankCode;
    data['bankAddress'] = this.bankAddress;
    data['country'] = this.country;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
