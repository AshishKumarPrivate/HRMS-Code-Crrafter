class EmployeeListModelResponse {
  String? message;
  List<Data>? data;

  EmployeeListModelResponse({this.message, this.data});

  EmployeeListModelResponse.fromJson(Map<String, dynamic> json) {
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
  String? alternateMobile;
  String? mobile;
  String? dob;
  String? gender;
  String? address;
  String? state;
  String? city;
  String? qualification;
  String? experience;
  String? maritalStatus;
  String? children;
  String? emergencyContact;
  String? role;
  String? token;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? registrationId;
  String? workId;
  String? leaveID;
  String? bankId;
  String? password;

  Data(
      {this.employeeImage,
        this.employeeIdCard,
        this.employeeDocument,
        this.sId,
        this.name,
        this.email,
        this.workEmail,
        this.alternateMobile,
        this.mobile,
        this.dob,
        this.gender,
        this.address,
        this.state,
        this.city,
        this.qualification,
        this.experience,
        this.maritalStatus,
        this.children,
        this.emergencyContact,
        this.role,
        this.token,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.registrationId,
        this.workId,
        this.leaveID,
        this.bankId,
        this.password});

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
    alternateMobile = json['alternateMobile'];
    mobile = json['mobile'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    qualification = json['qualification'];
    experience = json['experience'];
    maritalStatus = json['maritalStatus'];
    children = json['children'];
    emergencyContact = json['emergencyContact'];
    role = json['role'];
    token = json['token'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    registrationId = json['registrationId'];
    workId = json['workId'];
    leaveID = json['leaveID'];
    bankId = json['bankId'];
    password = json['password'];
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
    data['alternateMobile'] = this.alternateMobile;
    data['mobile'] = this.mobile;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['qualification'] = this.qualification;
    data['experience'] = this.experience;
    data['maritalStatus'] = this.maritalStatus;
    data['children'] = this.children;
    data['emergencyContact'] = this.emergencyContact;
    data['role'] = this.role;
    data['token'] = this.token;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['registrationId'] = this.registrationId;
    data['workId'] = this.workId;
    data['leaveID'] = this.leaveID;
    data['bankId'] = this.bankId;
    data['password'] = this.password;
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
