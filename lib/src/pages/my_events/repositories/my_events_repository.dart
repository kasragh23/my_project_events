import 'dart:convert';

import 'package:either_dart/either.dart';
import '../../../infrastructure/commons/repository_urls.dart';
import 'package:http/http.dart' as http;

import '../model/my_events_model.dart';

class MyEventsRepository {
  Future<Either<String, List<MyEventsModel>>> getMyEvents(int userId) async{
  int? statusCode;
  List<MyEventsModel> myEvents= [];
    try{
      final http.Response response;
      final Uri url = RepositoryUrls.getEventsByUserId(id: userId);
      response = await http.get(url);
      statusCode = response.statusCode;
      if(statusCode == 200){
        print(response.body);
        final List<dynamic> jsonData = json.decode(response.body);
        for(Map<String, dynamic> event in jsonData){
          myEvents.add(MyEventsModel.fromJson(event));
        }
        print(myEvents);
        return Right(myEvents);
      }
      return Left('Bad request -> status code: $statusCode');
    }catch(e){
      print(e);
      return Left('Something went wrong $e -> status code: $statusCode');
    }
  }
  Future<Either<String, MyEventsModel>> getEventById(int eventId) async {
    int? statusCode;
    try {
      final http.Response response;
      final Uri url = RepositoryUrls.editEventById(id: eventId);
      response = await http.get(url);
      statusCode = response.statusCode;
      if (statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final result = MyEventsModel.fromJson(jsonData);
        return Right(result);
      }
      return Left('Could not get event -> Status code: $statusCode');
    } catch (e) {
      return Left('Something went wrong: $e -> Status code: $statusCode');
    }
  }
  Future<Either<String, bool>> deleteEvent({required int id}) async {
    int? statusCode;
    try {
      final http.Response response = await http.delete(
        RepositoryUrls.deleteEventById(id: id),
        headers: {'Content-Type': 'application/json'},
      );
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        return const Right(true);
      }else{
        return Left('error $statusCode');
      }

    } catch (e) {
      return Left('something went wrong$e -> statusCode: $statusCode');
    }
  }


}