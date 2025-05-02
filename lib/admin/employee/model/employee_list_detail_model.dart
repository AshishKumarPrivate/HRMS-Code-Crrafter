class EmployeeListDetailModelResponse {
  bool? success;
  String? message;
  Data? data;

  EmployeeListDetailModelResponse({this.success, this.message, this.data});

  EmployeeListDetailModelResponse.fromJson(Map<String, dynamic> json) {
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
  EmployeeImage? employeeImage;
  EmployeeImage? employeeIdCard;
  EmployeeImage? employeeDocument;
  String? sId;
  String? name;
  String? email;
  String? workEmail;
  String? mobile;
  String? dob;
  String? gender;
  String? address;
  String? state;
  String? city;
  String? qualification;
  String? experience;
  String? maritalStatus;
  String? role;
  String? token;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? registrationId;
  BankId? bankId;
  WorkId? workId;

  Data(
      {this.employeeImage,
        this.employeeIdCard,
        this.employeeDocument,
        this.sId,
        this.name,
        this.email,
        this.workEmail,
        this.mobile,
        this.dob,
        this.gender,
        this.address,
        this.state,
        this.city,
        this.qualification,
        this.experience,
        this.maritalStatus,
        this.role,
        this.token,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.registrationId,
        this.bankId,
        this.workId});

  Data.fromJson(Map<String, dynamic> json) {
    employeeImage = json['employeeImage'] != null
        ? new EmployeeImage.fromJson(json['employeeImage'])
        : null;
    employeeIdCard = json['employeeIdCard'] != null
        ? new EmployeeImage.fromJson(json['employeeIdCard'])
        : null;
    employeeDocument = json['employeeDocument'] != null
        ? new EmployeeImage.fromJson(json['employeeDocument'])
        : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    workEmail = json['workEmail'];
    mobile = json['mobile'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    qualification = json['qualification'];
    experience = json['experience'];
    maritalStatus = json['maritalStatus'];
    role = json['role'];
    token = json['token'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    registrationId = json['registrationId'];
    bankId =
    json['bankId'] != null ? new BankId.fromJson(json['bankId']) : null;
    workId =
    json['workId'] != null ? new WorkId.fromJson(json['workId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employeeImage != null) {
      data['employeeImage'] = this.employeeImage!.toJson();
    }
    if (this.employeeIdCard != null) {
      data['employeeIdCard'] = this.employeeIdCard!.toJson();
    }
    if (this.employeeDocument != null) {
      data['employeeDocument'] = this.employeeDocument!.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['workEmail'] = this.workEmail;
    data['mobile'] = this.mobile;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['qualification'] = this.qualification;
    data['experience'] = this.experience;
    data['maritalStatus'] = this.maritalStatus;
    data['role'] = this.role;
    data['token'] = this.token;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['registrationId'] = this.registrationId;
    if (this.bankId != null) {
      data['bankId'] = this.bankId!.toJson();
    }
    if (this.workId != null) {
      data['workId'] = this.workId!.toJson();
    }
    return data;
  }
}

class EmployeeImage {
  String? publicId;
  String? secureUrl;

  EmployeeImage({this.publicId, this.secureUrl});

  EmployeeImage.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    secureUrl = json['secure_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['secure_url'] = this.secureUrl;
    return data;
  }
}

class BankId {
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

  BankId(
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

  BankId.fromJson(Map<String, dynamic> json) {
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

class WorkId {
  String? sId;
  String? employeeId;
  int? iV;
  String? company;
  String? createdAt;
  String? department;
  String? employeeType;
  String? jobPosition;
  String? joiningDate;
  String? reportingManager;
  String? salary;
  String? shipInformation;
  String? updatedAt;
  String? workLocation;
  String? workType;

  WorkId(
      {this.sId,
        this.employeeId,
        this.iV,
        this.company,
        this.createdAt,
        this.department,
        this.employeeType,
        this.jobPosition,
        this.joiningDate,
        this.reportingManager,
        this.salary,
        this.shipInformation,
        this.updatedAt,
        this.workLocation,
        this.workType});

  WorkId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    iV = json['__v'];
    company = json['company'];
    createdAt = json['createdAt'];
    department = json['department'];
    employeeType = json['employeeType'];
    jobPosition = json['jobPosition'];
    joiningDate = json['joiningDate'];
    reportingManager = json['reportingManager'];
    salary = json['salary'];
    shipInformation = json['shipInformation'];
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
    data['employeeType'] = this.employeeType;
    data['jobPosition'] = this.jobPosition;
    data['joiningDate'] = this.joiningDate;
    data['reportingManager'] = this.reportingManager;
    data['salary'] = this.salary;
    data['shipInformation'] = this.shipInformation;
    data['updatedAt'] = this.updatedAt;
    data['workLocation'] = this.workLocation;
    data['workType'] = this.workType;
    return data;
  }
}
