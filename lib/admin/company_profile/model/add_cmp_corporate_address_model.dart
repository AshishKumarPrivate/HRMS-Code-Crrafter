class AddCorporateAddressModel {
  bool? success;
  String? message;
  Data? data;
  Null? updatedOverview;

  AddCorporateAddressModel(
      {this.success, this.message, this.data, this.updatedOverview});

  AddCorporateAddressModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    updatedOverview = json['updatedOverview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['updatedOverview'] = this.updatedOverview;
    return data;
  }
}

class Data {
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  int? pincode;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.address1,
        this.address2,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
