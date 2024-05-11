import 'dart:developer';
import 'dart:math' as m;
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu/app/app_router/app_router.gr.dart';
import 'package:jetu/app/const/app_shared_keys.dart';
import 'package:jetu/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu/app/services/jetu_auth/jetu_auth.dart';
import 'package:jetu/app/services/phone_notification_func.dart';
import 'package:jetu/app/view/auth/verify_screen.dart';
import 'package:jetu/app/view/home/widgets/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu/app/widgets/app_toast.dart';
import 'package:jetu/data/model/jetu_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GraphQLClient client;

  AuthCubit({
    required this.client,
  }) : super(AuthState.initial());

  late SharedPreferences _pref;

  void init() async {
    _pref = await SharedPreferences.getInstance();
    bool isLogged = _pref.getBool(AppSharedKeys.isLogged) ?? false;
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';

    emit(state.copyWith(isLogged: isLogged, userId: userId));
  }

  String generatePinCode() {
    final Random random = Random();
    int pinCode = random.nextInt(900000) + 100000;
    return pinCode.toString();
  }

  void login({
    required BuildContext context,
    required String phone,
  }) async {
    emit(state.copyWith(isLoading: true));

    emit(state.copyWith(isLoading: false));
    String generatedCode = generatePinCode();

    bool isSuccess = await PhoneVerification().sendVerificationCode(
        phoneNumber: '7' + phone.replaceAll(' ', ''),
        generatedCode: generatedCode.toString());
    if (isSuccess) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .padding
                  .top,
            ),
            child: VerifyScreen(
              phone: phone,
              pinCode: generatedCode,
            ),
          );
        },
      );
    }
  }

  void verifyTest({
    required BuildContext context,
    required String phone,
  }) async {
    emit(state.copyWith(isLoading: true));
    _pref = await SharedPreferences.getInstance();
    var uuid = const Uuid();
    String generateId = uuid.v1();
    String userId = generateId;
    String phoneFiltered = phone.replaceAll(RegExp(r"[^\w\s]+"), '');
    phoneFiltered = ('+7' + phoneFiltered).replaceAll(' ', '');
    String? isRegisteredUser = await isRegistered(phoneFiltered);
    if (isRegisteredUser != null) {
      userId = isRegisteredUser;
    }

    _pref.setBool(AppSharedKeys.isLogged, true);
    _pref.setString(AppSharedKeys.userId, userId);
    emit(state.copyWith(
      isLoading: false,
      isLogged: true,
      userId: userId,
    ));
    BlocProvider.of<YandexMapBloc>(context)..add(YandexMapStopLoadTimer());
    BlocProvider.of<YandexMapBloc>(context)
      ..add(YandexMapClear(withLoad: false));
    BlocProvider.of<YandexMapBloc>(context)..add(YandexMapResetTimers());
    BlocProvider.of<YandexMapBloc>(context)..add(YandexMapLoad(isStart: true));
    await context.router.pushAndPopUntil(
      const HomeScreen(),
      predicate: (route) => true,
    );
  }

  void verify({
    required BuildContext context,
    required String verificationId,
    required String code,
    required String phone,
  }) async {
    emit(state.copyWith(isLoading: true));
    _pref = await SharedPreferences.getInstance();
    var uuid = const Uuid();
    String generateId = uuid.v1();
    String userId = generateId;
    String phoneFiltered = phone.replaceAll(RegExp(r"[^\w\s]+"), '');
    phoneFiltered = ('+7' + phoneFiltered).replaceAll(' ', '');
    String? isRegisteredUser = await isRegistered(phoneFiltered);
    if (isRegisteredUser != null) {
      userId = isRegisteredUser;
    } else {
      await createUserData(userId, phone);
    }

    _pref.setBool(AppSharedKeys.isLogged, true);
    _pref.setString(AppSharedKeys.userId, userId);
    emit(state.copyWith(
      isLoading: false,
      isLogged: true,
      userId: userId,
    ));
    BlocProvider.of<YandexMapBloc>(context)..add(YandexMapStopLoadTimer());
    BlocProvider.of<YandexMapBloc>(context)
      ..add(YandexMapClear(withLoad: false));
    BlocProvider.of<YandexMapBloc>(context)..add(YandexMapResetTimers());
    BlocProvider.of<YandexMapBloc>(context)..add(YandexMapLoad(isStart: true));
    await context.router.pushAndPopUntil(
      const HomeScreen(),
      predicate: (route) => true,
    );
  }

  Future<void> createUserData(String id, String phone) async {
    String formatPhone = "+7${phone.replaceAll(' ', '')}";

    final MutationOptions options = MutationOptions(
      document: gql(JetuAuthMutation.insertFirstData()),
      variables: {
        "object": {
          "id": id,
          "phone": formatPhone,
        }
      },
      parserFn: (json) => JetuUserModel.fromJson(json),
    );

    await client.mutate(options);
  }

  Future<void> updateUserData(
    BuildContext context, {
    required String name,
    required String surname,
    required String email,
  }) async {
    emit(state.copyWith(isLoading: true, success: false));
    _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';
    if (name.length > 0 && surname.length > 1) {
      final MutationOptions options = MutationOptions(
        document: gql(JetuAuthMutation.updateUserData()),
        variables: {
          "userId": userId,
          "name": name.isNotEmpty ? name : null,
          "surname": surname.isNotEmpty ? surname : null,
          "email": email.isNotEmpty ? email : null,
        },
        parserFn: (json) => JetuUserModel.fromJson(json),
      );

      await client.mutate(options);
    }
    emit(state.copyWith(isLoading: false));
    Navigator.of(context).pop();
  }

  void logout() async {
    _pref = await SharedPreferences.getInstance();
    _pref.setBool(AppSharedKeys.isLogged, false);
    _pref.setString(AppSharedKeys.userId, '');
    emit(state.copyWith(isLogged: false));
  }

  Future<String?> isRegistered(String phone) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(JetuAuthQuery.isRegistered()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "phone": '$phone',
        },
        parserFn: (json) => JetuUserList.fromUserJson(json),
      );

      QueryResult result = await client.query(options);
      JetuUserList check = result.parsedData as JetuUserList;
      if (check.users.isEmpty) {
        return null;
      }
      return check.users.first.id;
    } catch (err) {
      print('isRegistered: $err');
      return null;
    }
  }
}
