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
    required this.adminAutoId,
    required this.appTypeId,
    required this.jobTitle,
    required this.experience,
    required this.salaryExpectations,
    required this.jobDescription,
    required this.rdate,
  });
  late final String id;
  late final String adminAutoId;
  late final String appTypeId;
  late final String jobTitle;
  late final String experience;
  late final String salaryExpectations;
  late final String jobDescription;
  late final String rdate;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    appTypeId = json['app_type_id'];
    jobTitle = json['job_title'];
    experience = json['experience'];
    salaryExpectations = json['salary_expectations'];
    jobDescription = json['job_description'];
    rdate = json['rdate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['app_type_id'] = appTypeId;
    _data['job_title'] = jobTitle;
    _data['experience'] = experience;
    _data['salary_expectations'] = salaryExpectations;
    _data['job_description'] = jobDescription;
    _data['rdate'] = rdate;
    return _data;
  }
}