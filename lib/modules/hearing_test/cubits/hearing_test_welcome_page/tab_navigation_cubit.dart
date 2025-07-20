import 'package:flutter_bloc/flutter_bloc.dart';

class TabNavigationCubit extends Cubit<int> {
  TabNavigationCubit() : super(0);

  void changeTab(int index) => emit(index);

  // Helper methods
  void goToUploadTab() => emit(0);
  void goToSavedTab() => emit(1);
}
