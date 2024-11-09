import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/src/pages/edit_event/controllers/edit_event_controller.dart';

import '../../../infrastructure/utils/utils.dart';

class EditEventPage extends GetView<EditEventController> {
  const EditEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.isRetryMode.value) {
          return Center(
            child: ElevatedButton(
              onPressed: () => controller.getEventById(id: controller.id!),
              child: const Text('Retry'),
            ),
          );
        } else {
          return Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.editTitle,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: controller.validator,
                    ),
                    TextFormField(
                      controller: controller.editDescription,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: controller.validator,
                    ),
                    TextFormField(
                      controller: controller.editPrice,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: controller.validator,
                    ),
                    TextFormField(
                      controller: controller.editCapacity,
                      decoration: const InputDecoration(labelText: 'Capacity'),
                      keyboardType: TextInputType.number,
                      validator: controller.validator,
                    ),
                    Obx(() => controller.selectedImage.value.isEmpty
                        ? ElevatedButton(
                      onPressed: controller.pickImage,
                      child: const Text('Pick Image'),
                    )
                        : CircleAvatar(
                      child: ClipOval(
                        child: Image.memory(
                            base64Decode(controller.selectedImage.value)),
                      ),
                    )
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Obx(() => DropdownButton<int>(
                          hint: const Text('Select Year'),
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
                        )
                        ),
                        horizontalGap(),
                        // Month Dropdown
                        Obx(() => DropdownButton<int>(
                          hint: const Text('Select Month'),
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
                        )
                        ),
                        horizontalGap(),
                        // Day Dropdown
                        Obx(() => DropdownButton<int>(
                          hint: const Text('Select Day'),
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
                        )
                        ),
                        horizontalGap(),
                        // Hour Dropdown
                        Obx(() => DropdownButton<int>(
                          hint: const Text('Select Hour'),
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
                        )
                        ),
                        horizontalGap(),
                        // Minute Dropdown
                        Obx(() => DropdownButton<int>(
                          hint: const Text('Select Minute'),
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
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: controller.editEvent,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
