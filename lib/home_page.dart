import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_gridview/AppPages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text('test AlignedGridView'),
            onTap: () {
              Get.toNamed(AppPages.TestGridView);
            },
          ),
          ListTile(
            title: const Text('test normal gridview'),
            onTap: () {
              Get.toNamed(AppPages.Test_normal_gridviewPage);
            },
          ),
          ListTile(
            title: const Text('test Test_jietishi_gridviewPage'),
            onTap: () {
              Get.toNamed(AppPages.Test_jietishi_gridviewPage);
            },
          ),
        ],
      ),
    );
  }
}
