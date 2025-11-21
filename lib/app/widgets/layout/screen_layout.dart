import 'package:absensi/app/constants/colors.dart';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

final defaultPage = <Map<String, dynamic>>[
  {
    'title': 'Home',
    'icon': IconlyBroken.home,
    'route': Routes.HOME,
    'login': false,
  },
  {
    'title': 'History',
    'icon': IconlyBroken.paper_plus,
    'route': Routes.HISTORY,
    'login': true,
  },
  {
    'title': 'Profile',
    'icon': IconlyBroken.profile,
    'route': Routes.PROFILE,
    'login': true,
  },
];

final _page = defaultPage.obs;

/// get page
List<Map<String, dynamic>> get page => _page;

/// set page
set page(List<Map<String, dynamic>> v) => _page.value = v;

int getSelectedIndex() {
  int index = page.indexOf(
    page.firstWhere(
      (element) => element['route'] == Get.currentRoute,
      orElse: () => {},
    ),
  );
  return index == -1 ? 0 : index;
}

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ABSEN);
        },
        backgroundColor: AppColors.BLUE_ONE,
        child: const Icon(IconlyBold.scan, color: Colors.white),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return Theme(
            data: ThemeData(
              navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.all(
                  const TextStyle(
                    fontSize: 12,
                    color: AppColors.BLACK_ONE,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                backgroundColor: Colors.white,
                indicatorColor: AppColors.BLUE_ONE.withOpacity(0.3),
              ),
            ),
            child: Obx(() {
              return NavigationBar(
                onDestinationSelected: (index) {
                  Get.offAllNamed(page[index]['route'].toString());
                },
                indicatorColor: AppColors.BLUE_ONE,
                selectedIndex: getSelectedIndex(),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: <Widget>[
                  ...page.map((Map<String, dynamic> e) {
                    return NavigationDestination(
                      icon: Icon(e['icon'] as IconData?),
                      selectedIcon: Icon(
                        e['icon'] as IconData?,
                        color: Get.theme.scaffoldBackgroundColor,
                      ),
                      label: e['title'],
                    );
                  }),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
