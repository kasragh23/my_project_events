import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/src/infrastructure/utils/utils.dart';

import '../../../../my_project.dart';
import '../model/my_events_model.dart';
import '../repositories/my_events_repository.dart';

class MyEventsController extends GetxController {
  final MyEventsRepository _repository = MyEventsRepository();
  RxList<MyEventsModel> myEvents = <MyEventsModel>[].obs;
  RxBool isLoading= false.obs, isRetry = false.obs;

  final int userId;

  MyEventsController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    getEventByUserId(userId: userId);
  }

  Future<void> getEventByUserId({required int userId}) async {
    final resultOrException =
        await _repository.getMyEvents(userId);
    resultOrException.fold(
      (exception) {
        return showSnackBar(exception);
      },
      (events) {
        myEvents.value = events;
      },
    );
  }

  void deleteEvent(int id) async {
    isLoading.value = true;
    final resultOrException = await _repository.deleteEvent(id: id);
    isLoading.value = false;
    resultOrException.fold(
          (exception) {
        Get.showSnackbar(GetSnackBar(
          title: 'failed',
          message: exception,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ));
      },
          (result) {
        if (result) {
          myEvents.removeWhere((event) => event.id == id);
        }
      },
    );
  }



  Future<void> goToAddEventPage() async {
    await Get.toNamed(RouteNames.addEvent,
        parameters: {'userId': userId.toString()});
      getEventByUserId(userId: userId);

  }

  Future<void> goToEditEvent(int eventId) async {
    final resultOrException = await _repository.getEventById(eventId);
    resultOrException.fold(
          (exception) => showSnackBar(exception),
          (event) async{
        await Get.toNamed(RouteNames.editEvent, parameters: {'id': '${event.id}'});
        getEventByUserId(userId: userId);
      },
    );
  }
}
