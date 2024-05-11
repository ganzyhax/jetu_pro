import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu/app/view/order/bloc/order_cubit.dart';

class LinearAnimationCard extends StatefulWidget {
  final String orderId;
  const LinearAnimationCard({super.key, required this.orderId});

  @override
  State<LinearAnimationCard> createState() => _LinearAnimationCardState();
}

class _LinearAnimationCardState extends State<LinearAnimationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<OrderCubit>().rejectAlertFare(widget.orderId);
          log("Анимация завершена " + widget.orderId);
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _controller.value,
          backgroundColor: Colors.black,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        );
      },
    );
  }
}
