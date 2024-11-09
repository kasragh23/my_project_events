import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:my_project/src/infrastructure/commons/repository_urls.dart';
import 'package:http/http.dart' as http;

import '../model/add_event_dto.dart';

class MyEventsRepository {
  Future<Either<String, bool>> addEvent({required AddEventDto dto}) async{
  int? statusCode;
    try{
      final http.Response response;
      final body =json.encode(dto.toJson());

      response = await http.post(
        RepositoryUrls.addEvent,
        body: body,
          headers: {'Content-type': 'application/json'}
      );
      statusCode = response.statusCode;
      if(statusCode == 201){
        print(response.body);
        return const Right(true);
      }
      return Left('Bad request -> status code: $statusCode');
    }catch(e){
      return Left('Something went wrong $e -> status code: $statusCode');
    }
  }
}