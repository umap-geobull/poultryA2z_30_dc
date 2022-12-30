class Product_Size_List_Model {
  String? sizeAutoId;
  String? sizeName;

  Product_Size_List_Model({this.sizeAutoId, this.sizeName});

  Product_Size_List_Model.fromJson(Map<String, dynamic> json) {
    sizeAutoId = json['size_auto_id'];
    sizeName = json['size_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size_auto_id'] = sizeAutoId;
    data['size_name'] = sizeName;
    return data;
  }
}