import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/utils/utils.dart';
import '../controllers/all_events_controller.dart';
import 'Widgets/all_events_widgets.dart';

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
        title: Text(LocaleKeys.localization_app_all_events.tr),
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
      drawer: Drawer(
        backgroundColor: Colors.deepPurple,
        width: 250,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.bookmarks,
                color: Colors.white,
              ),
              onTap: controller.goToBookmarks,
              title: Text(
                LocaleKeys.localization_app_my_bookmarks.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            verticalGap(),
            Obx(
              () => Column(
                children: [
                  Text(
                    LocaleKeys.localization_app_price_range.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Obx(
                    () => RangeSlider(
                      values: RangeValues(
                        controller.minPrice.value.toDouble(),
                        controller.maxPrice.value.toDouble(),
                      ),
                      min: controller.minPrice.value.toDouble(),
                      max: controller.maxPrice.value.toDouble(),
                      divisions: 10,
                      activeColor: Colors.greenAccent.shade100,
                      labels: RangeLabels(
                        '${controller.minPrice.value} \$',
                        '${controller.maxPrice.value} \$',
                      ),
                      onChanged: (RangeValues values) {
                        controller.selectedMinPrice.value =
                            values.start.toInt();
                        controller.selectedMaxPrice.value = values.end.toInt();
                        controller
                            .filterEvents(); // Filter with the updated selected price range
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      LocaleKeys.localization_app_sort_by_date.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Switch(
                      value: controller.sortByDateAscending.value,
                      activeColor: Colors.greenAccent.shade100,
                      onChanged: (value) {
                        controller.onSortOrderChanged(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      LocaleKeys.localization_app_sort_by_available_capacity.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Obx(() {
                      return Switch(
                        activeColor: Colors.greenAccent.shade100,
                        value: controller.sortByCapacityAscending.value,
                        onChanged: (value) {
                          controller.onSortOrderChangedByCapacity(value);
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.isRetryMode.value) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => controller.getAllEvents,
                  child: Text(LocaleKeys.localization_app_retry.tr),
                ),
              );
            } else {
              return Padding(
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
                              hintText:
                                  LocaleKeys.localization_app_search_events.tr,
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
                      if (controller.allEvents.isNotEmpty)
                        Expanded(
                          child: controller.searchingMode.value
                              ? ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      verticalGap(),
                                  itemCount: controller.filteredEvents.length,
                                  itemBuilder: (context, index) {
                                    final event =
                                        controller.filteredEvents[index];
                                    return AllEventsWidgets(
                                        event: event,
                                        bookmarks: controller.bookmarks,
                                        onToggle: () =>
                                            controller.toggleBookmark(event.id),
                                        onPressed: () => controller
                                            .goToEventDetails(event.id));
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
                                        onPressed: () => controller
                                            .goToEventDetails(event.id));
                                  },
                                ),
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToMyEvents,
        child: const Icon(Icons.account_circle),
      ),
    );
  }
}
