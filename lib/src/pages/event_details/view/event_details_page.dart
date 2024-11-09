import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/src/infrastructure/utils/utils.dart';
import 'package:my_project/src/pages/event_details/controllers/event_details_controller.dart';
import 'package:my_project/src/pages/event_details/models/event_details_model.dart';

import '../../../components/capacity/capacity_counter.dart';

class EventDetailsPage extends GetView<EventDetailsController> {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Event Details'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
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
              scrollDirection: Axis.vertical,
              child: _event(event!)
          );
        }),
      );

  Widget _retry() => Center(
        child: ElevatedButton(
          onPressed: () => controller.getEventById,
          child: const Text('retry'),
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
                const Text('Event Details'),
                verticalGap(),
                if (event.poster != null)
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.memory(base64Decode(event.poster!)),
                  ),
                verticalGap(),
                Text(
                  event.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                verticalGap(),
                Text(event.description),
                verticalGap(),
                Text('Date: ${event.date ?? "No date available"}'),
                verticalGap(),
                Text('Capacity: ${event.capacity}'),
                controller.isFilled.value?
                    const SizedBox()
                    :
                CapacityCounter(
                  totalCapacity: event.capacity - event.attendance!,
                  initialValue: 1,
                  onChanged: controller.onChanged,
                )
                ,
                verticalGap(),
                Text('Attendance: ${event.attendance ?? 0}'),
                verticalGap(),
                Text('Price: ${event.price}\$'),
                verticalGap(),
                ElevatedButton(
                  onPressed: controller.isFilled.value? null :controller.increaseAttendance,
                  child: const Text('Purchase'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
