import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/add_event_dto.dart';


import '../repositories/add_event_repository.dart';

class AddEventController extends GetxController {
  final MyEventsRepository _repository = MyEventsRepository();
  final int? userId;

  AddEventController({required this.userId});

  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final capacity = TextEditingController();
  final price = TextEditingController();
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

  String? validate(String? value) {
    if (value != null && value.isEmpty) return 'required';
    return null;
  }

  Future<void> addEvent() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

      final int priceValue = int.tryParse(price.text) ?? 0;
      final int capacityValue = int.parse(capacity.text);
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
        final AddEventDto dto = AddEventDto(
          userId: userId!,
          title: title.text,
          description: description.text,
          poster: selectedImage.value,
          date: eventDate.toString(),
          capacity: capacityValue,
          price: priceValue,
        );
        final resultOrException = await _repository.addEvent(dto: dto);
        resultOrException.fold((exception) {
          Get.showSnackbar(
            GetSnackBar(
              title: 'Failed to add event',
              message: exception,
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }, (event) {
            Get.back();
        });

    }

    //   void selectDate(BuildContext context) async {
    //     final DateTime? picked = await showDatePicker(
    //       context: context,
    //       initialDate: DateTime.now(),
    //       firstDate: DateTime(2000),
    //       lastDate: DateTime(2101),
    //     );
    //     if (picked != null && picked != DateTime.now()) {
    //       selectedDate.value = picked.toLocal().toString().split(' ')[0];
    //     }
    //   }
    // }
  }
