import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LokakaryaController extends GetxController {
  Rx<Position?> position = Rx<Position?>(null);
  RxBool isLocationAllowed = false.obs;
  RxBool isLocationDenied = false.obs;
  RxString timeString = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initLocation();
    _startClock();
  }

  // CLOCK
  void _startClock() {
    timeString.value = _now();
    ever(timeString, (_) {});
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      timeString.value = _now();
      return true;
    });
  }

  String _now() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  // LOCATION
  Future<void> initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLocationDenied.value = true;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        isLocationAllowed.value = true;
        isLocationDenied.value = false;
        position.value = await Geolocator.getCurrentPosition();
      } else {
        isLocationDenied.value = true;
        isLocationAllowed.value = false;
      }
    } catch (e) {
      isLocationDenied.value = true;
      isLocationAllowed.value = false;
      Get.snackbar("Error", "Failed to get location");
    }
  }

  Future<void> saveAttendance() async {}
}
