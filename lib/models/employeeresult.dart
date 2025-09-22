class EmployeeResult {
  String? code;
  String? userUid;
  String? token;
  String? fullName;
  String? uEmail;

  EmployeeResult(
      {this.code, this.userUid, this.token, this.fullName, this.uEmail});

  factory EmployeeResult.fromJson(Map<String, dynamic> json) {
    return EmployeeResult(
      code: json['uCode'],
      userUid: json['userId'],
      token: json['uToken'],
      fullName: json['uFullName'],
      uEmail: json['uEmail'],
    );
  }
}
