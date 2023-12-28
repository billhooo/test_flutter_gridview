import 'package:fair_widget/fair_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_gridview/test_staggered_grid_view/GridDataItem.dart';
import 'test_staggered_grid_view_logic.dart';

class Test_staggered_grid_viewPage extends StatelessWidget {
  const Test_staggered_grid_viewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(Test_staggered_grid_viewLogic());
    final state = Get.find<Test_staggered_grid_viewLogic>().state;

    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Obx(() {
            return AlignedGridView.count(
              itemCount: logic.list.length,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 7,
              itemBuilder: (BuildContext context, int index) {
                GridDataItem item = logic.list[index];
                return buildItemWidget(item);
              },
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
                    maxLines: 4,
                    marginTop: 10,
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
