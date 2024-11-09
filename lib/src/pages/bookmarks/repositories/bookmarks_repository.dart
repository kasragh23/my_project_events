import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/src/pages/bookmarks/models/bookmark_events_model.dart';
import '../../../infrastructure/commons/repository_urls.dart';
import '../models/bookmarks_dto.dart';

class BookmarksRepository {
  Future<Either<String, Map>> getBookmarks(int userId) async {
    List<dynamic> bookmarks = [];
    int? bookmarkId;
    List? bookedEvents;
    final Uri url = RepositoryUrls.getBookmarksByUserId(userId);
    int? statusCode;
    final http.Response response;
    try {
      response = await http.get(url);
      print(response.body);
      statusCode = response.statusCode;
      if (statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final Map<String, dynamic> result = jsonData[0];
        for (var bookmark in result['bookedEvents']) {
          bookmarks.add(bookmark);
        }
        bookmarkId = result['id'];
        bookedEvents = result['bookedEvents'];
        return Right({
          'bookmarks': bookmarks,
          'bookmarkId': bookmarkId,
          'bookedEvents': bookedEvents
        });
      }
      return Left('Failed to get Bookmarks -> status code: $statusCode');
    } catch (e) {
      print("$e , $statusCode");
      return Left('something went wrong: $e -> status code: $statusCode');
    }
  }


  Future<Either<String, List<BookmarkEventsModel>>> getEventsFromBookmark(
      String param) async {
    int? statusCode;
    final http.Response response;
    List<BookmarkEventsModel> bookmarks = [];
    try {
      final Uri url = RepositoryUrls.getBookedEvents(param);
      response = await http.get(
        url,
      );
      statusCode = response.statusCode;
      if (statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        for (Map<String, dynamic> bookmark in jsonData) {
          bookmarks.add(BookmarkEventsModel.fromJson(bookmark));
        }
        return Right(bookmarks);
      }
      return Left('Failed to add bookmark -> status code:$statusCode}');
    } catch (e) {
      return Left('something went wrong: $e -> status code: $statusCode');
    }
  }


  Future<Either<String, bool>> removeBookmark(int bookmarkId,
      BookmarksDto dto) async {
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
}
