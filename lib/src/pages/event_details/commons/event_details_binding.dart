import 'package:get/get.dart';
import 'package:my_project/src/pages/event_details/controllers/event_details_controller.dart';

class EventDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final int? id = int.tryParse(Get.parameters['id'] ?? '');
    print('Received event ID in binding: $id'); // for debugging
    if (id != null) {
      Get.lazyPut(() => EventDetailsController(id: id));
    } else {
      print('Error: Event ID is null');
    }
  }
}
