import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:progress_app/models/user.dart';
import 'package:progress_app/services/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  Future register(String name, String email, String password, String passwordConfirmation) async {
    var deviceName = await _getDeviceInfo();
    var res = await NetworkService().postRequest('/register', 
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_name': deviceName,
      }
    );
    var body = convert.jsonDecode(res.body);

    var result = {
      'success' : false,
      'message' : body,
    };

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token',body['token']);
      localStorage.setString('user', convert.jsonEncode(body['user']));

      result = {
        'success' : true,
      };
    }

    return result;
  }

  Future login(String email, String password) async {
    var deviceName = await _getDeviceInfo();
    var res = await NetworkService().postRequest('/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      }
    );

    var result = {};

    if (res.statusCode == 200) {
      var body = convert.jsonDecode(res.body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token',body['token']);
      localStorage.setString('user', convert.jsonEncode(body['user']));

      result = {
        'success' : true,
      };
    } else if (res.statusCode == 422) {
      var body = convert.jsonDecode(res.body);
      result = {
        'success' : false,
        'message' : body,
      };
    }

    return result;
  }

  Future logout() async {
    var res = await NetworkService().postRequest('/logout', withAuth: true);
    var body = convert.jsonDecode(res.body);

    var result = {
      'success': false,
      'message': body['message'],
    };

    if (res.statusCode == 200) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();

      result = {
        'success': true,
        'message': body['message'],
      };
    }

    return result;
  }

  Future<User> getAuthUser() async {
    NetworkService networkService = NetworkService();
    var res = await networkService.getRequest('/user');

    if (res.statusCode == 200) {
      Map<String, dynamic> json = convert.jsonDecode(res.body);
      return User.fromJson(json['data']);
    } else {
      throw Exception('Failed to load User');
    }
  }

  Future<String> _getDeviceInfo() async {
    String deviceModel = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceModel = androidDeviceInfo.model!;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceModel = iosDeviceInfo.utsname.machine!;
    } else if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      deviceModel = webBrowserInfo.userAgent!;
    }

    inspect(deviceModel);

    return deviceModel.toString();
  }

}