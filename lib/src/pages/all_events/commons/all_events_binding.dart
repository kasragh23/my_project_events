import 'package:get/get.dart';
import '../controllers/all_events_controller.dart';

class AllEventsBinding extends Bindings {
  @override
  void dependencies() {
    final String? userIdParam = Get.parameters['userId'];
    if (userIdParam != null) {
      final int userId = int.parse(userIdParam);
      Get.lazyPut(() => AllEventsController(userId: userId,));
    } else {
      print('Error: User ID parameter is missing');
    }
  }
}
