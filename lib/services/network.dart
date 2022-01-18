import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

NetworkService _networkService = NetworkService();
NetworkService get networkService => _networkService;

class NetworkService {
  final String baseUrl = 'http://192.168.0.187:8000/api';
  String? token;

  Future<http.Response> getRequest(String path) async {
    var url = Uri.parse(baseUrl + path);

    await _getToken();

    return await http.get(
      url, 
      headers: _setHeaders(),
    );
  }

  Future<http.Response> postRequest(String path, {Map? data, withAuth = false}) async {
    var url = Uri.parse(baseUrl + path);

    if (withAuth) {
      await _getToken();
    }

    return await http.post(
      url, 
      headers: _setHeaders(),
      body: data,
    );
  }

  Future<http.Response> deleteRequest(String path, Map data) async {
    var url = Uri.parse(baseUrl + path);

    await _getToken();

    return await http.delete(
      url, 
      headers: _setHeaders(),
      body: data,
    );
  }

  _setHeaders() => {
    HttpHeaders.acceptHeader : 'application/json',
    HttpHeaders.authorizationHeader : 'Bearer $token'
  };

  _getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token')!;
  }

}
