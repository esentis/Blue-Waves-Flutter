import 'package:flutter/cupertino.dart';

class LoadingState extends ChangeNotifier {
  bool? isLoading;
  LoadingState({
    this.isLoading,
  });

  void getIsLoading() => isLoading;

  void toggleLoading() {
    isLoading = !isLoading!;
    notifyListeners();
  }
}
