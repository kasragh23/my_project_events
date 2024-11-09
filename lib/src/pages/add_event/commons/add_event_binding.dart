import 'package:get/get.dart';
import 'package:my_project/src/pages/add_event/controllers/add_event_controller.dart';
class AddEventBinding extends Bindings {
  @override
  void dependencies() {
    final int id = int.parse(Get.parameters["userId"] ?? '');
    Get.lazyPut(() => AddEventController(userId: id));
  }
}
