import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final searchController = TextEditingController();
  int? bookmarkId;
  RxInt minPrice = 0.obs;
  RxInt maxPrice = 1000.obs;
  RxInt selectedMinPrice = 0.obs;
  RxInt selectedMaxPrice = 1000.obs;
  final int userId;
  RxBool sortByDateAscending = false.obs;
  RxBool sortByCapacityAscending = false.obs;
  RxBool isLoading = true.obs, isRetryMode = false.obs;

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
        isRetryMode.value = true;
        isLoading.value = false;
        return showSnackBar(exception);
      },
      (event) async {
        if(bookmarks.isNotEmpty) {
          await getBookmarks();
        } else{
        allEvents.value = event;
        filteredEvents.addAll(event);
        // Initially, show all events
        setMinMaxPrice();
        isLoading.value = false;

        }},
    );
  }

  void filterEvents() {
    searchingMode.value = true;
    searchQuery.value = searchController.text;
    List<AllEventsModel> tempList = allEvents
        .where((event) =>
            event.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
    tempList = tempList
        .where((event) =>
            event.price >= selectedMinPrice.value &&
            event.price <= selectedMaxPrice.value)
        .toList();

    tempList.sort((a, b) => sortByDateAscending.value
        ? a.date!.compareTo(b.date!)
        : b.date!.compareTo(a.date!));

    //
    // tempList.sort((a, b) => sortByCapacityAscending.value
    //     ? (b.capacity - b.attendance!).compareTo(a.capacity - a.attendance!)
    //     : (a.capacity - a.attendance!).compareTo(b.capacity - b.attendance!));

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
      filterEvents();
    }
  }

  void onPriceRangeChanged(RangeValues values) {
    minPrice.value = values.start.toInt();
    maxPrice.value = values.end.toInt();
    filterEvents();
  }

  void onSortOrderChangedByCapacity(bool ascending) {
    sortByCapacityAscending.value = ascending;
    filterEvents();
  }

  void onSortOrderChanged(bool ascending) {
    sortByDateAscending.value = ascending;
    filterEvents();
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
    if (bookmarkId == null) {
      // No bookmark entry exists; create one
      final List newBookedEvent = [eventId];
      final BookmarksDto dto = BookmarksDto(userId: userId, bookedEvents: newBookedEvent);

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
        final BookmarksDto dto = BookmarksDto(userId: userId, bookedEvents: newBookedEvent);

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
        final BookmarksDto dto = BookmarksDto(userId: userId, bookedEvents: newBookedEvent);

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
    getAllEvents();
  }

  Future<void> goToBookmarks() async {
    final result = await Get.toNamed(RouteNames.bookmarks,
        parameters: {'userId': userId.toString()}, arguments: bookmarks);
    if (result != null) {
      getAllEvents();
    }
  }
}
