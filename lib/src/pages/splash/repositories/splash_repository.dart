import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../infrastructure/commons/repository_urls.dart';

class SplashRepository {
  Future<int> getUserId(String username) async {
    try {
      final response = await http.get(RepositoryUrls.getUsers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final user =
        jsonData.firstWhere((user) => user['username'] == username);
        return user['id'];
      } else {
        throw Exception('Failed to load user ID');
      }
    } catch (e) {
      throw Exception('Something went wrong: ${e.toString()}');
    }
  }

  Future<bool> checkServerStatus() async{
    int? statusCode;
    try{
      final respone = await http.get(RepositoryUrls.getDatabase);
      statusCode = respone.statusCode;
      if(statusCode == 200){
        return true;
      }
      return false;
    }catch(e){
      print('something went wrong $e -> $statusCode');
      return false;
    }
  }
}