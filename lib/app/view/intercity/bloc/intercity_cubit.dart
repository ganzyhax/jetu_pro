import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu/data/model/jetu_driver_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'intercity_state.dart';

class IntercityCubit extends Cubit<IntercityState> {
  final GraphQLClient client;

  IntercityCubit({required this.client}) : super(IntercityState.initial());

  late SharedPreferences _pref;

  void setAPoint(String? id, String? title) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: Point(id: id, title: title),
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setBPoint(String? id, String? title) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: Point(
            id: id,
            title: title,
          ),
          price: state.order?.price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setPrice(String price) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setComment(String comment) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: comment,
          date: state.order?.date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setDate(DateTime date) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: state.order?.comment,
          date: date,
          time: state.order?.time,
        ),
      ),
    );
  }

  void setTime(DateTime time) async {
    emit(
      state.copyWith(
        order: IntercityOrderModel(
          aPoint: state.order?.aPoint,
          bPoint: state.order?.bPoint,
          price: state.order?.price,
          comment: state.order?.comment,
          date: state.order?.date,
          time: time,
        ),
      ),
    );
  }

}
