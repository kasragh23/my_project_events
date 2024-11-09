import 'package:get/get.dart';
import '../../../infrastructure/utils/utils.dart';
import '../models/event_detail_dto.dart';
import '../models/event_details_model.dart';
import '../repositories/event_details_repository.dart';

class EventDetailsController extends GetxController {
  Rxn<EventDetailsModel> eventDetail = Rxn<EventDetailsModel>();
  RxBool isRetryMode = false.obs, isLoading = true.obs;

  final EventDetailsRepository _repository = EventDetailsRepository();

  final int id;
  RxInt initialAttendance = 1.obs;

  EventDetailsController({required this.id});

  RxBool isFilled = false.obs;

  @override
  @override
  void onInit() {
    super.onInit();
    getEventById(id: id);
  }

  Future<void> getEventById({required int id}) async {
    isLoading.value = true;
    isRetryMode.value = false;
    await Future.delayed(const Duration(seconds: 3));
    final resultOrException = await _repository.getEventById(id);
    resultOrException.fold((exception) {
      showSnackBar(exception);
      isLoading.value = false;
      isRetryMode.value = true;
    }, (event) {
      isLoading.value = false;
      isRetryMode.value = false;
      eventDetail.value = event;
      if (eventDetail.value!.attendance! >= eventDetail.value!.capacity) {
        isFilled = true.obs;
      }
    });
  }

  void onChanged(int value) {
    initialAttendance.value = value;
  }

  Future<void> increaseAttendance() async {
    int newAttendance =
        initialAttendance.value + eventDetail.value!.attendance!;
    EventDetailDto dto = EventDetailDto(attendance: newAttendance);
    final result = await _repository.updateEventAttendance(id, dto);

    result.fold(
      (exception) {
        showSnackBar(exception);
      },
      (success) {
        Get.back(result: success);
      },
    );
  }
}
