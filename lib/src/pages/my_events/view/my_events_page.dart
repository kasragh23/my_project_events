import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/utils.dart';
import '../controllers/my_events_controller.dart';

class MyEventsPage extends GetView<MyEventsController> {
  const MyEventsPage({super.key});

  double pageWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  double responsiveWidth(BuildContext context) {
    if (pageWidth(context) > 700) {
      return 700;
    }
    return double.infinity;
  }

  double size(BuildContext context) {
    return MediaQuery.sizeOf(context).width / 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.localization_app_my_events.tr),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
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
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: responsiveWidth(context),
              child: ListView.separated(
                separatorBuilder: (context, index) => verticalGap(),
                itemCount: controller.myEvents.length,
                itemBuilder: (context, index) {
                  final event = controller.myEvents[index];
                  String date =
                      "${event.date?.year}-${event.date!.month}-${event.date!.day}";

                  String time = "${event.date!.hour}:${event.date!.minute}";
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 255, 254, 245),
                    ),
                    child: Row(
                        // onTap: () {
                        //   print(event.id);
                        //   controller.goToEditEvent(event.id!);
                        // },
                        children: [
                          if (event.poster!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                height: 80,
                                width: 80,
                                base64Decode(event.poster!),
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          horizontalGap(),

                          // Column 2: Title and Description
                          SizedBox(
                            width: size(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  event.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          horizontalGap(),

                          // Column 3: Event Details
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(date),
                                Text(time),
                                Text(
                                    '${LocaleKeys.localization_app_capacity.tr}: ${event.capacity! - event.attendance!} / ${event.capacity}'),
                              ],
                            ),
                          ),
                          const Spacer(),

                          // Column 4: Bookmark, Price, and Purchase Button

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${event.price}\$',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      controller.goToEditEvent(event.id!),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () =>
                                      controller.deleteEvent(event.id!),
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        ]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.goToAddEventPage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
