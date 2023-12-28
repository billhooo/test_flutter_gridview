import 'package:fair_widget/fair_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../test_staggered_grid_view/GridDataItem.dart';
import '../test_staggered_grid_view/test_staggered_grid_view_logic.dart';

class Test_jietishi_gridviewPage extends StatelessWidget {
  const Test_jietishi_gridviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(Test_staggered_grid_viewLogic());

    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Obx(() {
            return ListView(
              children: [
                GridView.custom(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  gridDelegate: SliverStairedGridDelegate(
                    crossAxisSpacing: 48,
                    mainAxisSpacing: 24,
                    startCrossAxisDirectionReversed: true,
                    pattern: [
                      const StairedGridTile(0.5, 1),
                      const StairedGridTile(0.5, 3 / 4),
                      const StairedGridTile(1.0, 10 / 4),
                    ],
                  ),
                  childrenDelegate:
                      SliverChildBuilderDelegate((context, index) {
                    GridDataItem item = logic.list[index];
                    return buildItemWidget(item);
                  }, childCount: logic.list.length),
                ),
                GridView.custom(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverWovenGridDelegate.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    pattern: [
                      const WovenGridTile(1),
                      const WovenGridTile(
                        5 / 7,
                        crossAxisRatio: 0.9,
                        alignment: AlignmentDirectional.centerEnd,
                      ),
                    ],
                  ),
                  childrenDelegate:
                      SliverChildBuilderDelegate((context, index) {
                    GridDataItem item = logic.list[index];
                    return buildItemWidget(item);
                  }, childCount: logic.list.length),
                ),
              ],
            );
          }),
        ));
  }

  Widget buildItemWidget(GridDataItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: FContainer(
        padding: EdgeInsets.zero,
        color: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: FImageView(
                item.imagePath,
                radius: 4,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FTextView(
                    item.title,
                    fontSize: 14,
                    color: Colors.black54,
                    alignment: Alignment.centerLeft,
                    marginTop: 10,
                    maxLines: 4,
                  ),
                  FTextView(
                    item.subTitle,
                    color: Colors.black54,
                    alignment: Alignment.centerLeft,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    maxLines: 4,
                    marginTop: 10,
                    marginBottom: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
