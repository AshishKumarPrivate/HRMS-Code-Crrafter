class AddEmpDocumentModelResponse {
  bool? success;
  String? message;
  Data? data;

  AddEmpDocumentModelResponse({this.success, this.message, this.data});

  AddEmpDocumentModelResponse.fromJson(Map<String, dynamic> json) {
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
  String? employeeid;
  Pan? pan;
  Pan? aadhaar;
  Pan? passbook;
  Pan? highSchool;
  Pan? graduation;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.employeeid,
        this.pan,
        this.aadhaar,
        this.passbook,
        this.highSchool,
        this.graduation,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    employeeid = json['employeeid'];
    pan = json['pan'] != null ? new Pan.fromJson(json['pan']) : null;
    aadhaar =
    json['aadhaar'] != null ? new Pan.fromJson(json['aadhaar']) : null;
    passbook =
    json['passbook'] != null ? new Pan.fromJson(json['passbook']) : null;
    highSchool = json['highSchool'] != null
        ? new Pan.fromJson(json['highSchool'])
        : null;
    graduation = json['graduation'] != null
        ? new Pan.fromJson(json['graduation'])
        : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeid'] = this.employeeid;
    if (this.pan != null) {
      data['pan'] = this.pan!.toJson();
    }
    if (this.aadhaar != null) {
      data['aadhaar'] = this.aadhaar!.toJson();
    }
    if (this.passbook != null) {
      data['passbook'] = this.passbook!.toJson();
    }
    if (this.highSchool != null) {
      data['highSchool'] = this.highSchool!.toJson();
    }
    if (this.graduation != null) {
      data['graduation'] = this.graduation!.toJson();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Pan {
  String? publicId;
  String? secureUrl;

  Pan({this.publicId, this.secureUrl});

  Pan.fromJson(Map<String, dynamic> json) {
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
