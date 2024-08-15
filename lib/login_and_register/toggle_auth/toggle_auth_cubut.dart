import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleAuthCubut extends Cubit<bool> {
  ToggleAuthCubut() : super(true);

  void togglePage() {
    emit(!state);
  }
}
