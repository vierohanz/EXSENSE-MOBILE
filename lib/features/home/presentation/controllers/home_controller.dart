import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt _selectedTab = 0.obs;
  int get selectedTab => _selectedTab.value;

  final RxInt _notificationCount = 3.obs;
  int get notificationCount => _notificationCount.value;

  void setTab(int index) {
    _selectedTab.value = index;
  }

  void setCount(int count) {
    _notificationCount.value = count;
  }

  void clearNotifications() {
    _notificationCount.value = 0;
  }
}
