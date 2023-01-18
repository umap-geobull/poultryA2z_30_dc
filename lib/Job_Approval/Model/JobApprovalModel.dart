class JobApprovalModel {
  JobApprovalModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final int status;
  late final String msg;
  late final List<JobList> data;

  JobApprovalModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>JobList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class JobList {
  JobList({
    required this.id,
    required this.adminAutoId,
    required this.appTypeId,
    required this.userAutoId,
    required this.jobTitle,
    required this.experience,
    required this.salaryExpectations,
    required this.jobDescription,
    required this.adminApproval,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String adminAutoId;
  late final String appTypeId;
  late final String userAutoId;
  late final String jobTitle;
  late final String experience;
  late final String salaryExpectations;
  late final String jobDescription;
  late final String adminApproval;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  JobList.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    appTypeId = json['app_type_id'];
    userAutoId = json['user_auto_id'];
    jobTitle = json['job_title'];
    experience = json['experience'];
    salaryExpectations = json['salary_expectations'];
    jobDescription = json['job_description'];
    adminApproval = json['admin_approval'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['app_type_id'] = appTypeId;
    _data['user_auto_id'] = userAutoId;
    _data['job_title'] = jobTitle;
    _data['experience'] = experience;
    _data['salary_expectations'] = salaryExpectations;
    _data['job_description'] = jobDescription;
    _data['admin_approval'] = adminApproval;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}