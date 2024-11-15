import 'dart:convert';

import 'package:either_dart/either.dart';
import '../../../infrastructure/commons/repository_urls.dart';
import '../model/all_events_model.dart';
import 'package:http/http.dart' as http;
import '../model/bookmarks_dto.dart';

class AllEventsRepository {
  Future<Either<String, List<AllEventsModel>>> getAllEvents() async {
    int? statusCode;
    List<AllEventsModel> allEvents = [];
    try {
      final http.Response response;
      final Uri url = RepositoryUrls.getAllEvents;
      response = await http.get(url);
      statusCode = response.statusCode;
      if (statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        for(Map<String, dynamic> event in jsonData){
          allEvents.add(AllEventsModel.fromJson(event));
        }
        return Right(allEvents);
      }
      return Left('Bad request -> status code: $statusCode');
    } catch (e) {
      print('$e, $statusCode');
      return Left('Something went wrong $e -> status code: $statusCode');
    }
  }


  Future<Either<String, Map>> getBookmarks(int userId) async{
    int? statusCode;
    List bookmarks = [];
    int? bookmarkId;
    try {
      final http.Response response;
      final Uri url = RepositoryUrls.getBookmarksByUserId(userId);
      response = await http.get(url);
      statusCode = response.statusCode;
      if (statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if(jsonData.isEmpty){
          return Right({'bookmakrs': [], 'bookmarkId': null});
        }
        final Map<String, dynamic> result = jsonData[0];
        for(var bookmark in result['bookedEvents']){
          bookmarks.add(bookmark);
        }
        bookmarkId = result['id'];
        return Right({'bookmarks':bookmarks,'bookmarkId':bookmarkId});
      }
      return Left('Bad request -> status code: $statusCode');
    } catch (e) {
      print('$e, $statusCode');
      return Left('Something went wrong $e -> status code: $statusCode');
    }
  }

  Future<Either<String, bool>> createBookmark(BookmarksDto dto) async {
    int? statusCode;
    try {
      final Uri url = RepositoryUrls.createBookmark;
      final http.Response response = await http.post(
        url,
        body: json.encode(dto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      statusCode = response.statusCode;

      if (statusCode == 201) { // Check for successful creation status
        return const Right(true);
      }
      return Left('Failed to create bookmark -> status code: $statusCode');
    } catch (e) {
      return Left('Something went wrong: $e -> status code: $statusCode');
    }
  }



  Future<Either<String, bool>> removeBookmark(int bookmarkId, BookmarksDto dto) async {
    int? statusCode;
    final http.Response response;
    try {
      final Uri url = RepositoryUrls.removeBookmark(bookmarkId);
      response = await http.patch(
        url,
        body: json.encode(dto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      statusCode = response.statusCode;
      if (statusCode == 200) {
        return const Right(true);
      }
      return Left('Failed to add bookmark -> status code:$statusCode}');
    } catch (e) {
      return Left('something went wrong: $e -> status code: $statusCode');
    }
  }

  Future<Either<String, bool>> addBookmark(int bookmarkId, BookmarksDto dto) async {
    int? statusCode;
    final http.Response response;
    try {
      final Uri url = RepositoryUrls.addBookmark(bookmarkId);
      response = await http.patch(
        url,
        body: json.encode(dto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      statusCode = response.statusCode;
      if (statusCode == 200) {
        return const Right(true);
      }
      return Left('Failed to add bookmark -> status code:$statusCode}');
    } catch (e) {
      return Left('something went wrong: $e -> status code: $statusCode');
    }
  }

}
