class MyJobs {
  MyJobs({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final String status;
  late final String msg;
  late final List<Data> data;

  MyJobs.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userAutoId,
    required this.candidateName,
    required this.mobileNo,
    required this.experience,
    required this.expectedSalary,
    required this.category,
    required this.resume,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String userAutoId;
  late final String candidateName;
  late final String mobileNo;
  late final String experience;
  late final String expectedSalary;
  late final String category;
  late final String resume;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userAutoId = json['user_auto_id'];
    candidateName = json['candidate_name'];
    mobileNo = json['mobile_no'];
    experience = json['experience'];
    expectedSalary = json['expected_salary'];
    category = json['category'];
    resume = json['resume'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_auto_id'] = userAutoId;
    _data['candidate_name'] = candidateName;
    _data['mobile_no'] = mobileNo;
    _data['experience'] = experience;
    _data['expected_salary'] = expectedSalary;
    _data['category'] = category;
    _data['resume'] = resume;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}