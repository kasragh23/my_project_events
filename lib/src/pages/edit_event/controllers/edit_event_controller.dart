import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/src/infrastructure/utils/utils.dart';
import 'package:my_project/src/pages/edit_event/repositories/edit_event_repository.dart';
import '../models/edit_event_dto.dart';

class EditEventController extends GetxController {
  int? id;
  final EditEventRepository _repository = EditEventRepository();
  final editTitle = TextEditingController();
  final editDescription = TextEditingController();
  final editPrice = TextEditingController();
  final editCapacity = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool isRetryMode = false.obs, isLoading = true.obs, isEditing = false.obs;
  var selectedYear = 0.obs;
  var selectedMonth = 0.obs;
  var selectedDay = 0.obs;
  var selectedHour = 0.obs;
  var selectedMinute = 0.obs;
  final currentYear = DateTime
      .now()
      .year;

  List<int> get years =>
      [for (var i = currentYear - 5; i <= currentYear + 5; i++) i];

  List<int> get months => [for (var i = 1; i <= 12; i++) i];

  List<int> get days =>
      _getDaysInMonth(selectedYear.value, selectedMonth.value);

  List<int> get hours => [for (var i = 0; i < 24; i++) i];

  List<int> get minutes => [for (var i = 0; i < 60; i++) i];

  List<int> _getDaysInMonth(int year, int month) {
    if (year == 0 || month == 0) {
      return [];
    }
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return [for (var i = 1; i <= daysInMonth; i++) i];
  }

  var selectedImage = ''.obs;
  var selectedDate = ''.obs;

  final ImagePicker _picker = ImagePicker();

  void pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = base64Encode(await pickedFile.readAsBytes());
    }
  }

  EditEventController(this.id);

  @override
  void onInit() {
    super.onInit();
    if (id != null) {
      getEventById(id: id!);
    }
  }

  String? validator(String? value) {
    if (value != null) {
      if (value.isEmpty) return 'required';
    }
    return null;
  }

  Future<void> getEventById({required int id}) async {
    isRetryMode.value = false;
    isLoading.value = true;
    final resultOrException = await _repository.getEventById(id);
    resultOrException.fold(
      (exception) {
        isRetryMode.value = true;
        isLoading.value = false;
        return showSnackBar(exception);
      },
      (event) {
        selectedImage.value = event.poster.toString();
        editTitle.text = event.title;
        editDescription.text = event.description;
        editPrice.text = event.price.toString();
        editCapacity.text = event.capacity.toString();
        if (event.date != null) {
          final eventDate = event.date!;
          selectedYear.value = eventDate.year;
          selectedMonth.value = eventDate.month;
          selectedDay.value = eventDate.day;
          selectedHour.value = eventDate.hour;
          selectedMinute.value = eventDate.minute;
        }
        selectedDate.value = event.date.toString();
        isLoading.value = false;
      },
    );
  }

  Future<void> editEvent() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    final int priceValue = int.tryParse(editPrice.text) ?? 0;
    final int capacityValue = int.parse(editCapacity.text);
    final eventDate = DateTime(
      selectedYear.value, selectedMonth.value, selectedDay.value,
      selectedHour.value, selectedMinute.value,);
    if (eventDate.isBefore(DateTime.now())) {
      Get.showSnackbar(
        const GetSnackBar(title: 'Error',
          message: 'Event date must be in the future.',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),);
      return;
    }
    final EditEventDto dto = EditEventDto(
      poster: selectedImage.value,
        title: editTitle.text,
        description: editDescription.text,
        price: priceValue,
        capacity: capacityValue,
        date: eventDate.toString(),
    );
        isLoading.value = true;
    final Either<String, Map<String, dynamic>> resultOrException =
        await _repository.editEvent(id: id!, dto: dto);
    resultOrException.fold(
      (exception) {
        isLoading.value = false;
        isRetryMode.value = true;
        return showSnackBar(exception);
      },
      (event) {
        Get.back(result: event);
        Get.showSnackbar(
          GetSnackBar(
            title: 'Successful',
            message: 'Event with id $id edited!',
            backgroundColor: Colors.green.shade400,
            duration: const Duration(milliseconds: 2600),
          ),
        );
        getEventById(id: id!);
      },
    );
  }
}
