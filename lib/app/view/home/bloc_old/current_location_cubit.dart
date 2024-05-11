import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu/data/app/full_location.dart';

class CurrentLocationCubit extends Cubit<FullLocation?> {
  CurrentLocationCubit() : super(null);

  void updateLocation(FullLocation location) {
    emit(location);
  }
}
