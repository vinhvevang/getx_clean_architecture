import 'package:get/get.dart';

/// Quản lý tab đang chọn ở màn hình chính (bottom navigation).
class NavController extends GetxController {
  final currentTabIndex = 0.obs;

  void changeTab(int index) => currentTabIndex.value = index;

  void resetTab() => currentTabIndex.value = 0;
}
