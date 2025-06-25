class CheckInStatusModelResponse {
  bool? success;
  Data? data;

  CheckInStatusModelResponse({this.success, this.data});

  CheckInStatusModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Location? location;
  String? sId;
  String? employeeId;
  String? loginTime;
  String? logoutTime;
  String? totalWorkingHour;
  String? otTime;
  bool? isHalfDay;
  bool? isFullDay;
  String? workingHours;
  bool? checkIn;
  bool? leave;
  String? date;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? status;

  Data(
      {this.location,
        this.sId,
        this.employeeId,
        this.loginTime,
        this.logoutTime,
        this.totalWorkingHour,
        this.otTime,
        this.isHalfDay,
        this.isFullDay,
        this.workingHours,
        this.checkIn,
        this.leave,
        this.date,
        this.iV,
        this.createdAt,
        this.updatedAt,
        this.status

      });

  Data.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    employeeId = json['employeeId'];
    loginTime = json['loginTime'];
    logoutTime = json['logoutTime'];
    totalWorkingHour = json['totalWorkingHour'];
    otTime = json['otTime'];
    isHalfDay = json['isHalfDay'];
    isFullDay = json['isFullDay'];
    workingHours = json['workingHours'];
    checkIn = json['checkIn'];
    leave = json['leave'];
    date = json['date'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['employeeId'] = this.employeeId;
    data['loginTime'] = this.loginTime;
    data['logoutTime'] = this.logoutTime;
    data['totalWorkingHour'] = this.totalWorkingHour;
    data['otTime'] = this.otTime;
    data['isHalfDay'] = this.isHalfDay;
    data['isFullDay'] = this.isFullDay;
    data['workingHours'] = this.workingHours;
    data['checkIn'] = this.checkIn;
    data['leave'] = this.leave;
    data['date'] = this.date;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}

class Location {
  String? type;
  List<int>? coordinates;
  String? name;

  Location({this.type, this.coordinates, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<int>();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['name'] = this.name;
    return data;
  }
}






// class CheckInStatusModelResponse {
//   bool? success;
//   Data? data;
//
//   CheckInStatusModelResponse({this.success, this.data});
//
//   CheckInStatusModelResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   Location? location;
//   String? sId;
//   String? employeeId;
//   String? otTime;
//   bool? isHalfDay;
//   bool? isFullDay;
//   bool? checkIn;
//   String? date;
//   int? iV;
//   String? createdAt;
//   String? updatedAt;
//   String? loginTime;
//   String? status;
//
//   Data(
//       {this.location,
//         this.sId,
//         this.employeeId,
//         this.otTime,
//         this.isHalfDay,
//         this.isFullDay,
//         this.checkIn,
//         this.date,
//         this.iV,
//         this.createdAt,
//         this.updatedAt,
//         this.loginTime,
//         this.status});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     location = json['location'] != null
//         ? new Location.fromJson(json['location'])
//         : null;
//     sId = json['_id'];
//     employeeId = json['employeeId'];
//     otTime = json['otTime'];
//     isHalfDay = json['isHalfDay'];
//     isFullDay = json['isFullDay'];
//     checkIn = json['checkIn'];
//     date = json['date'];
//     iV = json['__v'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     loginTime = json['loginTime'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.location != null) {
//       data['location'] = this.location!.toJson();
//     }
//     data['_id'] = this.sId;
//     data['employeeId'] = this.employeeId;
//     data['otTime'] = this.otTime;
//     data['isHalfDay'] = this.isHalfDay;
//     data['isFullDay'] = this.isFullDay;
//     data['checkIn'] = this.checkIn;
//     data['date'] = this.date;
//     data['__v'] = this.iV;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['loginTime'] = this.loginTime;
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class Location {
//   String? type;
//   List<double>? coordinates;
//   String? name;
//
//   Location({this.type, this.coordinates, this.name});
//
//   Location.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     coordinates = json['coordinates'].cast<double>();
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['coordinates'] = this.coordinates;
//     data['name'] = this.name;
//     return data;
//   }
// }
