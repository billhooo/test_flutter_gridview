import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_gridview/AppPages.dart';
import 'package:test_gridview/home_page.dart';
import 'package:test_gridview/test_jietishi_gridview/test_jietishi_gridview_view.dart';
import 'package:test_gridview/test_normal_gridview/test_normal_gridview_view.dart';
import 'package:test_gridview/test_staggered_grid_view/test_staggered_grid_view_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.HomePage,
      getPages: getPages,
    );
  }
}

final List<GetPage> getPages = [
  GetPage(
    name: AppPages.HomePage,
    showCupertinoParallax: false,
    page: () => const HomePage(),
  ),
  GetPage(
    name: AppPages.TestGridView,
    showCupertinoParallax: false,
    page: () => const Test_staggered_grid_viewPage(),
  ),
  GetPage(
    name: AppPages.Test_normal_gridviewPage,
    showCupertinoParallax: false,
    page: () => const Test_normal_gridviewPage(),
  ),
  GetPage(
    name: AppPages.Test_jietishi_gridviewPage,
    showCupertinoParallax: false,
    page: () => const Test_jietishi_gridviewPage(),
  ),
];
