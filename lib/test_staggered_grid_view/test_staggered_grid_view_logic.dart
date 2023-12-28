import 'package:get/get.dart';
import 'package:test_gridview/http_util.dart';
import 'package:test_gridview/test_staggered_grid_view/GridDataItem.dart';
import 'package:test_gridview/test_staggered_grid_view/GridviewListData.dart';
import 'dart:math';
import 'dart:typed_data';

import 'test_staggered_grid_view_state.dart';

class Test_staggered_grid_viewLogic extends GetxController {
  final Test_staggered_grid_viewState state = Test_staggered_grid_viewState();
  var list = [].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    requestData();
  }

  Future<void> requestData() async {
    await HttpUtil.requestGet(
      'https://wos2.58cdn.com.cn/DeFazYxWvDti/frsupload/3a0809703d09800b54491c4d1fc710da_staggeredview_data.json',
      success: (dynamic data, {BaseModel? response}) async {
        list.clear();
        GridviewListData result = GridviewListData.fromJson({'data': data});
        List? testData = result.listData?.map((e) {
          e.title = generateRandomString();
          e.subTitle = generateRandomString();
          return e;
        }).toList();
        list.addAll(testData ?? []);
      },
      fail: (BaseModel response) {},
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  String generateRandomString() {
    final Random random = Random();
    const int minLength = 5;
    const int maxLength = 30;

    int length = minLength + random.nextInt(maxLength - minLength + 1);

    final Uint8List bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      // 生成ASCII码在32到126之间的字符
      bytes[i] = 32 + random.nextInt(95);
    }

    return String.fromCharCodes(bytes);
  }
}
