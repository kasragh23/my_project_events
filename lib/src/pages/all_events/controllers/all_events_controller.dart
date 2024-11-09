import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/src/infrastructure/routes/route_names.dart';
import 'package:my_project/src/pages/all_events/model/all_events_model.dart';
import 'package:my_project/src/pages/all_events/model/bookmarks_dto.dart';
import 'package:my_project/src/pages/all_events/repositories/all_events_repository.dart';

import '../../../infrastructure/utils/utils.dart';

class AllEventsController extends GetxController {
  final AllEventsRepository _repository = AllEventsRepository();
  RxList<AllEventsModel> allEvents = <AllEventsModel>[].obs;
  RxList<dynamic> bookmarks = RxList([]);
  RxList<AllEventsModel> filteredEvents =
      <AllEventsModel>[].obs; // For filtered results
  RxString searchQuery = ''.obs; // Reactive search query
  RxBool searchingMode = false.obs;
  final searchController = TextEditingController();
  int? bookmarkId;

  final int userId;

  AllEventsController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    final resultOrException = await _repository.getAllEvents();
    resultOrException.fold(
      (exception) {
        return showSnackBar(exception);
      },
      (event) async {
        await getBookmarks();
        allEvents.value = event;
        filteredEvents.addAll(event); // Initially, show all events
      },
    );
  }

  void filterEvents() {
    searchingMode.value = true;
    print(searchingMode);
    searchQuery.value = searchController.text;
    filteredEvents.value = allEvents
        .where((event) =>
            event.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void clearSearch(){
    searchController.clear();
    searchQuery.value = '';
    searchingMode.value = false;
  }

  Future<void> getBookmarks() async {
    final resultOrException = await _repository.getBookmarks(userId);
    resultOrException.fold(
      (exception) {
        return showSnackBar(exception);
      },
      (map) {
        bookmarks.value = map['bookmarks'];
        bookmarkId = map['bookmarkId'];
      },
    );
  }

  Future<void> toggleBookmark(int eventId) async {
    if (bookmarks.contains(eventId)) {
      final List newBookedEvent = bookmarks;
      newBookedEvent.remove(eventId);
      final BookmarksDto dto =
          BookmarksDto(userId: userId, bookedEvents: newBookedEvent);
      final result = await _repository.removeBookmark(bookmarkId!, dto);
      result.fold(
        (exception) => showSnackBar(exception),
        (_) {
          getBookmarks();
        },
      );
    } else {
      final List newBookedEvent = bookmarks;
      newBookedEvent.add(eventId);
      final BookmarksDto dto =
          BookmarksDto(userId: userId, bookedEvents: newBookedEvent);
      final result = await _repository.addBookmark(bookmarkId!, dto);
      result.fold(
        (exception) => showSnackBar(exception),
        (_) {
          getBookmarks();
        },
      );
    }
  }

  Future<void> goToEventDetails(int id) async {
    print('it works -> event details with id: $id');
    final result =
        await Get.toNamed(RouteNames.eventDetails, parameters: {'id': '$id'});
    if (result != null) {
      getAllEvents();
    }
  }

  Future<void> goToMyEvents() async {
    await Get.toNamed(RouteNames.myEvents,
        parameters: {'userId': userId.toString()});
    getAllEvents();
  }

  Future<void> goToBookmarks() async {
    final result = await Get.toNamed(RouteNames.bookmarks,
        parameters: {'userId': userId.toString()}, arguments: bookmarks);
    if(result != null){
      getAllEvents();
    }
  }
}
