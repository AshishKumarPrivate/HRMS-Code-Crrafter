class AdminFilterAttendanceModel {
  String? message;
  bool? success;
  int? count;
  List<AttendanceData>? attendanceData;
  List<Data>? data;

  AdminFilterAttendanceModel(
      {this.message, this.success, this.count, this.attendanceData, this.data});

  AdminFilterAttendanceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    count = json['count'];
    if (json['attendanceData'] != null) {
      attendanceData = <AttendanceData>[];
      json['attendanceData'].forEach((v) {
        attendanceData!.add(new AttendanceData.fromJson(v));
      });
    }
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
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.attendanceData != null) {
      data['attendanceData'] =
          this.attendanceData!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceData {
  Location? location;
  String? sId;
  EmployeeId? employeeId;
  String? loginTime;
  String? logoutTime;
  String? totalWorkingHour;
  String? status;
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

  AttendanceData(
      {this.location,
        this.sId,
        this.employeeId,
        this.loginTime,
        this.logoutTime,
        this.totalWorkingHour,
        this.status,
        this.otTime,
        this.isHalfDay,
        this.isFullDay,
        this.workingHours,
        this.checkIn,
        this.leave,
        this.date,
        this.iV,
        this.createdAt,
        this.updatedAt});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    employeeId = json['employeeId'] != null
        ? new EmployeeId.fromJson(json['employeeId'])
        : null;
    loginTime = json['loginTime'];
    logoutTime = json['logoutTime'];
    totalWorkingHour = json['totalWorkingHour'];
    status = json['status'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    if (this.employeeId != null) {
      data['employeeId'] = this.employeeId!.toJson();
    }
    data['loginTime'] = this.loginTime;
    data['logoutTime'] = this.logoutTime;
    data['totalWorkingHour'] = this.totalWorkingHour;
    data['status'] = this.status;
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

class EmployeeId {
  String? sId;
  String? name;
  String? email;
  String? mobile;

  EmployeeId({this.sId, this.name, this.email, this.mobile});

  EmployeeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}

class Data {
  String? sId;
  String? employeeId;
  bool? checkIn;
  bool? leave;
  String? date;
  String? createdAt;
  String? updatedAt;
  Employee? employee;
  String? checkOutTime;
  String? workDuration;
  String? status;

  Data(
      {this.sId,
        this.employeeId,
        this.checkIn,
        this.leave,
        this.date,
        this.createdAt,
        this.updatedAt,
        this.employee,
        this.checkOutTime,
        this.workDuration,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employeeId = json['employeeId'];
    checkIn = json['checkIn'];
    leave = json['leave'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    checkOutTime = json['checkOutTime'];
    workDuration = json['workDuration'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['employeeId'] = this.employeeId;
    data['checkIn'] = this.checkIn;
    data['leave'] = this.leave;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    data['checkOutTime'] = this.checkOutTime;
    data['workDuration'] = this.workDuration;
    data['status'] = this.status;
    return data;
  }
}

class Employee {
  String? name;
  String? email;
  String? mobile;

  Employee({this.name, this.email, this.mobile});

  Employee.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}





// class AdminFilterAttendanceModel {
//   String? message;
//   bool? success;
//   int? count;
//   List<Data>? data;
//
//   AdminFilterAttendanceModel(
//       {this.message, this.success, this.count, this.data});
//
//   AdminFilterAttendanceModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     success = json['success'];
//     count = json['count'];
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
//     data['message'] = this.message;
//     data['success'] = this.success;
//     data['count'] = this.count;
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
//   bool? isHalfDay;
//   bool? isFullDay;
//   bool? checkIn;
//   String? date;
//   String? createdAt;
//   String? updatedAt;
//   String? loginTime;
//   String? status;
//   String? logoutTime;
//   String? workingHours;
//   String? otTime;
//   Employee? employee;
//
//   Data(
//       {this.sId,
//         this.employeeId,
//         this.isHalfDay,
//         this.isFullDay,
//         this.checkIn,
//         this.date,
//         this.createdAt,
//         this.updatedAt,
//         this.loginTime,
//         this.status,
//         this.logoutTime,
//         this.workingHours,
//         this.otTime,
//         this.employee});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     employeeId = json['employeeId'];
//     isHalfDay = json['isHalfDay'];
//     isFullDay = json['isFullDay'];
//     checkIn = json['checkIn'];
//     date = json['date'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     loginTime = json['loginTime'];
//     status = json['status'];
//     logoutTime = json['logoutTime'];
//     workingHours = json['workingHours'];
//     otTime = json['otTime'];
//     employee = json['employee'] != null
//         ? new Employee.fromJson(json['employee'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['employeeId'] = this.employeeId;
//     data['isHalfDay'] = this.isHalfDay;
//     data['isFullDay'] = this.isFullDay;
//     data['checkIn'] = this.checkIn;
//     data['date'] = this.date;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['loginTime'] = this.loginTime;
//     data['status'] = this.status;
//     data['logoutTime'] = this.logoutTime;
//     data['workingHours'] = this.workingHours;
//     data['otTime'] = this.workingHours;
//     if (this.employee != null) {
//       data['employee'] = this.employee!.toJson();
//     }
//     return data;
//   }
// }
//
// class Employee {
//   String? name;
//   String? email;
//   String? mobile;
//
//   Employee({this.name, this.email, this.mobile});
//
//   Employee.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     email = json['email'];
//     mobile = json['mobile'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['mobile'] = this.mobile;
//     return data;
//   }
// }
