import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) => state = index;
}

final selectedTabProvider = NotifierProvider<SelectedTabNotifier, int>(SelectedTabNotifier.new);

class NotificationCountNotifier extends Notifier<int> {
  @override
  int build() => 3;

  void setCount(int count) => state = count;
  void clear() => state = 0;
}

final notificationCountProvider = NotifierProvider<NotificationCountNotifier, int>(NotificationCountNotifier.new);
