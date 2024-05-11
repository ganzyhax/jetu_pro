import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu/data/model/jetu_services_model.dart';

part 'jetu_service_state.dart';

class JetuServiceCubit extends Cubit<JetuServiceState> {
  JetuServiceCubit() : super(JetuServiceState.initial());

  init(List<JetuServicesModel> services) async {
    emit(state.copyWith(
      services: services,
      selectedId: services.first.id,
    ));
  }

  selectService(JetuServicesModel service) async {
    emit(state.copyWith(selectedId: service.id));
  }
}
