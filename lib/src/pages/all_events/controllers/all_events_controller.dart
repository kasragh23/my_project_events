import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../model/all_events_model.dart';
import '../model/bookmarks_dto.dart';
import '../repositories/all_events_repository.dart';

import '../../../infrastructure/utils/utils.dart';

class AllEventsController extends GetxController {
  final AllEventsRepository _repository = AllEventsRepository();
  RxList<AllEventsModel> allEvents = <AllEventsModel>[].obs;
  RxList<dynamic> bookmarks = RxList([]);
  RxList<AllEventsModel> filteredEvents =
      <AllEventsModel>[].obs; // For filtered results
  RxString searchQuery = ''.obs; // Reactive search query
  RxBool searchingMode = false.obs;
  RxBool filterByTimeEnabled = false.obs;
  RxBool filterByCapacityEnabled = false.obs;
  final searchController = TextEditingController();
  int? bookmarkId;
  RxInt minPrice = 0.obs;
  RxInt maxPrice = 1000.obs;
  RxInt selectedMinPrice = 0.obs;
  RxInt selectedMaxPrice = 1000.obs;
  final int userId;
  RxBool sortByDateAscending = false.obs;
  RxBool sortByCapacityAscending = false.obs;
  RxBool isLoading = false.obs, isRetryMode = false.obs;

  AllEventsController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    isLoading.value = true;
    final resultOrException = await _repository.getAllEvents();
    resultOrException.fold(
      (exception) {
        isRetryMode.value = true;
        isLoading.value = false;
        return showSnackBar(exception);
      },
      (event) async {
          allEvents.value = event;
          filteredEvents.addAll(event);
          // Initially, show all events
          setMinMaxPrice();
          await getBookmarks();
          isLoading.value = false;
      },
    );
  }

  void searchEvents() {
    searchingMode.value = true;
    searchQuery.value = searchController.text;
    List<AllEventsModel> tempList = allEvents
        .where((event) =>
            event.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
    filteredEvents.value = tempList;
  }

  void filterEventsByPrice() {
    searchingMode.value = true;
    searchQuery.value = searchController.text;
    List<AllEventsModel> tempList = allEvents
        .where((event) =>
            event.price >= selectedMinPrice.value &&
            event.price <= selectedMaxPrice.value)
        .toList();
    filteredEvents.value = tempList;

    if (filterByTimeEnabled.value) filterEventsByTime();
    if (filterByCapacityEnabled.value) filterEventsByCapacity();
  }

  void filterEventsByTime() {
    // Show only events with available time (future events)
    List<AllEventsModel> tempList = <AllEventsModel>[].obs;
    if (filterByTimeEnabled.value) {
      tempList = allEvents.where((event) {
        final currentDate = DateTime.now();
        return event.date!.isAfter(currentDate); // Future events only
      }).toList();
    }

    filteredEvents.value = tempList;
  }

  void filterEventsByCapacity() {
    // Show only events with available capacity
    List<AllEventsModel> tempList = <AllEventsModel>[].obs;

    if (filterByCapacityEnabled.value) {
      tempList = allEvents.where((event) {
        final availableCapacity = event.capacity - event.attendance!;
        return availableCapacity > 0; // Events with capacity left
      }).toList();
    }

    filteredEvents.value = tempList;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchingMode.value = false;
  }

  void setMinMaxPrice() {
    if (allEvents.isNotEmpty) {
      minPrice.value = allEvents.map((event) => event.price).reduce(min);
      maxPrice.value = allEvents.map((event) => event.price).reduce(max);
      selectedMinPrice.value = minPrice.value;
      selectedMaxPrice.value = maxPrice.value;
      filterEventsByPrice();
    }
  }

  void onPriceRangeChanged(RangeValues values) {
    minPrice.value = values.start.toInt();
    maxPrice.value = values.end.toInt();
    filterEventsByPrice();
  }


  Future<void> getBookmarks() async {
    final resultOrException = await _repository.getBookmarks(userId);
    resultOrException.fold(
      (exception) {
        return showSnackBar(exception);
      },
      (map) {
        if(map['bookmarkId']==null){
          isLoading.value = false;
          return;
        }
        bookmarks.value = map['bookmarks'];
        bookmarkId = map['bookmarkId'];
        print(bookmarkId);
      },
    );
  }

  Future<void> toggleBookmark(int eventId) async {
    if (bookmarkId == null) {
      // No bookmark entry exists; create one
      final List newBookedEvent = [eventId];
      final BookmarksDto dto =
          BookmarksDto(userId: userId, bookedEvents: newBookedEvent);

      final result = await _repository.createBookmark(dto);
      result.fold(
        (exception) => showSnackBar(exception),
        (_) {
          getBookmarks(); // Reload bookmarks after creation
        },
      );
    } else {
      // Bookmark entry exists; toggle normally
      if (bookmarks.contains(eventId)) {
        // Remove bookmark
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
        // Add bookmark
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
    print('when?');
    getAllEvents();
  }

  Future<void> goToBookmarks() async {
    final result = await Get.toNamed(RouteNames.bookmarks,
        parameters: {'userId': userId.toString()}, arguments: bookmarks);
    if (result != null) {
      getAllEvents();
    }
  }

  Future<void> clearStayLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('stayLoggedIn');
  }

  void logout() {
    clearStayLoggedIn();
    Get.offAllNamed(RouteNames.login);
  }
}
