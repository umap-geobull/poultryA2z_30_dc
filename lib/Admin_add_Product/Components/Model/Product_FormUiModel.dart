class ProductFormUiModel {
  ProductFormUiModel({
    required this.status,
    required this.msg,
    required this.getdatalist,
  });
  late final int status;
  late final String msg;
  late final List<Getdatalist> getdatalist;

  ProductFormUiModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    getdatalist = List.from(json['getdatalist']).map((e)=>Getdatalist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['getdatalist'] = getdatalist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Getdatalist {
  Getdatalist({
    required this.id,
    required this.adminAutoId,
    required this.appTypeId,
    required this.size,
    required this.color,
    required this.highlights,
    required this.specification,
    required this.brand,
    required this.newArrival,
    required this.moq,
    required this.grossWt,
    required this.netWt,
    required this.unit,
    required this.quantity,
    required this.useBy,
    required this.expectedDelivery,
    required this.returnExchange,
    required this.dimension,
    required this.manufacturers,
    required this.material,
    required this.firmness,
    required this.thickness,
    required this.trialPeriod,
    required this.inventory,
    required this.registerDate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String adminAutoId;
  late final String appTypeId;
  late final String size;
  late final String color;
  late final String highlights;
  late final String specification;
  late final String brand;
  late final String newArrival;
  late final String moq;
  late final String grossWt;
  late final String netWt;
  late final String unit;
  late final String quantity;
  late final String useBy;
  late final String expectedDelivery;
  late final String returnExchange;
  late final String dimension;
  late final String manufacturers;
  late final String material;
  late final String firmness;
  late final String thickness;
  late final String trialPeriod;
  late final String inventory;
  late final String registerDate;
  late final String updatedAt;
  late final String createdAt;

  Getdatalist.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    adminAutoId = json['admin_auto_id'];
    appTypeId = json['app_type_id'];
    size = json['size'];
    color = json['color'];
    highlights = json['highlights'];
    specification = json['specification'];
    brand = json['brand'];
    newArrival = json['new_arrival'];
    moq = json['moq'];
    grossWt = json['gross_wt'];
    netWt = json['net_wt'];
    unit = json['unit'];
    quantity = json['quantity'];
    useBy = json['use_by'];
    expectedDelivery = json['expected_delivery'];
    returnExchange = json['return_exchange'];
    dimension = json['dimension'];
    manufacturers = json['manufacturers'];
    material = json['material'];
    firmness = json['firmness'];
    thickness = json['thickness'];
    trialPeriod = json['trial_period'];
    inventory = json['inventory'];
    registerDate = json['register_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['admin_auto_id'] = adminAutoId;
    _data['app_type_id'] = appTypeId;
    _data['size'] = size;
    _data['color'] = color;
    _data['highlights'] = highlights;
    _data['specification'] = specification;
    _data['brand'] = brand;
    _data['new_arrival'] = newArrival;
    _data['moq'] = moq;
    _data['gross_wt'] = grossWt;
    _data['net_wt'] = netWt;
    _data['unit'] = unit;
    _data['quantity'] = quantity;
    _data['use_by'] = useBy;
    _data['expected_delivery'] = expectedDelivery;
    _data['return_exchange'] = returnExchange;
    _data['dimension'] = dimension;
    _data['manufacturers'] = manufacturers;
    _data['material'] = material;
    _data['firmness'] = firmness;
    _data['thickness'] = thickness;
    _data['trial_period'] = trialPeriod;
    _data['inventory'] = inventory;
    _data['register_date'] = registerDate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}