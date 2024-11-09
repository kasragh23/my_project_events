import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_project/src/pages/my_events/model/my_events_model.dart';

import '../../../../infrastructure/utils/utils.dart';

class MyEventsWidgets extends StatelessWidget {
  const MyEventsWidgets({
    super.key,
    required this.event,
    required this.deleteEvent,
    required this.goToEdit,
    required this.onPurchase,
  });

  final MyEventsModel event;
  final void Function() deleteEvent;
  final void Function() goToEdit;
  final void Function() onPurchase;

  double size(BuildContext context) {
    return MediaQuery.sizeOf(context).width / 4;
  }

  @override
  Widget build(BuildContext context) {
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
            event.poster != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      height: 150,
                      width: 150,
                      base64Decode(event.poster!),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image_not_supported, color: Colors.grey),
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
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                  Text('Date: ${event.date ?? "N/A"}'),
                  Text(
                      'Capacity: ${event.capacity! - event.attendance!} / ${event.capacity}'),
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
                ElevatedButton(
                  onPressed: onPurchase,
                  child: const Text('Purchase'),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: goToEdit, icon: const Icon(Icons.edit)),
                IconButton(onPressed: deleteEvent, icon: const Icon(Icons.delete))
              ],
            ),
          ]
      ),
    );
  }
}
