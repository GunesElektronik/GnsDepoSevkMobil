import 'package:gns_warehouse/services/sharedpreferences.dart';

class AuthenticationService{

  Future<bool> checkAuth() async {
    var _ipAddress =
    await ServiceSharedPreferences.getSharedString("ipAddress");
    var _employeeId = await ServiceSharedPreferences.getSharedInt("EmployeeID");

    if (_ipAddress != null &&
        _ipAddress != "0.0.0.0" &&
        _employeeId != null &&
        _employeeId > 0) {
      return true;
    }
    return false;
  }

}


