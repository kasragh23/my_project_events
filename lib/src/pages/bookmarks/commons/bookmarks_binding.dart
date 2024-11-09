import 'package:get/get.dart';
import 'package:my_project/src/pages/bookmarks/controllers/bookmarks_controller.dart';
import 'package:my_project/src/pages/bookmarks/models/bookmark_events_model.dart';

class BookmarksBinding extends Bindings{
  @override
  void dependencies() {
    final int userId = int.parse(Get.parameters['userId'] ?? '');
    Get.lazyPut(()=> BookmarksController(userId: userId));
  }
}