import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:retsept_app/blocs/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';
import 'package:retsept_app/ui/screens/add_recipe_screens/add_recipe_screen.dart';
import 'package:retsept_app/ui/screens/home_screen/screens/home_screen.dart';
import 'package:retsept_app/ui/screens/profile_screens/screens/profile_screen.dart';
import 'package:retsept_app/ui/screens/search_screen/screens/search_screen.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ExampleScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBarBloc(),
      child: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
          final selectedIndex =
              state is BottomNavBarInitial ? state.selectedIndex : 0;

          return Scaffold(
            body: _screens[selectedIndex],
            bottomNavigationBar:
                _buildBottomNavigationBar(context, selectedIndex),
            floatingActionButton: _buildFloatingActionButton(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int selectedIndex) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Color(0xff3FB4B1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GNav(
          backgroundColor: const Color(0xff3FB4B1),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          onTabChange: (index) {
            context
                .read<BottomNavBarBloc>()
                .add(BottomNavBarIndexChanged(index));
          },
          selectedIndex: selectedIndex,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          color: Colors.grey.shade800,
          gap: 8,
          iconSize: 24,
          tabBorderRadius: 15,
          tabBackgroundColor: Colors.white.withOpacity(0.2),
          activeColor: Colors.white,
          tabActiveBorder: Border.all(color: const Color(0xff3FB4B1)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: CupertinoIcons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.notifications,
              text: 'Notifi',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddRecipeScreen(),
        ));
      },
      backgroundColor: const Color(0xff3FB4B1),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
