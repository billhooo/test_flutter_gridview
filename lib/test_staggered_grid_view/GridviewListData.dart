import 'package:test_gridview/test_staggered_grid_view/GridDataItem.dart';

class GridviewListData {
  List<GridDataItem>? listData;
  int? errorCode;
  String? errorMsg;

  GridviewListData({this.listData, this.errorCode, this.errorMsg});

  factory GridviewListData.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return GridviewListData();
    return GridviewListData(
      listData: json['data'] is List
          ? (json['data'] as List)
              .map((i) => GridDataItem.fromJson(i))
              .toList()
          : null,
      errorCode: json['errorCode'] != null
          ? int.tryParse(json['errorCode'].toString())
          : null,
      errorMsg: json['errorMsg']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    if (listData != null) {
      data['listData'] = listData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
