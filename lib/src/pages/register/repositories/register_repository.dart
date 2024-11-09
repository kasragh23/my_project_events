import 'dart:convert';

import 'package:either_dart/either.dart';
import '/src/infrastructure/commons/repository_urls.dart';
import '../model/register_dto.dart';
import 'package:http/http.dart' as http;

class RegisterRepository {
  Future <Either<String, bool>> registerUser({required RegisterDto dto}) async {
    int? statusCode;
    try {
      final http.Response response;
      final body = json.encode(dto.toJson());

      response = await http.post(RepositoryUrls.registerUser,
        body: body,
        headers: {'Content-type': 'application/json'},
      );
      statusCode = response.statusCode;
      print(response.body);
      if(statusCode == 201){
        return const Right(true);
      }
      return Left('bad request -> status code $statusCode');

    }
    catch(e){
      return Left('an error occurred: $e -> status code: $statusCode}');
    }
  }
}
