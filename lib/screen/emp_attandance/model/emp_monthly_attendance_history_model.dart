
class EmpMonthlyAttancanceHistoryModel {
  bool? success;
  List<Data>? data;
  String? message;

  EmpMonthlyAttancanceHistoryModel({this.success, this.data, this.message});

  EmpMonthlyAttancanceHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
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
  Location? location;
  String? date;
  String? status;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
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
        this.location,
        this.date,
        this.status,
        this.iV,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    date = json['date'];
    status = json['status'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['date'] = this.date;
    data['status'] = this.status;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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







// class EmpMonthlyAttancanceHistoryModel {
//   bool? success;
//   String? message;
//   List<Data>? data;
//
//   EmpMonthlyAttancanceHistoryModel({this.success,this.message, this.data});
//
//   EmpMonthlyAttancanceHistoryModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? sId;
//   String? employeeId;
//   int? iV;
//   bool? checkIn;
//   String? createdAt;
//   String? date;
//   bool? isFullDay;
//   bool? isHalfDay;
//   String? loginTime;
//   String? status;
//   String? updatedAt;
//   String? logoutTime;
//   String? workingHours;
//
//   Data(
//       {this.sId,
//         this.employeeId,
//         this.iV,
//         this.checkIn,
//         this.createdAt,
//         this.date,
//         this.isFullDay,
//         this.isHalfDay,
//         this.loginTime,
//         this.status,
//         this.updatedAt,
//         this.logoutTime,
//         this.workingHours});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     employeeId = json['employeeId'];
//     iV = json['__v'];
//     checkIn = json['checkIn'];
//     createdAt = json['createdAt'];
//     date = json['date'];
//     isFullDay = json['isFullDay'];
//     isHalfDay = json['isHalfDay'];
//     loginTime = json['loginTime'];
//     status = json['status'];
//     updatedAt = json['updatedAt'];
//     logoutTime = json['logoutTime'];
//     workingHours = json['workingHours'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['employeeId'] = this.employeeId;
//     data['__v'] = this.iV;
//     data['checkIn'] = this.checkIn;
//     data['createdAt'] = this.createdAt;
//     data['date'] = this.date;
//     data['isFullDay'] = this.isFullDay;
//     data['isHalfDay'] = this.isHalfDay;
//     data['loginTime'] = this.loginTime;
//     data['status'] = this.status;
//     data['updatedAt'] = this.updatedAt;
//     data['logoutTime'] = this.logoutTime;
//     data['workingHours'] = this.workingHours;
//     return data;
//   }
// }
