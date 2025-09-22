class LicenseCheckResult{
  bool isSuccess = false;
  String message = '';
  String? customerCode;
  String? customerName;
  String? productName;
  String? apiUrl;


  LicenseCheckResult({required this.isSuccess, required this.message, this.customerCode, this.customerName, this.productName, this.apiUrl});

  factory LicenseCheckResult.fromJson(Map<String, dynamic> json) {
    return LicenseCheckResult(
        isSuccess: json['isSuccess'],
        message: json['message'],
        customerCode: json['customerCode'],
        customerName: json['customerName'],
        productName: json['productName'],
        apiUrl: json['apiUrl'],
    );
  }
}