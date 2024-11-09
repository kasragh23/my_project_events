import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/src/infrastructure/utils/utils.dart';
import 'package:my_project/src/pages/all_events/controllers/all_events_controller.dart';
import 'package:my_project/src/pages/all_events/view/Widgets/all_events_widgets.dart';

class AllEventsPage extends GetView<AllEventsController> {
  const AllEventsPage({super.key});

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
        title: const Text('All Eventssss'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple,
        width: 250,
        child: Column(
          children: [ListTile(
            leading: const Icon(Icons.bookmarks,color: Colors.white,),
            onTap: controller.goToBookmarks,
            title: const Text('My Bookmarks',style: TextStyle(color: Colors.white),),
          )],
        ),
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
                          hintText: 'Search events...',
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
                              separatorBuilder: (context, index) =>
                                  verticalGap(),
                              itemCount: controller.filteredEvents.length,
                              itemBuilder: (context, index) {
                                final event = controller.filteredEvents[index];
                                return AllEventsWidgets(
                                    event: event,
                                    bookmarks: controller.bookmarks,
                                    onToggle: () =>
                                        controller.toggleBookmark(event.id),
                                    onPressed: () =>
                                        controller.goToEventDetails(event.id));
                              })
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  verticalGap(),
                              itemCount: controller.allEvents.length,
                              itemBuilder: (context, index) {
                                final event = controller.allEvents[index];
                                return AllEventsWidgets(
                                    event: event,
                                    bookmarks: controller.bookmarks,
                                    onToggle: () =>
                                        controller.toggleBookmark(event.id),
                                    onPressed: () =>
                                        controller.goToEventDetails(event.id));
                              })),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToMyEvents,
        child: const Icon(Icons.account_circle),
      ),
    );
  }
}
