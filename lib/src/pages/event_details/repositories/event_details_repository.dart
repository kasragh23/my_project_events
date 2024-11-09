import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/src/infrastructure/commons/repository_urls.dart';
import 'package:my_project/src/pages/event_details/models/event_detail_dto.dart';
import 'package:my_project/src/pages/event_details/models/event_details_model.dart';

class EventDetailsRepository {
  Future<Either<String, EventDetailsModel>> getEventById(int id) async{
    int? statusCode;
    try{
      final http.Response response;
      final Uri url =RepositoryUrls.getEventById(id: id);
      print('Fetching event from URL: $url'); // Debug URL
      response = await http.get(url);
      print('Response body: ${response.body}');
      statusCode = response.statusCode;
      print('Response status code: $statusCode');
      if(statusCode == 200){
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final EventDetailsModel event = EventDetailsModel.fromJson(jsonData);
        return Right(event);
      }return Left('Could not get event -> status code: $statusCode');
    }catch(e){
      return Left('something went wrong: $e -> status code: $statusCode');
    }
  }

  Future<Either<String, bool>> updateEventAttendance(int eventId, EventDetailDto dto) async {
    try {


      // Save the updated event back to the database (or JSON)
      final Uri url = RepositoryUrls.editEventById(id: eventId);  // Assuming this URL handles updates

      final response = await http.patch(
        url,
        body: json.encode(dto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left('Failed to update event');
      }
    } catch (e) {
      // If there's an error during the update process
      return Left('Failed to update attendance: $e');
    }
  }
}