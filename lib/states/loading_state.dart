import 'package:flutter/cupertino.dart';

class LoadingState extends ChangeNotifier {
  bool isLoading;
  LoadingState({
    this.isLoading,
  });

  void getIsLoading() => isLoading;

  void toggleLoading() {
    if (isLoading) {
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = true;
      notifyListeners();
    }
  }
}
