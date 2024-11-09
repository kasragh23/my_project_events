import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/generated/locales.g.dart';
import '../controllers/edit_event_controller.dart';

import '../../../infrastructure/utils/utils.dart';

class EditEventPage extends GetView<EditEventController> {
  const EditEventPage({super.key});

  double pageWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  double responsiveWidth(BuildContext context) {
    if (pageWidth(context) > 700) {
      return 700;
    }
    return double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.localization_app_edit_event.tr),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () => Get.updateLocale(const Locale('en', 'US')),
              child: Text(
                LocaleKeys.localization_app_change_language_to_english.tr,
                style: const TextStyle(color: Colors.white),
              )),
          TextButton(
            onPressed: () => Get.updateLocale(const Locale('fa', 'IR')),
            child: Text(
              LocaleKeys.localization_app_change_language_to_persian.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.isRetryMode.value) {
            return Center(
              child: ElevatedButton(
                onPressed: () => controller.getEventById(id: controller.id!),
                child: Text(LocaleKeys.localization_app_retry.tr),
              ),
            );
          } else {
            return SizedBox(
              width: responsiveWidth(context),
              child: Form(
                key: controller.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.editTitle,
                          decoration: InputDecoration(
                              labelText: LocaleKeys.localization_app_title.tr),
                          validator: controller.validator,
                        ),
                        TextFormField(
                          controller: controller.editDescription,
                          decoration: InputDecoration(
                              labelText:
                                  LocaleKeys.localization_app_description.tr),
                          validator: controller.validator,
                        ),
                        TextFormField(
                          controller: controller.editPrice,
                          decoration: InputDecoration(
                              labelText: LocaleKeys.localization_app_price.tr),
                          keyboardType: TextInputType.number,
                          validator: controller.validator,
                        ),
                        TextFormField(
                          controller: controller.editCapacity,
                          decoration: InputDecoration(
                              labelText:
                                  LocaleKeys.localization_app_capacity.tr),
                          keyboardType: TextInputType.number,
                          validator: controller.validator,
                        ),
                        CircleAvatar(
                          child: ClipOval(
                            child: Image.memory(
                                base64Decode(controller.selectedImage.value)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.pickImage,
                          child:
                              Text(LocaleKeys.localization_app_pick_image.tr),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Obx(() => DropdownButton<int>(
                                  hint:
                                      Text(LocaleKeys.localization_app_year.tr),
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
                                )),
                            smallHorizontal(),
                            // Month Dropdown
                            Obx(() => DropdownButton<int>(
                                  hint: Text(
                                      LocaleKeys.localization_app_month.tr),
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
                                )),
                            smallHorizontal(),
                            // Day Dropdown
                            Obx(() => DropdownButton<int>(
                                  hint:
                                      Text(LocaleKeys.localization_app_day.tr),
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
                                )),
                          ],
                        ),
                        horizontalGap(),
                        // Hour Dropdown
                        Row(
                          children: [
                            Obx(() => DropdownButton<int>(
                                  hint:
                                      Text(LocaleKeys.localization_app_hour.tr),
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
                                )),

                            horizontalGap(),
                            // Minute Dropdown
                            Obx(
                              () => DropdownButton<int>(
                                hint:
                                    Text(LocaleKeys.localization_app_minute.tr),
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
                        ),
                        verticalGap(),
                        ElevatedButton(
                          onPressed: controller.editEvent,
                          child:
                              Text(LocaleKeys.localization_app_save_changes.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
