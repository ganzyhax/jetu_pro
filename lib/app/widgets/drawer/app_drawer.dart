import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/widgets/drawer/sign_in_drawer.dart';
import 'package:jetu/app/widgets/drawer/sign_out_drawer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.isLogged) {
            return SignInDrawer(userId: state.userId);
          }
          return const SignOutDrawer();
        },
      ),
    );
  }
}
