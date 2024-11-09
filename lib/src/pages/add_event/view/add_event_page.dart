import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        appBar: AppBar(
          title: const Text('Add Event'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
                child: SizedBox(
                  width: responsiveWidth(context),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.title,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: controller.validate,
                      ),
                      TextFormField(
                        controller: controller.description,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        validator: controller.validate,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => controller.selectedImage.value.isEmpty
                          ? const CircleAvatar(
                              child: ClipOval(
                                  child: Icon(Icons.image_not_supported)))
                          : CircleAvatar(
                              child: ClipOval(
                                child: Image.memory(base64Decode(
                                    controller.selectedImage.value)),
                              ),
                            )),
                      verticalGap(),
                      ElevatedButton(
                        onPressed: controller.pickImage,
                        child: const Text('Pick Image'),
                      ),
                      const SizedBox(height: 16),
                      // Obx(() => TextField(
                      //       controller: TextEditingController(
                      //           text: controller.selectedDate.value),
                      //       readOnly: true,
                      //       decoration: const InputDecoration(labelText: 'Date'),
                      //       onTap: () => controller.selectDate(context),
                      //     )),
                      Row(
                        children: [
                          Obx(() => DropdownButton<int>(
                                hint: const Text('Year'),
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
                          horizontalGap(),
                          // Month Dropdown
                          Obx(() => DropdownButton<int>(
                                hint: const Text('Month'),
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
                          horizontalGap(),
                          // Day Dropdown
                          Obx(() => DropdownButton<int>(
                                hint: const Text('Day'),
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
                      Row(children: [
                        Obx(() => DropdownButton<int>(
                              hint: const Text('Hour'),
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
                        Obx(() => DropdownButton<int>(
                              hint: const Text('Minute'),
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
                      ]),

                      TextFormField(
                        controller: controller.capacity,
                        decoration:
                            const InputDecoration(labelText: 'Capacity'),
                        keyboardType: TextInputType.number,
                        validator: controller.validate,
                      ),
                      TextFormField(
                        controller: controller.price,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: controller.validate,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.addEvent,
                        child: const Text('Add Event'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
