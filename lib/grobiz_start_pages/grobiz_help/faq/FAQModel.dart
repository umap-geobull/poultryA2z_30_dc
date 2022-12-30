class FAQModel {
  FAQModel({
    required this.status,
    required this.allfaqs,
  });
  late final int status;
  late final List<Allfaqs> allfaqs;

  FAQModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    allfaqs = List.from(json['allfaqs']).map((e)=>Allfaqs.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['allfaqs'] = allfaqs.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Allfaqs {
  Allfaqs({
    required this.id,
    required this.faq,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String faq;
  late final String updatedAt;
  late final String createdAt;

  Allfaqs.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    faq = json['faq'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['faq'] = faq;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}