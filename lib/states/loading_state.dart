import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LoadingState extends ChangeNotifier {
  bool? isLoading;
  LoadingState({
    this.isLoading,
  });
  static LoadingState of(BuildContext context, {bool listen = false}) {
    return Provider.of<LoadingState>(context, listen: listen);
  }

  void getIsLoading() => isLoading;

  void toggleLoading() {
    isLoading = !isLoading!;
    notifyListeners();
  }
}
