class TermsModel {
  TermsModel({
    required this.status,
    required this.allterms,
  });
  late final int status;
  late final List<Allterms> allterms;

  TermsModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    allterms = List.from(json['allterms']).map((e)=>Allterms.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['allterms'] = allterms.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Allterms {
  Allterms({
    required this.id,
    required this.term,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String term;
  late final String updatedAt;
  late final String createdAt;

  Allterms.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    term = json['termncondition'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['termncondition'] = term;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}