import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jetu/app/widgets/app_toast.dart';

class PhoneVerification {
  final String apiKey =
      'kzff7e39f70c4780fb84cf85e6ee93a92de9bbe56d2aa095bc2d12efca0c183315ff94';
  Future<bool> sendVerificationCode(
      {String? phoneNumber,
      String? generatedCode,
      BuildContext? context}) async {
    bool isBalance = await checkBalance();
    if (isBalance) {
      final response = await http.post(
        Uri.parse(
            'https://api.mobizon.kz/service/message/sendsmsmessage?recipient=$phoneNumber&text=Jetu Taxi ваш код - $generatedCode&apiKey=$apiKey'),
      );

      var decodedResponse = jsonDecode(response.body);

      if (decodedResponse['code'] == 0) {
        return true;
      } else {
        if (decodedResponse['data']['recipient'] ==
            'На данное направление отправка запрещена.') {
          AppToast.center('Не правильный номер телефона!');
        } else {
          AppToast.center('Ошибка сервера!');
        }
        return false;
      }
    } else {
      AppToast.center('Ошибка сервера!');
      return false;
    }
  }

  Future<bool> checkBalance() async {
    final response = await http.post(
      Uri.parse(
          'https://api.mobizon.kz/service/user/getownbalance?output=json&api=v1&apiKey=$apiKey'),
    );
    var decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    if (double.parse(decodedResponse['data']['balance'].toString()) > 19) {
      return true;
    } else {
      return false;
    }
  }
}
