import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationTab { home, notifications, profile }

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setTab(int index) {
    state = index;
  }

  void setTabByType(NavigationTab tab) {
    state = tab.index;
  }

  NavigationTab get currentTab => NavigationTab.values[state];
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((
  ref,
) {
  return NavigationNotifier();
});
