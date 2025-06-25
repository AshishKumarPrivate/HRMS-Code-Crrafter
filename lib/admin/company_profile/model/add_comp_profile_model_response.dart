class AddCompProfileModelResponse {
  bool? success;
  String? message;
  Data? data;

  AddCompProfileModelResponse({this.success, this.message, this.data});

  AddCompProfileModelResponse.fromJson(Map<String, dynamic> json) {
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
  String? companyName;
  String? brandName;
  String? companyOfficialEmail;
  String? companyOfficialContact;
  String? website;
  String? domainName;
  List<String>? industryTypes;
  Logo? logo;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.companyName,
        this.brandName,
        this.companyOfficialEmail,
        this.companyOfficialContact,
        this.website,
        this.domainName,
        this.industryTypes,
        this.logo,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    brandName = json['brandName'];
    companyOfficialEmail = json['companyOfficialEmail'];
    companyOfficialContact = json['companyOfficialContact'];
    website = json['website'];
    domainName = json['domainName'];
    industryTypes = json['industryTypes'].cast<String>();
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyName'] = this.companyName;
    data['brandName'] = this.brandName;
    data['companyOfficialEmail'] = this.companyOfficialEmail;
    data['companyOfficialContact'] = this.companyOfficialContact;
    data['website'] = this.website;
    data['domainName'] = this.domainName;
    data['industryTypes'] = this.industryTypes;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Logo {
  String? publicId;
  String? secureUrl;

  Logo({this.publicId, this.secureUrl});

  Logo.fromJson(Map<String, dynamic> json) {
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
