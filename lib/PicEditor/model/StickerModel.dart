class StickerModel {
  StickerModel({
    required this.status,
    required this.allStickerImages,
  });
  late final int status;
  late final List<AllStickerImages> allStickerImages;

  StickerModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    allStickerImages = List.from(json['all_sticker_images']).map((e)=>AllStickerImages.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['all_sticker_images'] = allStickerImages.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllStickerImages {
  AllStickerImages({
    required this.stickerCatId,
    required this.stickerCatName,
    required this.stickerCatImage,
    required this.allimages,
  });
  late final String stickerCatId;
  late final String stickerCatName;
  late final String stickerCatImage;
  late final List<Allimages> allimages;

  AllStickerImages.fromJson(Map<String, dynamic> json){
    stickerCatId = json['sticker_cat_id'];
    stickerCatName = json['sticker_cat_name'];
    stickerCatImage = json['sticker_cat_image'];
    allimages = List.from(json['allimages']).map((e)=>Allimages.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sticker_cat_id'] = stickerCatId;
    _data['sticker_cat_name'] = stickerCatName;
    _data['sticker_cat_image'] = stickerCatImage;
    _data['allimages'] = allimages.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Allimages {
  Allimages({
    required this.stickerImgId,
    required this.stickerImg,
  });
  late final String stickerImgId;
  late final String stickerImg;

  Allimages.fromJson(Map<String, dynamic> json){
    stickerImgId = json['sticker_img_id'];
    stickerImg = json['sticker_img'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sticker_img_id'] = stickerImgId;
    _data['sticker_img'] = stickerImg;
    return _data;
  }
}