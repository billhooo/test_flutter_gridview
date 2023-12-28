class GridDataItem {
    String? imagePath;
    int? ratio;
    String?title;
    String?subTitle;

    GridDataItem({this.imagePath, this.ratio});

    factory GridDataItem.fromJson(dynamic json) {
    if(!(json is Map<String, dynamic>)) return GridDataItem();
        return GridDataItem(
            imagePath: json['imagePath']?.toString(), 
            ratio: json['ratio'] !=null ? int.tryParse(json['ratio'].toString()) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> GridDataItem = new Map<String, dynamic>();
        GridDataItem['imagePath'] = this.imagePath;
        GridDataItem['ratio'] = this.ratio;
        return GridDataItem;
    }
}