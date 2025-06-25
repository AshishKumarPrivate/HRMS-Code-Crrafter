class AddCompanyAnnouncementModel {
  bool? success;
  String? message;
  Data? data;

  AddCompanyAnnouncementModel({this.success, this.message, this.data});

  AddCompanyAnnouncementModel.fromJson(Map<String, dynamic> json) {
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
  Logo? logo;
  String? sId;
  String? companyName;
  String? brandName;
  String? companyOfficialEmail;
  String? companyOfficialContact;
  String? website;
  String? domainName;
  List<String>? industryTypes;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? registeredOfficeId;
  String? corporateOfficeId;
  String? customAddressId;
  String? announcementId;

  Data(
      {this.logo,
        this.sId,
        this.companyName,
        this.brandName,
        this.companyOfficialEmail,
        this.companyOfficialContact,
        this.website,
        this.domainName,
        this.industryTypes,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.registeredOfficeId,
        this.corporateOfficeId,
        this.customAddressId,
        this.announcementId});

  Data.fromJson(Map<String, dynamic> json) {
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    sId = json['_id'];
    companyName = json['companyName'];
    brandName = json['brandName'];
    companyOfficialEmail = json['companyOfficialEmail'];
    companyOfficialContact = json['companyOfficialContact'];
    website = json['website'];
    domainName = json['domainName'];
    industryTypes = json['industryTypes'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    registeredOfficeId = json['registeredOfficeId'];
    corporateOfficeId = json['corporateOfficeId'];
    customAddressId = json['customAddressId'];
    announcementId = json['announcementId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    data['_id'] = this.sId;
    data['companyName'] = this.companyName;
    data['brandName'] = this.brandName;
    data['companyOfficialEmail'] = this.companyOfficialEmail;
    data['companyOfficialContact'] = this.companyOfficialContact;
    data['website'] = this.website;
    data['domainName'] = this.domainName;
    data['industryTypes'] = this.industryTypes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['registeredOfficeId'] = this.registeredOfficeId;
    data['corporateOfficeId'] = this.corporateOfficeId;
    data['customAddressId'] = this.customAddressId;
    data['announcementId'] = this.announcementId;
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
