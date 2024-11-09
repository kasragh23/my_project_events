import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/bookmark_events_model.dart';

import '../../../../infrastructure/utils/utils.dart';

class BookmarkWidgets extends StatelessWidget {
  const BookmarkWidgets(
      {super.key,
      required this.event,
      required this.bookmarks,
      required this.onToggle,
      required this.onPressed});

  final BookmarkEventsModel event;
  final List bookmarks;
  final void Function() onToggle;
  final void Function() onPressed;

  double size(BuildContext context) {
    return MediaQuery.sizeOf(context).width / 4.5;
  }

  bool get isBookmarked {
    return bookmarks.contains(event.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Column 1: Poster
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
            const Icon(Icons.image_not_supported, color: Colors.grey),

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date),
              Text(time),
              Text('${event.capacity - event.attendance!} / ${event.capacity}'),
            ],
          ),

          const Spacer(),

          // Column 4: Bookmark, Price, and Purchase Button

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(
                () => IconButton(
                  onPressed: onToggle,
                  icon: isBookmarked
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_border),
                ),
              ),
              Text(
                '${event.price}\$',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text('Purchase'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get date =>
      "${event.date!.year}-${event.date!.month}-${event.date!.day}";

  String get time => "${event.date!.hour}:${event.date!.minute}";
}
