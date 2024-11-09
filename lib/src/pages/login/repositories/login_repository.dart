import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../infrastructure/commons/repository_urls.dart';

class LoginRepository {
  Future<Map<String, String>> getUserCredentials() async {
    try {
      final response = await http.get(RepositoryUrls.getUsers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final Map<String, String> credentials = {
          for (var user in jsonData) user['username']: user['password']
        };
        return credentials;
      } else {
        throw Exception('Failed to load user credentials');
      }
    } catch (e) {
      throw Exception('Something went wrong: ${e.toString()}');
    }
  }

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
}
