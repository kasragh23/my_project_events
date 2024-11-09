import 'package:get/get.dart';
import '../controllers/bookmarks_controller.dart';

class BookmarksBinding extends Bindings{
  @override
  void dependencies() {
    final int userId = int.parse(Get.parameters['userId'] ?? '');
    Get.lazyPut(()=> BookmarksController(userId: userId));
  }
}