import 'dart:convert';

import 'package:capacity_counter/capacity_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/utils.dart';
import '../controllers/event_details_controller.dart';
import '../models/event_details_model.dart';


class EventDetailsPage extends GetView<EventDetailsController> {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.localization_app_event_details.tr),
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final event = controller.eventDetail.value;
          if (controller.isRetryMode.value) {
            return _retry();
          }
          return SingleChildScrollView(
              scrollDirection: Axis.vertical, child: _event(event!));
        }),
      );

  Widget _retry() => Center(
        child: ElevatedButton(
          onPressed: () => controller.getEventById,
          child: Text(LocaleKeys.localization_app_retry.tr),
        ),
      );

  Widget _event(EventDetailsModel event) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.6),
            color: const Color.fromARGB(255, 255, 180, 90),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.localization_app_event_details.tr),
                verticalGap(),
                event.poster!.isNotEmpty ?
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.memory(base64Decode(event.poster!)),
                  ) :
                    const ClipOval(child: Icon(Icons.image_not_supported)),
                verticalGap(),
                Text(
                  event.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                verticalGap(),
                Text(event.description),
                verticalGap(),
                Text('${LocaleKeys.localization_app_date.tr}:${event.date}'),
                verticalGap(),
                Text(
                    '${LocaleKeys.localization_app_capacity.tr}: ${event.capacity}'),
                controller.isFilled.value
                    ? const SizedBox()
                    : Capacity(
                        totalCapacity: event.capacity - event.attendance!,
                        initialValue: 1,
                        onChanged: controller.onChanged,
                      ),
                verticalGap(),
                Text(
                    '${LocaleKeys.localization_app_attendance.tr}: ${event.attendance ?? 0}'),
                verticalGap(),
                Text('${LocaleKeys.localization_app_price.tr}: ${event.price}\$'),
                verticalGap(),
                Obx(()=> controller.buttonLoading.value
                    ? ElevatedButton(
                  onPressed: null,
                  child: Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  ),
                )
                    : ElevatedButton(
                  onPressed: controller.isFilled.value
                      ? null
                      : controller.increaseAttendance,
                  child: Text(LocaleKeys.localization_app_purchase.tr),
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
