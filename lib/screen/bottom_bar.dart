import 'package:apniride_flutter/screen/profile_screen.dart';
import 'package:apniride_flutter/screen/ride_screen.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_screen.dart';
import 'offer_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int currentindex;
  // final String selectedLocation;
  const BottomNavBar({super.key, required this.currentindex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool showTabs = false;
  bool userservice = false;
  int currentvalue = 0;
  int bottomindex = 0;
  late int _selectedIndex;
  late List<Widget> _widgetOptions;

  TextStyle optionStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentindex;
    _widgetOptions = <Widget>[
      HomeScreen(),
      RideTrackingScreen(),
      OffersScreen(),
      ProfileManagementScreen()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Color(0xFFF5F6F7), borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: BottomNavigationBar(
            selectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              //fontFamily: ApplicationFont.MulishFontFamily,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 10.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              //fontFamily: ApplicationFont.MulishFontFamily,
            ),
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            elevation: 0.0,
            enableFeedback: false,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: _selectedIndex == 0
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/home.png",
                            height: 20.h,
                            color: _selectedIndex == 0
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/home.png",
                            height: 20.h,
                            color: _selectedIndex == 0
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: _selectedIndex == 1
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/ride.png",
                            height: 20.h,
                            color: _selectedIndex == 1
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/ride.png",
                            height: 20.h,
                            color: _selectedIndex == 1
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        ),
                  label: 'Ride'),
              BottomNavigationBarItem(
                  icon: _selectedIndex == 2
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/offer.png",
                            height: 20.h,
                            color: _selectedIndex == 2
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/offer.png",
                            height: 20.h,
                            color: _selectedIndex == 2
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        ),
                  label: 'Offer'),
              BottomNavigationBarItem(
                  icon: _selectedIndex == 3
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/profile.png",
                            height: 20.h,
                            color: _selectedIndex == 3
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Image.asset(
                            "assets/profile.png",
                            height: 20.h,
                            color: _selectedIndex == 3
                                ? AppColors.background
                                : Colors.grey,
                          ),
                        ),
                  label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.background,
            onTap: _onItemTapped,
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
