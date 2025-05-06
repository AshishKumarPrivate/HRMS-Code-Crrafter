class UpdateEmpBankDetailsModel {
  bool? success;
  String? message;
  Result? result;

  UpdateEmpBankDetailsModel({this.success, this.message, this.result});

  UpdateEmpBankDetailsModel.fromJson(Map<String, dynamic> json) {
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

  Result(
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

  Result.fromJson(Map<String, dynamic> json) {
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
