import 'package:get/get.dart';
import '../controllers/my_events_controller.dart';

class MyEventsBinding extends Bindings {
  @override
  void dependencies() {
    final int id = int.parse(Get.parameters['userId'] ?? "");
    Get.lazyPut(() => MyEventsController(userId: id));
  }
}
