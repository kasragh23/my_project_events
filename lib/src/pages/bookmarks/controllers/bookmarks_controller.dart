import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/bookmarks_dto.dart';

import '../../../infrastructure/routes/route_names.dart';
import '../../../infrastructure/utils/utils.dart';
import '../models/bookmark_events_model.dart';
import '../repositories/bookmarks_repository.dart';

class BookmarksController extends GetxController {
  final BookmarksRepository _repository = BookmarksRepository();
  final RxList<BookmarkEventsModel> bookmarks = <BookmarkEventsModel>[].obs;
  RxList<BookmarkEventsModel> filteredEvents = <BookmarkEventsModel>[].obs;
  RxString searchQuery = ''.obs; // Reactive search query
  RxBool searchingMode = false.obs;
  final searchController = TextEditingController();
  RxList bookmarkIds = [].obs;
  int? bookmarkId;
  final int userId;
  RxBool isLoading = false.obs, isRetryMode = false.obs;
  RxBool get isEmpty=> getParam().isEmpty.obs;

  BookmarksController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    getBookmarks();
  }

  Future<void> getBookmarks() async {
    isLoading.value = true;
    final resultOrException = await _repository.getBookmarks(userId);
    resultOrException.fold(
          (exception) {
            isLoading.value = false;
            isRetryMode.value = true;
        showSnackBar(exception);
      },
          (map) {
        bookmarkIds.value = map['bookmarks'];
        bookmarkId = map['bookmarkId'];
        getEventsFromBookmark();
      },
    );
  }

  String getParam() {
    String param = '';
    for (int booked in bookmarkIds) {
      param = '$param&id=$booked';
    }
    return param;
  }

  void back(){
    Get.back(result: true);
  }

  Future<void> getEventsFromBookmark() async {
    final result = await _repository.getEventsFromBookmark(getParam());
    result.fold(
          (exception) {
            isLoading.value = false;
            isRetryMode.value = true;
            showSnackBar(exception);
          },
          (event) {
             bookmarks.value = event;
             isLoading.value = false;
          },
    );
  }

  void filterEvents() {
    searchingMode.value = true;
    print(searchingMode);
    searchQuery.value = searchController.text;
    filteredEvents.value = bookmarks
        .where((event) =>
        event.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchingMode.value = false;
  }

  Future<void> toggleBookmark(int eventId) async {
    final List newBookedEvent = bookmarkIds;
    newBookedEvent.remove(eventId);
    final BookmarksDto dto =
    BookmarksDto(userId: userId, bookedEvents: newBookedEvent);
    final result = await _repository.removeBookmark(bookmarkId!, dto);
    result.fold(
          (exception) => showSnackBar(exception),
          (_) {
        // bookmarkIds.value = newBookedEvent;
        getEventsFromBookmark();
      },
    );
  }

  Future<void> goToEventDetails(int id) async {
    print('it works -> event details with id: $id');
    final result = await Get.toNamed(RouteNames.eventDetailsFromBookmark,
        parameters: {'id': '$id'});
    if (result != null) {
      getBookmarks();
    }
  }

// Future<void> removeBookmark(int eventId) async {
//   final List newBookedEvent = bookmarks;
//   newBookedEvent.remove(eventId);
//   final BookmarksDto dto =
//   BookmarksDto(userId: userId, bookedEvents: newBookedEvent);
//   final result = await _repository.removeBookmark(bookmarkId!, dto);
//   result.fold((exception) => showSnackBar(exception), (_) {
//     bookmarks.value = newBookedEvent;
//   });
// }
}
