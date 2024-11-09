import 'package:get/get.dart';
import '../controllers/edit_event_controller.dart';

class EditEventBinding extends Bindings {
  @override
  void dependencies() {
    final String? idParam = Get.parameters['id'];
    if (idParam != null) {
      final int id = int.parse(idParam);
      Get.lazyPut(() => EditEventController(id));
    } else {
      print('Error: Event ID parameter is missing');
    }
  }
}
