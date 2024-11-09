import 'dart:convert';

import 'package:either_dart/either.dart';
import '../models/edit_event_model.dart';
import 'package:http/http.dart' as http;

import '../../../infrastructure/commons/repository_urls.dart';
import '../models/edit_event_dto.dart';

class EditEventRepository {
  Future<Either<String, EditEventModel>> getEventById(int id) async{
    int? statusCode;
    try{
      final http.Response response;
      final Uri url =RepositoryUrls.getEventById(id: id);
      response = await http.get(url);
      statusCode = response.statusCode;
      if(statusCode == 200){
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final EditEventModel event = EditEventModel.fromJson(jsonData);
        return Right(event);
      }return Left('Could not get event -> status code: $statusCode');
    }catch(e){
      return Left('something went wrong: $e -> status code: $statusCode');
    }
  }

  Future<Either<String, Map<String, dynamic>>> editEvent({required int id, required EditEventDto dto}) async{
    int? statusCode;
    final http.Response response;
    try {
      response = await http.patch(
        RepositoryUrls.editEventById(id: id),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toJson()),
      );
      statusCode = response.statusCode;
      print("Response Status: $statusCode");
      print("Response Body: ${response.body}");
      if (statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        return Right(result);
      } else {
        return Left('Edit todo failed with Status Code: $statusCode');
      }
    } catch (e) {
      print(e);
      return Left('something went wrong: ${e.toString()} -> status code: $statusCode');
    }
  }
}