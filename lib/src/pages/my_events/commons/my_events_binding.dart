import 'package:get/get.dart';
import 'package:my_project/src/pages/my_events/controllers/my_events_controller.dart';

class MyEventsBinding extends Bindings {
  @override
  void dependencies() {
    final int id = int.parse(Get.parameters['userId'] ?? "");
    Get.lazyPut(() => MyEventsController(userId: id));
  }
}
