class EmpSalarySlipEmpSideModel {
  bool? success;
  String? message;
  Data? data;

  EmpSalarySlipEmpSideModel({this.success, this.message, this.data});

  EmpSalarySlipEmpSideModel.fromJson(Map<String, dynamic> json) {
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
  EmployeeData? employeeData;
  WorkData? workData;
  String? salary;
  int? absentDays;
  int? totalDays;
  int? presentDays;
  int? estimateSalary;

  Data(
      {this.employeeData,
        this.workData,
        this.salary,
        this.absentDays,
        this.totalDays,
        this.presentDays,
        this.estimateSalary});

  Data.fromJson(Map<String, dynamic> json) {
    employeeData = json['employeeData'] != null
        ? new EmployeeData.fromJson(json['employeeData'])
        : null;
    workData = json['work_data'] != null
        ? new WorkData.fromJson(json['work_data'])
        : null;
    salary = json['salary'];
    absentDays = json['absentDays'];
    totalDays = json['totalDays'];
    presentDays = json['presentDays'];
    estimateSalary = json['estimate_salary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employeeData != null) {
      data['employeeData'] = this.employeeData!.toJson();
    }
    if (this.workData != null) {
      data['work_data'] = this.workData!.toJson();
    }
    data['salary'] = this.salary;
    data['absentDays'] = this.absentDays;
    data['totalDays'] = this.totalDays;
    data['presentDays'] = this.presentDays;
    data['estimate_salary'] = this.estimateSalary;
    return data;
  }
}

class EmployeeData {
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
  String? maritalStatus;
  String? children;
  String? emergencyContact;
  String? empId;
  String? role;
  String? token;
  Null? employeeDocumentId;
  String? fcmToken;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? registrationId;
  String? workId;
  String? leaveID;
  String? password;

  EmployeeData(
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
        this.maritalStatus,
        this.children,
        this.emergencyContact,
        this.empId,
        this.role,
        this.token,
        this.employeeDocumentId,
        this.fcmToken,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.registrationId,
        this.workId,
        this.leaveID,
        this.password});

  EmployeeData.fromJson(Map<String, dynamic> json) {
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
    maritalStatus = json['maritalStatus'];
    children = json['children'];
    emergencyContact = json['emergencyContact'];
    empId = json['empId'];
    role = json['role'];
    token = json['token'];
    employeeDocumentId = json['employeeDocumentId'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    registrationId = json['registrationId'];
    workId = json['workId'];
    leaveID = json['leaveID'];
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
    data['maritalStatus'] = this.maritalStatus;
    data['children'] = this.children;
    data['emergencyContact'] = this.emergencyContact;
    data['empId'] = this.empId;
    data['role'] = this.role;
    data['token'] = this.token;
    data['employeeDocumentId'] = this.employeeDocumentId;
    data['fcmToken'] = this.fcmToken;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['registrationId'] = this.registrationId;
    data['workId'] = this.workId;
    data['leaveID'] = this.leaveID;
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

class WorkData {
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
  String? shiftInformation;
  String? updatedAt;
  String? workLocation;
  String? workType;

  WorkData(
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
        this.shiftInformation,
        this.updatedAt,
        this.workLocation,
        this.workType});

  WorkData.fromJson(Map<String, dynamic> json) {
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
    shiftInformation = json['shiftInformation'];
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
    data['shiftInformation'] = this.shiftInformation;
    data['updatedAt'] = this.updatedAt;
    data['workLocation'] = this.workLocation;
    data['workType'] = this.workType;
    return data;
  }
}




// class EmpSalarySlipEmpSideModel {
//   bool? success;
//   String? message;
//   Data? data;
//
//   EmpSalarySlipEmpSideModel({this.success, this.message, this.data});
//
//   EmpSalarySlipEmpSideModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   EmployeeData? employeeData;
//   Null? workData;
//   int? salary;
//   int? absentDays;
//   int? totalDays;
//   int? presentDays;
//   int? estimateSalary;
//
//   Data(
//       {this.employeeData,
//         this.workData,
//         this.salary,
//         this.absentDays,
//         this.totalDays,
//         this.presentDays,
//         this.estimateSalary});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     employeeData = json['employeeData'] != null
//         ? new EmployeeData.fromJson(json['employeeData'])
//         : null;
//     workData = json['work_data'];
//     salary = json['salary'];
//     absentDays = json['absentDays'];
//     totalDays = json['totalDays'];
//     presentDays = json['presentDays'];
//     estimateSalary = json['estimate_salary'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.employeeData != null) {
//       data['employeeData'] = this.employeeData!.toJson();
//     }
//     data['work_data'] = this.workData;
//     data['salary'] = this.salary;
//     data['absentDays'] = this.absentDays;
//     data['totalDays'] = this.totalDays;
//     data['presentDays'] = this.presentDays;
//     data['estimate_salary'] = this.estimateSalary;
//     return data;
//   }
// }
//
// class EmployeeData {
//   EmployeeImage? employeeImage;
//   EmployeeImage? employeeIdCard;
//   EmployeeImage? employeeDocument;
//   String? sId;
//   String? name;
//   String? email;
//   String? workEmail;
//   String? mobile;
//   String? dob;
//   String? gender;
//   String? address;
//   String? state;
//   String? city;
//   String? qualification;
//   String? maritalStatus;
//   String? empId;
//   String? role;
//   String? token;
//   Null? employeeDocumentId;
//   String? fcmToken;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//   String? registrationId;
//
//   EmployeeData(
//       {this.employeeImage,
//         this.employeeIdCard,
//         this.employeeDocument,
//         this.sId,
//         this.name,
//         this.email,
//         this.workEmail,
//         this.mobile,
//         this.dob,
//         this.gender,
//         this.address,
//         this.state,
//         this.city,
//         this.qualification,
//         this.maritalStatus,
//         this.empId,
//         this.role,
//         this.token,
//         this.employeeDocumentId,
//         this.fcmToken,
//         this.createdAt,
//         this.updatedAt,
//         this.iV,
//         this.registrationId});
//
//   EmployeeData.fromJson(Map<String, dynamic> json) {
//     employeeImage = json['employeeImage'] != null
//         ? new EmployeeImage.fromJson(json['employeeImage'])
//         : null;
//     employeeIdCard = json['employeeIdCard'] != null
//         ? new EmployeeImage.fromJson(json['employeeIdCard'])
//         : null;
//     employeeDocument = json['employeeDocument'] != null
//         ? new EmployeeImage.fromJson(json['employeeDocument'])
//         : null;
//     sId = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     workEmail = json['workEmail'];
//     mobile = json['mobile'];
//     dob = json['dob'];
//     gender = json['gender'];
//     address = json['address'];
//     state = json['state'];
//     city = json['city'];
//     qualification = json['qualification'];
//     maritalStatus = json['maritalStatus'];
//     empId = json['empId'];
//     role = json['role'];
//     token = json['token'];
//     employeeDocumentId = json['employeeDocumentId'];
//     fcmToken = json['fcmToken'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//     registrationId = json['registrationId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.employeeImage != null) {
//       data['employeeImage'] = this.employeeImage!.toJson();
//     }
//     if (this.employeeIdCard != null) {
//       data['employeeIdCard'] = this.employeeIdCard!.toJson();
//     }
//     if (this.employeeDocument != null) {
//       data['employeeDocument'] = this.employeeDocument!.toJson();
//     }
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['workEmail'] = this.workEmail;
//     data['mobile'] = this.mobile;
//     data['dob'] = this.dob;
//     data['gender'] = this.gender;
//     data['address'] = this.address;
//     data['state'] = this.state;
//     data['city'] = this.city;
//     data['qualification'] = this.qualification;
//     data['maritalStatus'] = this.maritalStatus;
//     data['empId'] = this.empId;
//     data['role'] = this.role;
//     data['token'] = this.token;
//     data['employeeDocumentId'] = this.employeeDocumentId;
//     data['fcmToken'] = this.fcmToken;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     data['registrationId'] = this.registrationId;
//     return data;
//   }
// }
//
// class EmployeeImage {
//   String? publicId;
//   String? secureUrl;
//
//   EmployeeImage({this.publicId, this.secureUrl});
//
//   EmployeeImage.fromJson(Map<String, dynamic> json) {
//     publicId = json['public_id'];
//     secureUrl = json['secure_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['public_id'] = this.publicId;
//     data['secure_url'] = this.secureUrl;
//     return data;
//   }
// }
//
//
//
// /*
// // class EmpSalarySlipEmpSideModel {
// //   bool? success;
// //   String? message;
// //   Data? data;
// //
// //   EmpSalarySlipEmpSideModel({this.success, this.message, this.data});
// //
// //   EmpSalarySlipEmpSideModel.fromJson(Map<String, dynamic> json) {
// //     success = json['success'];
// //     message = json['message'];
// //     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['success'] = this.success;
// //     data['message'] = this.message;
// //     if (this.data != null) {
// //       data['data'] = this.data!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Data {
// //   EmployeeData? employeeData;
// //   WorkData? workData;
// //   String? salary;
// //   int? absentDays;
// //   int? totalDays;
// //   int? presentDays;
// //   double? estimateSalary;
// //
// //   Data(
// //       {this.employeeData,
// //         this.workData,
// //         this.salary,
// //         this.absentDays,
// //         this.totalDays,
// //         this.presentDays,
// //         this.estimateSalary});
// //
// //   Data.fromJson(Map<String, dynamic> json) {
// //     employeeData = json['employeeData'] != null
// //         ? new EmployeeData.fromJson(json['employeeData'])
// //         : null;
// //     workData = json['work_data'] != null
// //         ? new WorkData.fromJson(json['work_data'])
// //         : null;
// //     salary = json['salary'];
// //     absentDays = json['absentDays'];
// //     totalDays = json['totalDays'];
// //     presentDays = json['presentDays'];
// //     estimateSalary = json['estimate_salary'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     if (this.employeeData != null) {
// //       data['employeeData'] = this.employeeData!.toJson();
// //     }
// //     if (this.workData != null) {
// //       data['work_data'] = this.workData!.toJson();
// //     }
// //     data['salary'] = this.salary;
// //     data['absentDays'] = this.absentDays;
// //     data['totalDays'] = this.totalDays;
// //     data['presentDays'] = this.presentDays;
// //     data['estimate_salary'] = this.estimateSalary;
// //     return data;
// //   }
// // }
// //
// // class EmployeeData {
// //   EmployeeImage? employeeImage;
// //   EmployeeImage? employeeIdCard;
// //   EmployeeImage? employeeDocument;
// //   String? sId;
// //   String? name;
// //   String? email;
// //   String? workEmail;
// //   String? alternateMobile;
// //   String? mobile;
// //   String? dob;
// //   String? gender;
// //   String? address;
// //   String? state;
// //   String? city;
// //   String? qualification;
// //   String? experience;
// //   String? maritalStatus;
// //   String? children;
// //   String? emergencyContact;
// //   String? role;
// //   String? token;
// //   Null? employeeDocumentId;
// //   String? fcmToken;
// //   String? createdAt;
// //   String? updatedAt;
// //   int? iV;
// //   String? registrationId;
// //   String? workId;
// //
// //   EmployeeData(
// //       {this.employeeImage,
// //         this.employeeIdCard,
// //         this.employeeDocument,
// //         this.sId,
// //         this.name,
// //         this.email,
// //         this.workEmail,
// //         this.alternateMobile,
// //         this.mobile,
// //         this.dob,
// //         this.gender,
// //         this.address,
// //         this.state,
// //         this.city,
// //         this.qualification,
// //         this.experience,
// //         this.maritalStatus,
// //         this.children,
// //         this.emergencyContact,
// //         this.role,
// //         this.token,
// //         this.employeeDocumentId,
// //         this.fcmToken,
// //         this.createdAt,
// //         this.updatedAt,
// //         this.iV,
// //         this.registrationId,
// //         this.workId});
// //
// //   EmployeeData.fromJson(Map<String, dynamic> json) {
// //     employeeImage = json['employeeImage'] != null
// //         ? new EmployeeImage.fromJson(json['employeeImage'])
// //         : null;
// //     employeeIdCard = json['employeeIdCard'] != null
// //         ? new EmployeeImage.fromJson(json['employeeIdCard'])
// //         : null;
// //     employeeDocument = json['employeeDocument'] != null
// //         ? new EmployeeImage.fromJson(json['employeeDocument'])
// //         : null;
// //     sId = json['_id'];
// //     name = json['name'];
// //     email = json['email'];
// //     workEmail = json['workEmail'];
// //     alternateMobile = json['alternateMobile'];
// //     mobile = json['mobile'];
// //     dob = json['dob'];
// //     gender = json['gender'];
// //     address = json['address'];
// //     state = json['state'];
// //     city = json['city'];
// //     qualification = json['qualification'];
// //     experience = json['experience'];
// //     maritalStatus = json['maritalStatus'];
// //     children = json['children'];
// //     emergencyContact = json['emergencyContact'];
// //     role = json['role'];
// //     token = json['token'];
// //     employeeDocumentId = json['employeeDocumentId'];
// //     fcmToken = json['fcmToken'];
// //     createdAt = json['createdAt'];
// //     updatedAt = json['updatedAt'];
// //     iV = json['__v'];
// //     registrationId = json['registrationId'];
// //     workId = json['workId'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     if (this.employeeImage != null) {
// //       data['employeeImage'] = this.employeeImage!.toJson();
// //     }
// //     if (this.employeeIdCard != null) {
// //       data['employeeIdCard'] = this.employeeIdCard!.toJson();
// //     }
// //     if (this.employeeDocument != null) {
// //       data['employeeDocument'] = this.employeeDocument!.toJson();
// //     }
// //     data['_id'] = this.sId;
// //     data['name'] = this.name;
// //     data['email'] = this.email;
// //     data['workEmail'] = this.workEmail;
// //     data['alternateMobile'] = this.alternateMobile;
// //     data['mobile'] = this.mobile;
// //     data['dob'] = this.dob;
// //     data['gender'] = this.gender;
// //     data['address'] = this.address;
// //     data['state'] = this.state;
// //     data['city'] = this.city;
// //     data['qualification'] = this.qualification;
// //     data['experience'] = this.experience;
// //     data['maritalStatus'] = this.maritalStatus;
// //     data['children'] = this.children;
// //     data['emergencyContact'] = this.emergencyContact;
// //     data['role'] = this.role;
// //     data['token'] = this.token;
// //     data['employeeDocumentId'] = this.employeeDocumentId;
// //     data['fcmToken'] = this.fcmToken;
// //     data['createdAt'] = this.createdAt;
// //     data['updatedAt'] = this.updatedAt;
// //     data['__v'] = this.iV;
// //     data['registrationId'] = this.registrationId;
// //     data['workId'] = this.workId;
// //     return data;
// //   }
// // }
// //
// // class EmployeeImage {
// //   String? publicId;
// //   String? secureUrl;
// //
// //   EmployeeImage({this.publicId, this.secureUrl});
// //
// //   EmployeeImage.fromJson(Map<String, dynamic> json) {
// //     publicId = json['public_id'];
// //     secureUrl = json['secure_url'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['public_id'] = this.publicId;
// //     data['secure_url'] = this.secureUrl;
// //     return data;
// //   }
// // }
// //
// // class WorkData {
// //   String? sId;
// //   String? employeeId;
// //   int? iV;
// //   String? company;
// //   String? createdAt;
// //   String? department;
// //   String? employeeType;
// //   String? jobPosition;
// //   String? joiningDate;
// //   String? reportingManager;
// //   String? salary;
// //   String? shiftInformation;
// //   String? updatedAt;
// //   String? workLocation;
// //   String? workType;
// //
// //   WorkData(
// //       {this.sId,
// //         this.employeeId,
// //         this.iV,
// //         this.company,
// //         this.createdAt,
// //         this.department,
// //         this.employeeType,
// //         this.jobPosition,
// //         this.joiningDate,
// //         this.reportingManager,
// //         this.salary,
// //         this.shiftInformation,
// //         this.updatedAt,
// //         this.workLocation,
// //         this.workType});
// //
// //   WorkData.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     employeeId = json['employeeId'];
// //     iV = json['__v'];
// //     company = json['company'];
// //     createdAt = json['createdAt'];
// //     department = json['department'];
// //     employeeType = json['employeeType'];
// //     jobPosition = json['jobPosition'];
// //     joiningDate = json['joiningDate'];
// //     reportingManager = json['reportingManager'];
// //     salary = json['salary'];
// //     shiftInformation = json['shiftInformation'];
// //     updatedAt = json['updatedAt'];
// //     workLocation = json['workLocation'];
// //     workType = json['workType'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['employeeId'] = this.employeeId;
// //     data['__v'] = this.iV;
// //     data['company'] = this.company;
// //     data['createdAt'] = this.createdAt;
// //     data['department'] = this.department;
// //     data['employeeType'] = this.employeeType;
// //     data['jobPosition'] = this.jobPosition;
// //     data['joiningDate'] = this.joiningDate;
// //     data['reportingManager'] = this.reportingManager;
// //     data['salary'] = this.salary;
// //     data['shiftInformation'] = this.shiftInformation;
// //     data['updatedAt'] = this.updatedAt;
// //     data['workLocation'] = this.workLocation;
// //     data['workType'] = this.workType;
// //     return data;
// //   }
// // }
// */
