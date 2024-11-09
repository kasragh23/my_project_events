import 'package:get/get.dart';
import 'route_paths.dart';
import '../../pages/add_event/commons/add_event_binding.dart';
import '../../pages/add_event/view/add_event_page.dart';
import '../../pages/all_events/commons/all_events_binding.dart';
import '../../pages/all_events/view/all_events_page.dart';
import '../../pages/bookmarks/commons/bookmarks_binding.dart';
import '../../pages/edit_event/commons/edit_event_binding.dart';
import '../../pages/edit_event/view/edit_event_page.dart';
import '../../pages/event_details/commons/event_details_binding.dart';
import '../../pages/event_details/view/event_details_page.dart';
import '../../pages/my_events/commons/my_events_binding.dart';
import '../../pages/my_events/view/my_events_page.dart';
import '../../pages/splash/view/splash_page.dart';

import '../../pages/bookmarks/view/bookmark_page.dart';
import '../../pages/login/commons/login_binding.dart';
import '../../pages/login/view/login_page.dart';
import '../../pages/register/commons/register_binding.dart';
import '../../pages/register/view/register_page.dart';
import '../../pages/splash/commons/splash_binding.dart';

class RoutePages {
  static List<GetPage> pages = [
    GetPage(
      name: RoutePaths.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      children: [
        GetPage(
          name: RoutePaths.login,
          page: () => const LoginPage(),
          binding: LoginBinding(),
          children: [
            GetPage(
              name: RoutePaths.register,
              page: () => const RegisterPage(),
              binding: RegisterBinding(),
            ),
          ],
        ),
      ],
    ),
    GetPage(
      name: RoutePaths.allEvents,
      page: () => const AllEventsPage(),
      binding: AllEventsBinding(),
      children: [
        GetPage(
          name: RoutePaths.myEvents,
          page: () => const MyEventsPage(),
          binding: MyEventsBinding(),
          children: [
            GetPage(
                name: RoutePaths.addEvent,
                page: () => const AddEventPage(),
                binding: AddEventBinding()),
            GetPage(
              name: RoutePaths.editEvent,
              page: () => const EditEventPage(),
              binding: EditEventBinding(),
            )
          ],
        ),
        GetPage(
          name: RoutePaths.eventDetails,
          page: () => const EventDetailsPage(),
          binding: EventDetailsBinding(),
        ),
        GetPage(
          name: RoutePaths.bookmarks,
          page: () => const BookmarksPage(),
          binding: BookmarksBinding(),
          children: [
            GetPage(
              name: RoutePaths.eventDetails,
              page: () => const EventDetailsPage(),
              binding: EventDetailsBinding(),
            ),
          ],
        )
      ],
    ),
  ];
}
