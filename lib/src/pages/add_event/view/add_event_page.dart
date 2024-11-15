import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/generated/locales.g.dart';
import 'package:my_project/src/infrastructure/utils/utils.dart';

import '../controllers/add_event_controller.dart';

class AddEventPage extends GetView<AddEventController> {
  const AddEventPage({super.key});

  double pageWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  double responsiveWidth(BuildContext context) {
    if (pageWidth(context) > 700) {
      return 700;
    }
    return double.infinity;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(context),
      );

  AppBar _appBar() {
    return AppBar(
      title: Text(LocaleKeys.localization_app_add_event.tr),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      actions: [
        TextButton(
          onPressed: () => Get.updateLocale(const Locale('en', 'US')),
          child: Text(
            LocaleKeys.localization_app_change_language_to_english.tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () => Get.updateLocale(const Locale('fa', 'IR')),
          child: Text(
            LocaleKeys.localization_app_change_language_to_persian.tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: SizedBox(
              width: responsiveWidth(context),
              child: _textFields(),
            ),
          ),
        ),
      ),
    );
  }

  Column _textFields() {
    return Column(
      children: [
        TextFormField(
          controller: controller.title,
          decoration:
              InputDecoration(labelText: LocaleKeys.localization_app_title.tr),
          validator: controller.validate,
        ),
        TextFormField(
          controller: controller.description,
          decoration: InputDecoration(
              labelText: LocaleKeys.localization_app_description.tr),
          validator: controller.validate,
        ),
        verticalGap(),
        Obx(
          () => controller.selectedImage.value.isEmpty
              ? const ClipOval(child: Icon(Icons.image_not_supported))
              : SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.memory(
                      base64Decode(controller.selectedImage.value)),
                ),
        ),
        verticalGap(),
        ElevatedButton(
          onPressed: controller.pickImage,
          child: Text(LocaleKeys.localization_app_pick_image.tr),
        ),
        const SizedBox(height: 16),
        // Obx(() => TextField(
        //       controller: TextEditingController(
        //           text: controller.selectedDate.value),
        //       readOnly: true,
        //       decoration: const InputDecoration(labelText: 'Date'),
        //       onTap: () => controller.selectDate(context),
        //     )),
        _date(),
        horizontalGap(),
        // Hour Dropdown
        _time(),

        TextFormField(
          controller: controller.capacity,
          decoration: InputDecoration(
              labelText: LocaleKeys.localization_app_capacity.tr),
          keyboardType: TextInputType.number,
          validator: controller.validate,
          inputFormatters: controller.capacityFormatters,
        ),
        TextFormField(
          controller: controller.price,
          decoration:
              InputDecoration(labelText: LocaleKeys.localization_app_price.tr),
          keyboardType: TextInputType.number,
          validator: controller.validate,
          inputFormatters: controller.priceFormatters,
          onChanged: (value) => int.parse(value),
        ),
        verticalGap(),
        ElevatedButton(
          onPressed: controller.addEvent,
          child: Text(LocaleKeys.localization_app_add_event.tr),
        )
      ],
    );
  }

  Widget _date() {
    return Row(
      children: [
        Obx(
          () => DropdownButton<int>(
            hint: Text(LocaleKeys.localization_app_year.tr),
            value: controller.selectedYear.value == 0
                ? null
                : controller.selectedYear.value,
            items: controller.years
                .map<DropdownMenuItem<int>>(
                    (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                .toList(),
            onChanged: (value) {
              controller.selectedYear.value = value!;
            },
          ),
        ),
        horizontalGap(),
        // Month Dropdown
        Obx(
          () => DropdownButton<int>(
            hint: Text(LocaleKeys.localization_app_month.tr),
            value: controller.selectedMonth.value == 0
                ? null
                : controller.selectedMonth.value,
            items: controller.months
                .map<DropdownMenuItem<int>>(
                    (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                .toList(),
            onChanged: (value) {
              controller.selectedMonth.value = value!;
              controller.selectedDay.value = 0;
            },
          ),
        ),
        horizontalGap(),
        // Day Dropdown
        Obx(
          () => DropdownButton<int>(
            hint: Text(LocaleKeys.localization_app_day.tr),
            value: controller.selectedDay.value == 0
                ? null
                : controller.selectedDay.value,
            items: controller.days
                .map<DropdownMenuItem<int>>(
                    (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                .toList(),
            onChanged: (value) {
              controller.selectedDay.value = value!;
            },
          ),
        ),
      ],
    );
  }

  Widget _time() {
    return Row(
      children: [
        Obx(
          () => DropdownButton<int>(
            hint: Text(LocaleKeys.localization_app_hour.tr),
            value: controller.selectedHour.value == 0
                ? null
                : controller.selectedHour.value,
            items: controller.hours
                .map<DropdownMenuItem<int>>(
                    (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                .toList(),
            onChanged: (value) {
              controller.selectedHour.value = value!;
            },
          ),
        ),
        horizontalGap(),
        // Minute Dropdown
        Obx(
          () => DropdownButton<int>(
            hint: Text(LocaleKeys.localization_app_minute.tr),
            value: controller.selectedMinute.value == 0
                ? null
                : controller.selectedMinute.value,
            items: controller.minutes
                .map<DropdownMenuItem<int>>(
                    (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                .toList(),
            onChanged: (value) {
              controller.selectedMinute.value = value!;
            },
          ),
        ),
      ],
    );
  }
}
