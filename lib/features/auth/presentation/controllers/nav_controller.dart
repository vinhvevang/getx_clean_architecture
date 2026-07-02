import 'package:get/get.dart';

class NavController extends GetxController {
  final tabIndex = 0.obs;
  void changeTab(int index) => tabIndex.value = index;
  void reset() => tabIndex.value = 0;
}
