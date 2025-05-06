class AddCompanyPolicyModel {
  bool? success;
  Response? response;
  String? message;

  AddCompanyPolicyModel({this.success, this.response, this.message});

  AddCompanyPolicyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Response {
  String? titel;
  String? description;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Response(
      {this.titel,
        this.description,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Response.fromJson(Map<String, dynamic> json) {
    titel = json['titel'];
    description = json['description'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titel'] = this.titel;
    data['description'] = this.description;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
