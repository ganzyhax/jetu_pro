part of 'jetu_service_cubit.dart';

class JetuServiceState {
  final List<JetuServicesModel> services;
  final String selectedId;

  const JetuServiceState({
    required this.services,
    required this.selectedId,
  });

  factory JetuServiceState.initial() => const JetuServiceState(
        services: [],
        selectedId: '',
      );

  JetuServiceState copyWith({
    List<JetuServicesModel>? services,
    String? selectedId,
  }) =>
      JetuServiceState(
        services: services ?? this.services,
        selectedId: selectedId ?? this.selectedId,
      );
}
