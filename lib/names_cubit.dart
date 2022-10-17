import 'package:bloc/bloc.dart';
import 'package:bloc_course_vnd/main.dart';

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() {
    emit(names.getRandomElement());
  }
}
