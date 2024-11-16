import 'route_paths.dart';

class RouteNames {
  static const String splash = RoutePaths.splash;
  static const String login = RoutePaths.login;
  static const String register = '${RoutePaths.login}${RoutePaths.register}';
  static const String allEvents = RoutePaths.allEvents;
  static const String myEvents = '${RoutePaths.allEvents}${RoutePaths.myEvents}';
  static const String addEvent = '${RoutePaths.allEvents}${RoutePaths.myEvents}${RoutePaths.addEvent}';
  static const String editEvent = '${RoutePaths.allEvents}${RoutePaths.myEvents}${RoutePaths.editEvent}';
  static const String eventDetails = '${RoutePaths.allEvents}${RoutePaths.eventDetails}';
  static const String eventDetailsFromBookmark = '${RoutePaths.allEvents}${RoutePaths.bookmarks}${RoutePaths.eventDetails}';
  static const String bookmarks = '${RoutePaths.allEvents}${RoutePaths.bookmarks}';

}