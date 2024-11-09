import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/utils/utils.dart';
import '../controllers/bookmarks_controller.dart';
import 'widgets/bookmark_widgets.dart';

class BookmarksPage extends GetView<BookmarksController> {
  const BookmarksPage({super.key});

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
        title: const Text('Bookmarks'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: SizedBox(
              width: responsiveWidth(context),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: TextField(
                      controller: controller.searchController,

                      // Update search query
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search bookmarks...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: controller.filterEvents,
                          ),
                          suffixIcon: IconButton(
                              onPressed: controller.clearSearch,
                              icon: const Icon(Icons.cancel_outlined))),
                    ),
                  ),
                  Expanded(
                    child: controller.searchingMode.value
                        ? ListView.separated(
                            separatorBuilder: (context, index) => verticalGap(),
                            itemCount: controller.filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = controller.filteredEvents[index];
                              return BookmarkWidgets(
                                  event: event,
                                  bookmarks: controller.bookmarks,
                                  onToggle: () =>
                                      controller.toggleBookmark(event.id),
                                  onPressed: () =>
                                      controller.goToEventDetails(event.id));
                            })
                        : ListView.separated(
                            separatorBuilder: (context, index) => verticalGap(),
                            itemCount: controller.bookmarks.length,
                            itemBuilder: (context, index) {
                              final event = controller.bookmarks[index];
                              return BookmarkWidgets(
                                  event: event,
                                  bookmarks: controller.bookmarkIds,
                                  onToggle: () =>
                                      controller.toggleBookmark(event.id),
                                  onPressed: () =>
                                      controller.goToEventDetails(event.id));
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
