
import 'dart:convert';

import 'package:http/http.dart';
import 'package:progress_app/models/task.dart';
import 'package:progress_app/services/network.dart';

ApiService _apiService = ApiService();
ApiService get apiService => _apiService;

class ApiService {

  Future<void> getTask(Function callback, Function errorCallback,
    int _id) async {
    
    Response response = await networkService.getRequest('/tasks/$_id');

    if (response.statusCode == 200) {
      callback(Task.fromJson(jsonDecode(response.body)));
    } else {
      errorCallback(response);
    }
  }
  
}