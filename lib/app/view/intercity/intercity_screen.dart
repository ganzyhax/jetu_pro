import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu/app/app_router/app_router.gr.dart';
import 'package:jetu/app/di/injection.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu/app/view/intercity/bloc/intercity_cubit.dart';
import 'package:jetu/app/widgets/app_bar/app_bar_default.dart';

class IntercityScreen extends StatelessWidget {
  const IntercityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IntercityCubit(
        client: injection(),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return AutoTabsScaffold(
            appBarBuilder: (_ ,tabsRouter) => AppBarBack(
              title: "Межгород",
            ),
            routes: const [
              IntercityFindScreen(),
              IntercityCreateScreen(),
            ],
            bottomNavigationBuilder: (_, tabsRouter) {
              return _buildBottomNavigationBar(
                tabsRouter.activeIndex,
                tabsRouter.setActiveIndex,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(int index, Function(int) onTap) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (value) => onTap.call(value),
      selectedItemColor: AppColors.blue,
      unselectedItemColor: AppColors.grey,
      backgroundColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      unselectedFontSize: 10,
      selectedFontSize: 10,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        _buildBottomNavigationBarItem(
          Icons.search,
          'Поиск',
        ),
        _buildBottomNavigationBarItem(
          Icons.add,
          'Создать заказ',
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    IconData pathIcon,
    String label,
  ) {
    const double sizeIcon = 32;

    return BottomNavigationBarItem(
      activeIcon: Icon(
        pathIcon,
        size: sizeIcon,
        color: AppColors.blue,
      ),
      icon: Icon(
        pathIcon,
        size: sizeIcon,
        color: AppColors.grey,
      ),
      label: label,
    );
  }
}
