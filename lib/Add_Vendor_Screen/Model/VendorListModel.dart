class VendorListModel {
  VendorListModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final String status;
  late final String msg;
  late final List<GetVendorListCategory> data;

  VendorListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>GetVendorListCategory.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetVendorListCategory {
  GetVendorListCategory({
    required this.id,
    required this.CATEGORYAUTOID,
    required this.ADMINAUTOID,
    required this.APPTYPEID,
    required this.USERAUTOID,
    required this.MINORDERVALUE,
    required this.PRICERANGE,
    required this.VENDORPROFILE,
    required this.SUPPLIERPROFILE,
    required this.FIRMNAME,
    required this.OWNERNAME,
    required this.EMAILID,
    required this.MARKETINGPERSONEMAILID,
    required this.SALESPERSONEMAILID,
    required this.CONCERNPERSONEMAILID,
    required this.DEALEREMAILID,
    required this.DISTRIBUTOREMAILID,
    required this.EDITOREMAILID,
    required this.ASSOCIATIONEMAILID,
    required this.MEMBEREMAILID,
    required this.LINESUPERVISOREMAILID,
    required this.CONSULTANTEMAILID,
    required this.AGENTEMAILID,
    required this.COMPANYEMAILID,
    required this.CAEMAILID,
    required this.PHONENUMBER,
    required this.MARKETINGPERSONPHONENUMBER,
    required this.SALESPERSONPHONENUMBER,
    required this.CONCERNPERSONPHONENUMBER,
    required this.DEALERPHONENUMBER,
    required this.DISTRIBUTORPHONENUMBER,
    required this.EDITORPHONENUMBER,
    required this.ASSOCIATIONPHONENUMBER,
    required this.MEMBERPHONENUMBER,
    required this.LINESUPERVISORPHONENUMBER,
    required this.CONSULTANTPHONENUMBER,
    required this.AGENTPHONENUMBER,
    required this.COMPANYPHONENUMBER,
    required this.CAPHONENUMBER,
    required this.TECHNICIANPHONENUMBER,
    required this.CONTACTPERSONPHONENUMBER,
    required this.HODPHONENUMBER,
    required this.OUTLETPHONENUMBER,
    required this.OFFICEADDRESS,
    required this.AREA,
    required this.CONSULTANTAREA,
    required this.CHICKENSHOPAREA,
    required this.AREAOFWORKING,
    required this.AREASPECIFIC,
    required this.SALESPERSONAREA,
    required this.BRANCHAREA,
    required this.AREAOFSUPPLY,
    required this.WAREHOUSEAREA,
    required this.AREAOFDELIVERY,
    required this.WORKINGAREA,
    required this.SUPPLYAREA,
    required this.OUTLETAREA,
    required this.PINCODE,
    required this.CONSULTANTPINCODE,
    required this.DEALERPINCODE,
    required this.CAPINCODE,
    required this.CHICKENSHOPPINCODE,
    required this.COMPANYPINCODE,
    required this.CONCERNPERSONPINCODE,
    required this.DISTRIBUTORPINCODE,
    required this.SALESPERSONPINCODE,
    required this.LINESUPERVISORPINCODE,
    required this.BRANCHPINCODE,
    required this.OUTLETPINCODE,
    required this.ASSOCIATIONPINCODE,
    required this.WAREHOUSEPINCODE,
    required this.CONCERNPERSON,
    required this.CONCERNPERSONNAME,
    required this.ADDRESS,
    required this.FARMADDRESS,
    required this.CAADDRESS,
    required this.DEALERADDRESS,
    required this.CHICKENSHOPADDRESS,
    required this.COMPANYADDRESS,
    required this.FACTORYADDRESS,
    required this.BRANCHADDRESS,
    required this.LINESUPERVISORBRANCHADDRESS,
    required this.AGENTADDRESS,
    required this.OUTLETADDRESS,
    required this.ASSOCIATIONADDRESS,
    required this.WAREHOUSEADDRESS,
    required this.ABOUTPRODUCT,
    required this.ADDITIONALINFORMATION,
    required this.AGENTNAME,
    required this.ANYTHINGTOSPECIFY,
    required this.ANYSPECIFICBREED,
    required this.ANYTHINGMORETOSAY,
    required this.ANYTHINGTOSAY,
    required this.ANYTHINGTOSPECIFY2,
    required this.ASSOCIATIONDESIGNATION,
    required this.ASSOCIATIONMEMBER,
    required this.ASSOCIATIONNAME,
    required this.MANAGERNAME,
    required this.BRANCHNAME,
    required this.BREEDERFARMNAME,
    required this.BREEDNAME,
    required this.CAPACITY,
    required this.CATEGORY,
    required this.CACONCERNPERSON,
    required this.CHICKENSTORINGCAPACITY,
    required this.COMPANYNAME,
    required this.COMPANYWEBSITE,
    required this.COMPOSITION,
    required this.CONTACTNUMBER,
    required this.CONTACTPERSON,
    required this.CONTACTPERSONCONTACTNUMBER,
    required this.DATEOFBIRTH,
    required this.DISTRIBUTORNAME,
    required this.DEALERFIRMNAME,
    required this.DEALERNAME,
    required this.DEPO,
    required this.DESCRIPTION,
    required this.DIRECTORNAME,
    required this.MEMBERNAME,
    required this.DISTRIBUTOROFCOMPANY,
    required this.DISTRIBUTORPINCODE2,
    required this.DOCTOR,
    required this.CONSULTANT,
    required this.DOSE,
    required this.EDITORNAME,
    required this.EGGSTORINGCAPACITY,
    required this.EMAIL,
    required this.EXHIBITIONNAME,
    required this.EXPERTISE,
    required this.FACILITY,
    required this.FORMULATION,
    required this.FULLLOAD,
    required this.INSTITUTENAME,
    required this.INSTITUTION,
    required this.ENTREPRENEUR,
    required this.LABNAME,
    required this.LINESUPERVISOR,
    required this.LISTOFPROJECT,
    required this.LISTOFSERVICE,
    required this.MARKETINGPERSON,
    required this.MEMBERDESIGNATION,
    required this.MOBILENUMBER,
    required this.MRP,
    required this.NAME,
    required this.OTHERS,
    required this.PACKING,
    required this.PARTNERNAME,
    required this.PERSONNAME,
    required this.PHONENUMBER2,
    required this.POSITION,
    required this.PRODUCT,
    required this.PRODUCTDETAILS,
    required this.PRODUCTNAME,
    required this.PRODUCTUSAGE,
    required this.HODNAME,
    required this.PUBLICATIONHOUSE,
    required this.QUALIFICATION,
    required this.RAWMATERIALNAME,
    required this.REMARK,
    required this.RETAILOUTLETNAME,
    required this.SALESPERSONNAME,
    required this.SOFTWARENAME,
    required this.SPECIALISATION,
    required this.MASTERS,
    required this.SPECIALISEIN,
    required this.SPECIALITY,
    required this.SPECIESNAME,
    required this.SPECIFICATION,
    required this.STATE,
    required this.SUBJECT,
    required this.SUBSIDYLIST,
    required this.TECHNICIANEMAIL,
    required this.TECHNICIANNAME,
    required this.TRANSPORTID,
    required this.USEDFOR,
    required this.VALUEADDITION,
    required this.VALUEADDITIONREMARK,
    required this.WAREHOUSE,
    required this.WEBSITE,
    required this.WHICHTYPEOFLABOUR,
    required this.YPEOFCERTIFICATION,
    required this.rdate,
    required this.updatedAt,
    required this.createdAt,
  });
  late final String id;
  late final String CATEGORYAUTOID;
  late final String ADMINAUTOID;
  late final String APPTYPEID;
  late final String USERAUTOID;
  late final String MINORDERVALUE;
  late final String PRICERANGE;
  late final String VENDORPROFILE;
  late final String SUPPLIERPROFILE;
  late final String FIRMNAME;
  late final String OWNERNAME;
  late final String EMAILID;
  late final String MARKETINGPERSONEMAILID;
  late final String SALESPERSONEMAILID;
  late final String CONCERNPERSONEMAILID;
  late final String DEALEREMAILID;
  late final String DISTRIBUTOREMAILID;
  late final String EDITOREMAILID;
  late final String ASSOCIATIONEMAILID;
  late final String MEMBEREMAILID;
  late final String LINESUPERVISOREMAILID;
  late final String CONSULTANTEMAILID;
  late final String AGENTEMAILID;
  late final String COMPANYEMAILID;
  late final String CAEMAILID;
  late final String PHONENUMBER;
  late final String MARKETINGPERSONPHONENUMBER;
  late final String SALESPERSONPHONENUMBER;
  late final String CONCERNPERSONPHONENUMBER;
  late final String DEALERPHONENUMBER;
  late final String DISTRIBUTORPHONENUMBER;
  late final String EDITORPHONENUMBER;
  late final String ASSOCIATIONPHONENUMBER;
  late final String MEMBERPHONENUMBER;
  late final String LINESUPERVISORPHONENUMBER;
  late final String CONSULTANTPHONENUMBER;
  late final String AGENTPHONENUMBER;
  late final String COMPANYPHONENUMBER;
  late final String CAPHONENUMBER;
  late final String TECHNICIANPHONENUMBER;
  late final String CONTACTPERSONPHONENUMBER;
  late final String HODPHONENUMBER;
  late final String OUTLETPHONENUMBER;
  late final String OFFICEADDRESS;
  late final String AREA;
  late final String CONSULTANTAREA;
  late final String CHICKENSHOPAREA;
  late final String AREAOFWORKING;
  late final String AREASPECIFIC;
  late final String SALESPERSONAREA;
  late final String BRANCHAREA;
  late final String AREAOFSUPPLY;
  late final String WAREHOUSEAREA;
  late final String AREAOFDELIVERY;
  late final String WORKINGAREA;
  late final String SUPPLYAREA;
  late final String OUTLETAREA;
  late final String PINCODE;
  late final String CONSULTANTPINCODE;
  late final String DEALERPINCODE;
  late final String CAPINCODE;
  late final String CHICKENSHOPPINCODE;
  late final String COMPANYPINCODE;
  late final String CONCERNPERSONPINCODE;
  late final String DISTRIBUTORPINCODE;
  late final String SALESPERSONPINCODE;
  late final String LINESUPERVISORPINCODE;
  late final String BRANCHPINCODE;
  late final String OUTLETPINCODE;
  late final String ASSOCIATIONPINCODE;
  late final String WAREHOUSEPINCODE;
  late final String CONCERNPERSON;
  late final String CONCERNPERSONNAME;
  late final String ADDRESS;
  late final String FARMADDRESS;
  late final String CAADDRESS;
  late final String DEALERADDRESS;
  late final String CHICKENSHOPADDRESS;
  late final String COMPANYADDRESS;
  late final String FACTORYADDRESS;
  late final String BRANCHADDRESS;
  late final String LINESUPERVISORBRANCHADDRESS;
  late final String AGENTADDRESS;
  late final String OUTLETADDRESS;
  late final String ASSOCIATIONADDRESS;
  late final String WAREHOUSEADDRESS;
  late final String ABOUTPRODUCT;
  late final String ADDITIONALINFORMATION;
  late final String AGENTNAME;
  late final String ANYTHINGTOSPECIFY;
  late final String ANYSPECIFICBREED;
  late final String ANYTHINGMORETOSAY;
  late final String ANYTHINGTOSAY;
  late final String ANYTHINGTOSPECIFY2;
  late final String ASSOCIATIONDESIGNATION;
  late final String ASSOCIATIONMEMBER;
  late final String ASSOCIATIONNAME;
  late final String MANAGERNAME;
  late final String BRANCHNAME;
  late final String BREEDERFARMNAME;
  late final String BREEDNAME;
  late final String CAPACITY;
  late final String CATEGORY;
  late final String CACONCERNPERSON;
  late final String CHICKENSTORINGCAPACITY;
  late final String COMPANYNAME;
  late final String COMPANYWEBSITE;
  late final String COMPOSITION;
  late final String CONTACTNUMBER;
  late final String CONTACTPERSON;
  late final String CONTACTPERSONCONTACTNUMBER;
  late final String DATEOFBIRTH;
  late final String DISTRIBUTORNAME;
  late final String DEALERFIRMNAME;
  late final String DEALERNAME;
  late final String DEPO;
  late final String DESCRIPTION;
  late final String DIRECTORNAME;
  late final String MEMBERNAME;
  late final String DISTRIBUTOROFCOMPANY;
  late final String DISTRIBUTORPINCODE2;
  late final String DOCTOR;
  late final String CONSULTANT;
  late final String DOSE;
  late final String EDITORNAME;
  late final String EGGSTORINGCAPACITY;
  late final String EMAIL;
  late final String EXHIBITIONNAME;
  late final String EXPERTISE;
  late final String FACILITY;
  late final String FORMULATION;
  late final String FULLLOAD;
  late final String INSTITUTENAME;
  late final String INSTITUTION;
  late final String ENTREPRENEUR;
  late final String LABNAME;
  late final String LINESUPERVISOR;
  late final String LISTOFPROJECT;
  late final String LISTOFSERVICE;
  late final String MARKETINGPERSON;
  late final String MEMBERDESIGNATION;
  late final String MOBILENUMBER;
  late final String MRP;
  late final String NAME;
  late final String OTHERS;
  late final String PACKING;
  late final String PARTNERNAME;
  late final String PERSONNAME;
  late final String PHONENUMBER2;
  late final String POSITION;
  late final String PRODUCT;
  late final String PRODUCTDETAILS;
  late final String PRODUCTNAME;
  late final String PRODUCTUSAGE;
  late final String HODNAME;
  late final String PUBLICATIONHOUSE;
  late final String QUALIFICATION;
  late final String RAWMATERIALNAME;
  late final String REMARK;
  late final String RETAILOUTLETNAME;
  late final String SALESPERSONNAME;
  late final String SOFTWARENAME;
  late final String SPECIALISATION;
  late final String MASTERS;
  late final String SPECIALISEIN;
  late final String SPECIALITY;
  late final String SPECIESNAME;
  late final String SPECIFICATION;
  late final String STATE;
  late final String SUBJECT;
  late final String SUBSIDYLIST;
  late final String TECHNICIANEMAIL;
  late final String TECHNICIANNAME;
  late final String TRANSPORTID;
  late final String USEDFOR;
  late final String VALUEADDITION;
  late final String VALUEADDITIONREMARK;
  late final String WAREHOUSE;
  late final String WEBSITE;
  late final String WHICHTYPEOFLABOUR;
  late final String YPEOFCERTIFICATION;
  late final String rdate;
  late final String updatedAt;
  late final String createdAt;

  GetVendorListCategory.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    CATEGORYAUTOID = json['CATEGORY_AUTO_ID'];
    ADMINAUTOID = json['ADMIN_AUTO_ID'];
    APPTYPEID = json['APP_TYPE_ID'];
    USERAUTOID = json['USER_AUTO_ID'];
    MINORDERVALUE = json['MIN_ORDER_VALUE'];
    PRICERANGE = json['PRICE_RANGE'];
    VENDORPROFILE = json['VENDOR_PROFILE'];
    SUPPLIERPROFILE = json['SUPPLIER_PROFILE'];
    FIRMNAME = json['FIRM_NAME'];
    OWNERNAME = json['OWNER_NAME'];
    EMAILID = json['EMAIL_ID'];
    MARKETINGPERSONEMAILID = json['MARKETING_PERSON_EMAIL_ID'];
    SALESPERSONEMAILID = json['SALES_PERSON_EMAIL_ID'];
    CONCERNPERSONEMAILID = json['CONCERN_PERSON_EMAIL_ID'];
    DEALEREMAILID = json['DEALER_EMAIL_ID'];
    DISTRIBUTOREMAILID = json['DISTRIBUTOR_EMAIL_ID'];
    EDITOREMAILID = json['EDITOR_EMAIL_ID'];
    ASSOCIATIONEMAILID = json['ASSOCIATION_EMAIL_ID'];
    MEMBEREMAILID = json['MEMBER_EMAIL_ID'];
    LINESUPERVISOREMAILID = json['LINE_SUPERVISOR_EMAIL_ID'];
    CONSULTANTEMAILID = json['CONSULTANT_EMAIL_ID'];
    AGENTEMAILID = json['AGENT_EMAIL_ID'];
    COMPANYEMAILID = json['COMPANY_EMAIL_ID'];
    CAEMAILID = json['CA_EMAIL_ID'];
    PHONENUMBER = json['PHONE_NUMBER'];
    MARKETINGPERSONPHONENUMBER = json['MARKETING_PERSON_PHONE_NUMBER'];
    SALESPERSONPHONENUMBER = json['SALES_PERSON_PHONE_NUMBER'];
    CONCERNPERSONPHONENUMBER = json['CONCERN_PERSON_PHONE_NUMBER'];
    DEALERPHONENUMBER = json['DEALER_PHONE_NUMBER'];
    DISTRIBUTORPHONENUMBER = json['DISTRIBUTOR_PHONE_NUMBER'];
    EDITORPHONENUMBER = json['EDITOR_PHONE_NUMBER'];
    ASSOCIATIONPHONENUMBER = json['ASSOCIATION_PHONE_NUMBER'];
    MEMBERPHONENUMBER = json['MEMBER_PHONE_NUMBER'];
    LINESUPERVISORPHONENUMBER = json['LINE_SUPERVISOR_PHONE_NUMBER'];
    CONSULTANTPHONENUMBER = json['CONSULTANT_PHONE_NUMBER'];
    AGENTPHONENUMBER = json['AGENT_PHONE_NUMBER'];
    COMPANYPHONENUMBER = json['COMPANY_PHONE_NUMBER'];
    CAPHONENUMBER = json['CA_PHONE_NUMBER'];
    TECHNICIANPHONENUMBER = json['TECHNICIAN_PHONE_NUMBER'];
    CONTACTPERSONPHONENUMBER = json['CONTACTPERSON_PHONE_NUMBER'];
    HODPHONENUMBER = json['HOD_PHONE_NUMBER'];
    OUTLETPHONENUMBER = json['OUTLET_PHONE_NUMBER'];
    OFFICEADDRESS = json['OFFICE_ADDRESS'];
    AREA = json['AREA'];
    CONSULTANTAREA = json['CONSULTANT_AREA'];
    CHICKENSHOPAREA = json['CHICKEN_SHOP_AREA'];
    AREAOFWORKING = json['AREA_OF_WORKING'];
    AREASPECIFIC = json['AREA_SPECIFIC'];
    SALESPERSONAREA = json['SALES_PERSON_AREA'];
    BRANCHAREA = json['BRANCH_AREA'];
    AREAOFSUPPLY = json['AREA_OF_SUPPLY'];
    WAREHOUSEAREA = json['WAREHOUSE_AREA'];
    AREAOFDELIVERY = json['AREA_OF_DELIVERY'];
    WORKINGAREA = json['WORKING_AREA'];
    SUPPLYAREA = json['SUPPLY_AREA'];
    OUTLETAREA = json['OUTLET_AREA'];
    PINCODE = json['PINCODE'];
    CONSULTANTPINCODE = json['CONSULTANT_PINCODE'];
    DEALERPINCODE = json['DEALER_PINCODE'];
    CAPINCODE = json['CA_PINCODE'];
    CHICKENSHOPPINCODE = json['CHICKEN_SHOP_PINCODE'];
    COMPANYPINCODE = json['COMPANY_PINCODE'];
    CONCERNPERSONPINCODE = json['CONCERN_PERSON_PINCODE'];
    DISTRIBUTORPINCODE = json['DISTRIBUTOR_PINCODE'];
    SALESPERSONPINCODE = json['SALES_PERSON_PINCODE'];
    LINESUPERVISORPINCODE = json['LINE_SUPERVISOR_PINCODE'];
    BRANCHPINCODE = json['BRANCH_PINCODE'];
    OUTLETPINCODE = json['OUTLET_PINCODE'];
    ASSOCIATIONPINCODE = json['ASSOCIATION_PINCODE'];
    WAREHOUSEPINCODE = json['WAREHOUSE_PINCODE'];
    CONCERNPERSON = json['CONCERN_PERSON'];
    CONCERNPERSONNAME = json['CONCERN_PERSON_NAME'];
    ADDRESS = json['ADDRESS'];
    FARMADDRESS = json['FARM_ADDRESS'];
    CAADDRESS = json['CA_ADDRESS'];
    DEALERADDRESS = json['DEALER_ADDRESS'];
    CHICKENSHOPADDRESS = json['CHICKEN_SHOP_ADDRESS'];
    COMPANYADDRESS = json['COMPANY_ADDRESS'];
    FACTORYADDRESS = json['FACTORY_ADDRESS'];
    BRANCHADDRESS = json['BRANCH_ADDRESS'];
    LINESUPERVISORBRANCHADDRESS = json['LINE_SUPERVISOR_BRANCH_ADDRESS'];
    AGENTADDRESS = json['AGENT_ADDRESS'];
    OUTLETADDRESS = json['OUTLET_ADDRESS'];
    ASSOCIATIONADDRESS = json['ASSOCIATION_ADDRESS'];
    WAREHOUSEADDRESS = json['WAREHOUSE_ADDRESS'];
    ABOUTPRODUCT = json['ABOUT_PRODUCT'];
    ADDITIONALINFORMATION = json['ADDITIONAL_INFORMATION'];
    AGENTNAME = json['AGENT_NAME'];
    ANYTHINGTOSPECIFY = json['ANYTHING_TO_SPECIFY'];
    ANYSPECIFICBREED = json['ANY_SPECIFIC_BREED'];
    ANYTHINGMORETOSAY = json['ANY_THING_MORE_TO_SAY'];
    ANYTHINGTOSAY = json['ANY_THING_TO_SAY'];
    ANYTHINGTOSPECIFY2 = json['ANY_THING_TO_SPECIFY'];
    ASSOCIATIONDESIGNATION = json['ASSOCIATION_DESIGNATION'];
    ASSOCIATIONMEMBER = json['ASSOCIATION_MEMBER'];
    ASSOCIATIONNAME = json['ASSOCIATION_NAME'];
    MANAGERNAME = json['MANAGER_NAME'];
    BRANCHNAME = json['BRANCH_NAME'];
    BREEDERFARMNAME = json['BREEDER_FARM_NAME'];
    BREEDNAME = json['BREED_NAME'];
    CAPACITY = json['CAPACITY'];
    CATEGORY = json['CATEGORY'];
    CACONCERNPERSON = json['CA_CONCERN_PERSON'];
    CHICKENSTORINGCAPACITY = json['CHICKEN_STORING_CAPACITY'];
    COMPANYNAME = json['COMPANY_NAME'];
    COMPANYWEBSITE = json['COMPANY_WEBSITE'];
    COMPOSITION = json['COMPOSITION'];
    CONTACTNUMBER = json['CONTACT_NUMBER'];
    CONTACTPERSON = json['CONTACT_PERSON'];
    CONTACTPERSONCONTACTNUMBER = json['CONTACT_PERSON_CONTACT_NUMBER'];
    DATEOFBIRTH = json['DATE_OF_BIRTH'];
    DISTRIBUTORNAME = json['DISTRIBUTOR_NAME'];
    DEALERFIRMNAME = json['DEALER_FIRM_NAME'];
    DEALERNAME = json['DEALER_NAME'];
    DEPO = json['DEPO'];
    DESCRIPTION = json['DESCRIPTION'];
    DIRECTORNAME = json['DIRECTOR_NAME'];
    MEMBERNAME = json['MEMBER_NAME'];
    DISTRIBUTOROFCOMPANY = json['DISTRIBUTOR_OF_COMPANY'];
    DISTRIBUTORPINCODE2 = json['DISTRIBUTOR_PIN_CODE'];
    DOCTOR = json['DOCTOR'];
    CONSULTANT = json['CONSULTANT'];
    DOSE = json['DOSE'];
    EDITORNAME = json['EDITOR_NAME'];
    EGGSTORINGCAPACITY = json['EGG_STORING_CAPACITY'];
    EMAIL = json['EMAIL'];
    EXHIBITIONNAME = json['EXHIBITION_NAME'];
    EXPERTISE = json['EXPERTISE'];
    FACILITY = json['FACILITY'];
    FORMULATION = json['FORMULATION'];
    FULLLOAD = json['FULL_LOAD'];
    INSTITUTENAME = json['INSTITUTE_NAME'];
    INSTITUTION = json['INSTITUTION'];
    ENTREPRENEUR = json['ENTREPRENEUR'];
    LABNAME = json['LAB_NAME'];
    LINESUPERVISOR = json['LINE_SUPERVISOR'];
    LISTOFPROJECT = json['LIST_OF_PROJECT'];
    LISTOFSERVICE = json['LIST_OF_SERVICE'];
    MARKETINGPERSON = json['MARKETING_PERSON'];
    MEMBERDESIGNATION = json['MEMBER_DESIGNATION'];
    MOBILENUMBER = json['MOBILE_NUMBER'];
    MRP = json['MRP'];
    NAME = json['NAME'];
    OTHERS = json['OTHERS'];
    PACKING = json['PACKING'];
    PARTNERNAME = json['PARTNER_NAME'];
    PERSONNAME = json['PERSON_NAME'];
    PHONENUMBER2 = json['PHONENUMBER'];
    POSITION = json['POSITION'];
    PRODUCT = json['PRODUCT'];
    PRODUCTDETAILS = json['PRODUCT_DETAILS'];
    PRODUCTNAME = json['PRODUCT_NAME'];
    PRODUCTUSAGE = json['PRODUCT_USAGE'];
    HODNAME = json['HOD_NAME'];
    PUBLICATIONHOUSE = json['PUBLICATION_HOUSE'];
    QUALIFICATION = json['QUALIFICATION'];
    RAWMATERIALNAME = json['RAW_MATERIAL_NAME'];
    REMARK = json['REMARK'];
    RETAILOUTLETNAME = json['RETAIL_OUTLET_NAME'];
    SALESPERSONNAME = json['SALES_PERSON_NAME'];
    SOFTWARENAME = json['SOFTWARE_NAME'];
    SPECIALISATION = json['SPECIALISATION'];
    MASTERS = json['MASTERS'];
    SPECIALISEIN = json['SPECIALISE_IN'];
    SPECIALITY = json['SPECIALITY'];
    SPECIESNAME = json['SPECIES_NAME'];
    SPECIFICATION = json['SPECIFICATION'];
    STATE = json['STATE'];
    SUBJECT = json['SUBJECT'];
    SUBSIDYLIST = json['SUBSIDY_LIST'];
    TECHNICIANEMAIL = json['TECHNICIAN_EMAIL'];
    TECHNICIANNAME = json['TECHNICIAN_NAME'];
    TRANSPORTID = json['TRANSPORT_ID'];
    USEDFOR = json['USED_FOR'];
    VALUEADDITION = json['VALUE_ADDITION'];
    VALUEADDITIONREMARK = json['VALUE_ADDITION_REMARK'];
    WAREHOUSE = json['WAREHOUSE'];
    WEBSITE = json['WEBSITE'];
    WHICHTYPEOFLABOUR = json['WHICH_TYPE_OF_LABOUR'];
    YPEOFCERTIFICATION = json['YPE_OF_CERTIFICATION'];
    rdate = json['rdate'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['CATEGORY_AUTO_ID'] = CATEGORYAUTOID;
    _data['ADMIN_AUTO_ID'] = ADMINAUTOID;
    _data['APP_TYPE_ID'] = APPTYPEID;
    _data['USER_AUTO_ID'] = USERAUTOID;
    _data['MIN_ORDER_VALUE'] = MINORDERVALUE;
    _data['PRICE_RANGE'] = PRICERANGE;
    _data['VENDOR_PROFILE'] = VENDORPROFILE;
    _data['SUPPLIER_PROFILE'] = SUPPLIERPROFILE;
    _data['FIRM_NAME'] = FIRMNAME;
    _data['OWNER_NAME'] = OWNERNAME;
    _data['EMAIL_ID'] = EMAILID;
    _data['MARKETING_PERSON_EMAIL_ID'] = MARKETINGPERSONEMAILID;
    _data['SALES_PERSON_EMAIL_ID'] = SALESPERSONEMAILID;
    _data['CONCERN_PERSON_EMAIL_ID'] = CONCERNPERSONEMAILID;
    _data['DEALER_EMAIL_ID'] = DEALEREMAILID;
    _data['DISTRIBUTOR_EMAIL_ID'] = DISTRIBUTOREMAILID;
    _data['EDITOR_EMAIL_ID'] = EDITOREMAILID;
    _data['ASSOCIATION_EMAIL_ID'] = ASSOCIATIONEMAILID;
    _data['MEMBER_EMAIL_ID'] = MEMBEREMAILID;
    _data['LINE_SUPERVISOR_EMAIL_ID'] = LINESUPERVISOREMAILID;
    _data['CONSULTANT_EMAIL_ID'] = CONSULTANTEMAILID;
    _data['AGENT_EMAIL_ID'] = AGENTEMAILID;
    _data['COMPANY_EMAIL_ID'] = COMPANYEMAILID;
    _data['CA_EMAIL_ID'] = CAEMAILID;
    _data['PHONE_NUMBER'] = PHONENUMBER;
    _data['MARKETING_PERSON_PHONE_NUMBER'] = MARKETINGPERSONPHONENUMBER;
    _data['SALES_PERSON_PHONE_NUMBER'] = SALESPERSONPHONENUMBER;
    _data['CONCERN_PERSON_PHONE_NUMBER'] = CONCERNPERSONPHONENUMBER;
    _data['DEALER_PHONE_NUMBER'] = DEALERPHONENUMBER;
    _data['DISTRIBUTOR_PHONE_NUMBER'] = DISTRIBUTORPHONENUMBER;
    _data['EDITOR_PHONE_NUMBER'] = EDITORPHONENUMBER;
    _data['ASSOCIATION_PHONE_NUMBER'] = ASSOCIATIONPHONENUMBER;
    _data['MEMBER_PHONE_NUMBER'] = MEMBERPHONENUMBER;
    _data['LINE_SUPERVISOR_PHONE_NUMBER'] = LINESUPERVISORPHONENUMBER;
    _data['CONSULTANT_PHONE_NUMBER'] = CONSULTANTPHONENUMBER;
    _data['AGENT_PHONE_NUMBER'] = AGENTPHONENUMBER;
    _data['COMPANY_PHONE_NUMBER'] = COMPANYPHONENUMBER;
    _data['CA_PHONE_NUMBER'] = CAPHONENUMBER;
    _data['TECHNICIAN_PHONE_NUMBER'] = TECHNICIANPHONENUMBER;
    _data['CONTACTPERSON_PHONE_NUMBER'] = CONTACTPERSONPHONENUMBER;
    _data['HOD_PHONE_NUMBER'] = HODPHONENUMBER;
    _data['OUTLET_PHONE_NUMBER'] = OUTLETPHONENUMBER;
    _data['OFFICE_ADDRESS'] = OFFICEADDRESS;
    _data['AREA'] = AREA;
    _data['CONSULTANT_AREA'] = CONSULTANTAREA;
    _data['CHICKEN_SHOP_AREA'] = CHICKENSHOPAREA;
    _data['AREA_OF_WORKING'] = AREAOFWORKING;
    _data['AREA_SPECIFIC'] = AREASPECIFIC;
    _data['SALES_PERSON_AREA'] = SALESPERSONAREA;
    _data['BRANCH_AREA'] = BRANCHAREA;
    _data['AREA_OF_SUPPLY'] = AREAOFSUPPLY;
    _data['WAREHOUSE_AREA'] = WAREHOUSEAREA;
    _data['AREA_OF_DELIVERY'] = AREAOFDELIVERY;
    _data['WORKING_AREA'] = WORKINGAREA;
    _data['SUPPLY_AREA'] = SUPPLYAREA;
    _data['OUTLET_AREA'] = OUTLETAREA;
    _data['PINCODE'] = PINCODE;
    _data['CONSULTANT_PINCODE'] = CONSULTANTPINCODE;
    _data['DEALER_PINCODE'] = DEALERPINCODE;
    _data['CA_PINCODE'] = CAPINCODE;
    _data['CHICKEN_SHOP_PINCODE'] = CHICKENSHOPPINCODE;
    _data['COMPANY_PINCODE'] = COMPANYPINCODE;
    _data['CONCERN_PERSON_PINCODE'] = CONCERNPERSONPINCODE;
    _data['DISTRIBUTOR_PINCODE'] = DISTRIBUTORPINCODE;
    _data['SALES_PERSON_PINCODE'] = SALESPERSONPINCODE;
    _data['LINE_SUPERVISOR_PINCODE'] = LINESUPERVISORPINCODE;
    _data['BRANCH_PINCODE'] = BRANCHPINCODE;
    _data['OUTLET_PINCODE'] = OUTLETPINCODE;
    _data['ASSOCIATION_PINCODE'] = ASSOCIATIONPINCODE;
    _data['WAREHOUSE_PINCODE'] = WAREHOUSEPINCODE;
    _data['CONCERN_PERSON'] = CONCERNPERSON;
    _data['CONCERN_PERSON_NAME'] = CONCERNPERSONNAME;
    _data['ADDRESS'] = ADDRESS;
    _data['FARM_ADDRESS'] = FARMADDRESS;
    _data['CA_ADDRESS'] = CAADDRESS;
    _data['DEALER_ADDRESS'] = DEALERADDRESS;
    _data['CHICKEN_SHOP_ADDRESS'] = CHICKENSHOPADDRESS;
    _data['COMPANY_ADDRESS'] = COMPANYADDRESS;
    _data['FACTORY_ADDRESS'] = FACTORYADDRESS;
    _data['BRANCH_ADDRESS'] = BRANCHADDRESS;
    _data['LINE_SUPERVISOR_BRANCH_ADDRESS'] = LINESUPERVISORBRANCHADDRESS;
    _data['AGENT_ADDRESS'] = AGENTADDRESS;
    _data['OUTLET_ADDRESS'] = OUTLETADDRESS;
    _data['ASSOCIATION_ADDRESS'] = ASSOCIATIONADDRESS;
    _data['WAREHOUSE_ADDRESS'] = WAREHOUSEADDRESS;
    _data['ABOUT_PRODUCT'] = ABOUTPRODUCT;
    _data['ADDITIONAL_INFORMATION'] = ADDITIONALINFORMATION;
    _data['AGENT_NAME'] = AGENTNAME;
    _data['ANYTHING_TO_SPECIFY'] = ANYTHINGTOSPECIFY;
    _data['ANY_SPECIFIC_BREED'] = ANYSPECIFICBREED;
    _data['ANY_THING_MORE_TO_SAY'] = ANYTHINGMORETOSAY;
    _data['ANY_THING_TO_SAY'] = ANYTHINGTOSAY;
    _data['ANY_THING_TO_SPECIFY'] = ANYTHINGTOSPECIFY2;
    _data['ASSOCIATION_DESIGNATION'] = ASSOCIATIONDESIGNATION;
    _data['ASSOCIATION_MEMBER'] = ASSOCIATIONMEMBER;
    _data['ASSOCIATION_NAME'] = ASSOCIATIONNAME;
    _data['MANAGER_NAME'] = MANAGERNAME;
    _data['BRANCH_NAME'] = BRANCHNAME;
    _data['BREEDER_FARM_NAME'] = BREEDERFARMNAME;
    _data['BREED_NAME'] = BREEDNAME;
    _data['CAPACITY'] = CAPACITY;
    _data['CATEGORY'] = CATEGORY;
    _data['CA_CONCERN_PERSON'] = CACONCERNPERSON;
    _data['CHICKEN_STORING_CAPACITY'] = CHICKENSTORINGCAPACITY;
    _data['COMPANY_NAME'] = COMPANYNAME;
    _data['COMPANY_WEBSITE'] = COMPANYWEBSITE;
    _data['COMPOSITION'] = COMPOSITION;
    _data['CONTACT_NUMBER'] = CONTACTNUMBER;
    _data['CONTACT_PERSON'] = CONTACTPERSON;
    _data['CONTACT_PERSON_CONTACT_NUMBER'] = CONTACTPERSONCONTACTNUMBER;
    _data['DATE_OF_BIRTH'] = DATEOFBIRTH;
    _data['DISTRIBUTOR_NAME'] = DISTRIBUTORNAME;
    _data['DEALER_FIRM_NAME'] = DEALERFIRMNAME;
    _data['DEALER_NAME'] = DEALERNAME;
    _data['DEPO'] = DEPO;
    _data['DESCRIPTION'] = DESCRIPTION;
    _data['DIRECTOR_NAME'] = DIRECTORNAME;
    _data['MEMBER_NAME'] = MEMBERNAME;
    _data['DISTRIBUTOR_OF_COMPANY'] = DISTRIBUTOROFCOMPANY;
    _data['DISTRIBUTOR_PIN_CODE'] = DISTRIBUTORPINCODE2;
    _data['DOCTOR'] = DOCTOR;
    _data['CONSULTANT'] = CONSULTANT;
    _data['DOSE'] = DOSE;
    _data['EDITOR_NAME'] = EDITORNAME;
    _data['EGG_STORING_CAPACITY'] = EGGSTORINGCAPACITY;
    _data['EMAIL'] = EMAIL;
    _data['EXHIBITION_NAME'] = EXHIBITIONNAME;
    _data['EXPERTISE'] = EXPERTISE;
    _data['FACILITY'] = FACILITY;
    _data['FORMULATION'] = FORMULATION;
    _data['FULL_LOAD'] = FULLLOAD;
    _data['INSTITUTE_NAME'] = INSTITUTENAME;
    _data['INSTITUTION'] = INSTITUTION;
    _data['ENTREPRENEUR'] = ENTREPRENEUR;
    _data['LAB_NAME'] = LABNAME;
    _data['LINE_SUPERVISOR'] = LINESUPERVISOR;
    _data['LIST_OF_PROJECT'] = LISTOFPROJECT;
    _data['LIST_OF_SERVICE'] = LISTOFSERVICE;
    _data['MARKETING_PERSON'] = MARKETINGPERSON;
    _data['MEMBER_DESIGNATION'] = MEMBERDESIGNATION;
    _data['MOBILE_NUMBER'] = MOBILENUMBER;
    _data['MRP'] = MRP;
    _data['NAME'] = NAME;
    _data['OTHERS'] = OTHERS;
    _data['PACKING'] = PACKING;
    _data['PARTNER_NAME'] = PARTNERNAME;
    _data['PERSON_NAME'] = PERSONNAME;
    _data['PHONENUMBER'] = PHONENUMBER2;
    _data['POSITION'] = POSITION;
    _data['PRODUCT'] = PRODUCT;
    _data['PRODUCT_DETAILS'] = PRODUCTDETAILS;
    _data['PRODUCT_NAME'] = PRODUCTNAME;
    _data['PRODUCT_USAGE'] = PRODUCTUSAGE;
    _data['HOD_NAME'] = HODNAME;
    _data['PUBLICATION_HOUSE'] = PUBLICATIONHOUSE;
    _data['QUALIFICATION'] = QUALIFICATION;
    _data['RAW_MATERIAL_NAME'] = RAWMATERIALNAME;
    _data['REMARK'] = REMARK;
    _data['RETAIL_OUTLET_NAME'] = RETAILOUTLETNAME;
    _data['SALES_PERSON_NAME'] = SALESPERSONNAME;
    _data['SOFTWARE_NAME'] = SOFTWARENAME;
    _data['SPECIALISATION'] = SPECIALISATION;
    _data['MASTERS'] = MASTERS;
    _data['SPECIALISE_IN'] = SPECIALISEIN;
    _data['SPECIALITY'] = SPECIALITY;
    _data['SPECIES_NAME'] = SPECIESNAME;
    _data['SPECIFICATION'] = SPECIFICATION;
    _data['STATE'] = STATE;
    _data['SUBJECT'] = SUBJECT;
    _data['SUBSIDY_LIST'] = SUBSIDYLIST;
    _data['TECHNICIAN_EMAIL'] = TECHNICIANEMAIL;
    _data['TECHNICIAN_NAME'] = TECHNICIANNAME;
    _data['TRANSPORT_ID'] = TRANSPORTID;
    _data['USED_FOR'] = USEDFOR;
    _data['VALUE_ADDITION'] = VALUEADDITION;
    _data['VALUE_ADDITION_REMARK'] = VALUEADDITIONREMARK;
    _data['WAREHOUSE'] = WAREHOUSE;
    _data['WEBSITE'] = WEBSITE;
    _data['WHICH_TYPE_OF_LABOUR'] = WHICHTYPEOFLABOUR;
    _data['YPE_OF_CERTIFICATION'] = YPEOFCERTIFICATION;
    _data['rdate'] = rdate;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    return _data;
  }
}


// class GetVendorListCategory {
//   GetVendorListCategory({
//     required this.id,
//     required this.CATEGORYAUTOID,
//     required this.ADMINAUTOID,
//     required this.APPTYPEID,
//     required this.USERAUTOID,
//     required this.MINORDERVALUE,
//     required this.PRICERANGE,
//     required this.VENDORPROFILE,
//     required this.SUPPLIERPROFILE,
//     required this.FIRMNAME,
//     required this.OWNERNAME,
//     required this.EMAILID,
//     required this.MARKETINGPERSONEMAILID,
//     required this.SALESPERSONEMAILID,
//     required this.CONCERNPERSONEMAILID,
//     required this.DEALEREMAILID,
//     required this.DISTRIBUTOREMAILID,
//     required this.EDITOREMAILID,
//     required this.ASSOCIATIONEMAILID,
//     required this.MEMBEREMAILID,
//     required this.LINESUPERVISOREMAILID,
//     required this.CONSULTANTEMAILID,
//     required this.AGENTEMAILID,
//     required this.COMPANYEMAILID,
//     required this.CAEMAILID,
//     required this.PHONENUMBER,
//     required this.MARKETINGPERSONPHONENUMBER,
//     required this.SALESPERSONPHONENUMBER,
//     required this.CONCERNPERSONPHONENUMBER,
//     required this.DEALERPHONENUMBER,
//     required this.DISTRIBUTORPHONENUMBER,
//     required this.EDITORPHONENUMBER,
//     required this.ASSOCIATIONPHONENUMBER,
//     required this.MEMBERPHONENUMBER,
//     required this.LINESUPERVISORPHONENUMBER,
//     required this.CONSULTANTPHONENUMBER,
//     required this.AGENTPHONENUMBER,
//     required this.COMPANYPHONENUMBER,
//     required this.CAPHONENUMBER,
//     required this.TECHNICIANPHONENUMBER,
//     required this.CONTACTPERSONPHONENUMBER,
//     required this.HODPHONENUMBER,
//     required this.OUTLETPHONENUMBER,
//     required this.OFFICEADDRESS,
//     required this.AREA,
//     required this.CONSULTANTAREA,
//     required this.CHICKENSHOPAREA,
//     required this.AREAOFWORKING,
//     required this.AREASPECIFIC,
//     required this.SALESPERSONAREA,
//     required this.BRANCHAREA,
//     required this.AREAOFSUPPLY,
//     required this.WAREHOUSEAREA,
//     required this.AREAOFDELIVERY,
//     required this.WORKINGAREA,
//     required this.SUPPLYAREA,
//     required this.OUTLETAREA,
//     required this.PINCODE,
//     required this.CONSULTANTPINCODE,
//     required this.DEALERPINCODE,
//     required this.CAPINCODE,
//     required this.CHICKENSHOPPINCODE,
//     required this.COMPANYPINCODE,
//     required this.CONCERNPERSONPINCODE,
//     required this.DISTRIBUTORPINCODE,
//     required this.SALESPERSONPINCODE,
//     required this.LINESUPERVISORPINCODE,
//     required this.BRANCHPINCODE,
//     required this.OUTLETPINCODE,
//     required this.ASSOCIATIONPINCODE,
//     required this.WAREHOUSEPINCODE,
//     required this.CONCERNPERSON,
//     required this.CONCERNPERSONNAME,
//     required this.ADDRESS,
//     required this.FARMADDRESS,
//     required this.CAADDRESS,
//     required this.DEALERADDRESS,
//     required this.CHICKENSHOPADDRESS,
//     required this.COMPANYADDRESS,
//     required this.FACTORYADDRESS,
//     required this.BRANCHADDRESS,
//     required this.LINESUPERVISORBRANCHADDRESS,
//     required this.AGENTADDRESS,
//     required this.OUTLETADDRESS,
//     required this.ASSOCIATIONADDRESS,
//     required this.WAREHOUSEADDRESS,
//     required this.ABOUTPRODUCT,
//     required this.ADDITIONALINFORMATION,
//     required this.AGENTNAME,
//     required this.ANYTHINGTOSPECIFY,
//     required this.ANYSPECIFICBREED,
//     required this.ANYTHINGMORETOSAY,
//     required this.ANYTHINGTOSAY,
//     required this.ANYTHINGTOSPECIFY2,
//     required this.ASSOCIATIONDESIGNATION,
//     required this.ASSOCIATIONMEMBER,
//     required this.ASSOCIATIONNAME,
//     required this.MANAGERNAME,
//     required this.BRANCHNAME,
//     required this.BREEDERFARMNAME,
//     required this.BREEDNAME,
//     required this.CAPACITY,
//     required this.CATEGORY,
//     required this.CACONCERNPERSON,
//     required this.CHICKENSTORINGCAPACITY,
//     required this.COMPANYNAME,
//     required this.COMPANYWEBSITE,
//     required this.COMPOSITION,
//     required this.CONTACTNUMBER,
//     required this.CONTACTPERSON,
//     required this.CONTACTPERSONCONTACTNUMBER,
//     required this.DATEOFBIRTH,
//     required this.DISTRIBUTORNAME,
//     required this.DEALERFIRMNAME,
//     required this.DEALERNAME,
//     required this.DEPO,
//     required this.DESCRIPTION,
//     required this.DIRECTORNAME,
//     required this.MEMBERNAME,
//     required this.DISTRIBUTOROFCOMPANY,
//     required this.DISTRIBUTORPINCODE2,
//     required this.DOCTOR,
//     required this.CONSULTANT,
//     required this.DOSE,
//     required this.EDITORNAME,
//     required this.EGGSTORINGCAPACITY,
//     required this.EMAIL,
//     required this.EXHIBITIONNAME,
//     required this.EXPERTISE,
//     required this.FACILITY,
//     required this.FORMULATION,
//     required this.FULLLOAD,
//     required this.INSTITUTENAME,
//     required this.INSTITUTION,
//     required this.ENTREPRENEUR,
//     required this.LABNAME,
//     required this.LINESUPERVISOR,
//     required this.LISTOFPROJECT,
//     required this.LISTOFSERVICE,
//     required this.MARKETINGPERSON,
//     required this.MEMBERDESIGNATION,
//     required this.MOBILENUMBER,
//     required this.MRP,
//     required this.NAME,
//     required this.OTHERS,
//     required this.PACKING,
//     required this.PARTNERNAME,
//     required this.PERSONNAME,
//     required this.PHONENUMBER2,
//     required this.POSITION,
//     required this.PRODUCT,
//     required this.PRODUCTDETAILS,
//     required this.PRODUCTNAME,
//     required this.PRODUCTUSAGE,
//     required this.HODNAME,
//     required this.PUBLICATIONHOUSE,
//     required this.QUALIFICATION,
//     required this.RAWMATERIALNAME,
//     required this.REMARK,
//     required this.RETAILOUTLETNAME,
//     required this.SALESPERSONNAME,
//     required this.SOFTWARENAME,
//     required this.SPECIALISATION,
//     required this.MASTERS,
//     required this.SPECIALISEIN,
//     required this.SPECIALITY,
//     required this.SPECIESNAME,
//     required this.SPECIFICATION,
//     required this.STATE,
//     required this.SUBJECT,
//     required this.SUBSIDYLIST,
//     required this.TECHNICIANEMAIL,
//     required this.TECHNICIANNAME,
//     required this.TRANSPORTID,
//     required this.USEDFOR,
//     required this.VALUEADDITION,
//     required this.VALUEADDITIONREMARK,
//     required this.WAREHOUSE,
//     required this.WEBSITE,
//     required this.WHICHTYPEOFLABOUR,
//     required this.YPEOFCERTIFICATION,
//     required this.rdate,
//     required this.updatedAt,
//     required this.createdAt,
//   });
//   late final String id;
//   late final String CATEGORYAUTOID;
//   late final String ADMINAUTOID;
//   late final String APPTYPEID;
//   late final String USERAUTOID;
//   late final String MINORDERVALUE;
//   late final String PRICERANGE;
//   late final String VENDORPROFILE;
//   late final String SUPPLIERPROFILE;
//   late final String FIRMNAME;
//   late final String OWNERNAME;
//   late final String EMAILID;
//   late final String MARKETINGPERSONEMAILID;
//   late final String SALESPERSONEMAILID;
//   late final String CONCERNPERSONEMAILID;
//   late final String DEALEREMAILID;
//   late final String DISTRIBUTOREMAILID;
//   late final String EDITOREMAILID;
//   late final String ASSOCIATIONEMAILID;
//   late final String MEMBEREMAILID;
//   late final String LINESUPERVISOREMAILID;
//   late final String CONSULTANTEMAILID;
//   late final String AGENTEMAILID;
//   late final String COMPANYEMAILID;
//   late final String CAEMAILID;
//   late final String PHONE_NUMBER;
//   late final String MARKETINGPERSONPHONENUMBER;
//   late final String SALESPERSONPHONENUMBER;
//   late final String CONCERNPERSONPHONENUMBER;
//   late final String DEALERPHONENUMBER;
//   late final String DISTRIBUTORPHONENUMBER;
//   late final String EDITORPHONENUMBER;
//   late final String ASSOCIATIONPHONENUMBER;
//   late final String MEMBERPHONENUMBER;
//   late final String LINESUPERVISORPHONENUMBER;
//   late final String CONSULTANTPHONENUMBER;
//   late final String AGENTPHONENUMBER;
//   late final String COMPANYPHONENUMBER;
//   late final String CAPHONENUMBER;
//   late final String TECHNICIANPHONENUMBER;
//   late final String CONTACTPERSONPHONENUMBER;
//   late final String HODPHONENUMBER;
//   late final String OUTLETPHONENUMBER;
//   late final String OFFICEADDRESS;
//   late final String AREA;
//   late final String CONSULTANTAREA;
//   late final String CHICKENSHOPAREA;
//   late final String AREAOFWORKING;
//   late final String AREASPECIFIC;
//   late final String SALESPERSONAREA;
//   late final String BRANCHAREA;
//   late final String AREAOFSUPPLY;
//   late final String WAREHOUSEAREA;
//   late final String AREAOFDELIVERY;
//   late final String WORKINGAREA;
//   late final String SUPPLYAREA;
//   late final String OUTLETAREA;
//   late final String PINCODE;
//   late final String CONSULTANTPINCODE;
//   late final String DEALERPINCODE;
//   late final String CAPINCODE;
//   late final String CHICKENSHOPPINCODE;
//   late final String COMPANY_PINCODE;
//   late final String CONCERN_PERSON_PINCODE;
//   late final String DISTRIBUTORPINCODE;
//   late final String CONCERNPERSONPINCODE;
//   late final String DISTRIBUTOR_PINCODE;
//   late final String SALESPERSONPINCODE;
//   late final String LINESUPERVISORPINCODE;
//   late final String BRANCHPINCODE;
//   late final String OUTLETPINCODE;
//   late final String ASSOCIATIONPINCODE;
//   late final String WAREHOUSEPINCODE;
//   late final String CONCERNPERSON;
//   late final String CONCERNPERSONNAME;
//   late final String ADDRESS;
//   late final String FARMADDRESS;
//   late final String CAADDRESS;
//   late final String DEALERADDRESS;
//   late final String CHICKENSHOPADDRESS;
//   late final String COMPANYADDRESS;
//   late final String FACTORYADDRESS;
//   late final String BRANCHADDRESS;
//   late final String LINESUPERVISORBRANCHADDRESS;
//   late final String AGENTADDRESS;
//   late final String OUTLETADDRESS;
//   late final String ASSOCIATIONADDRESS;
//   late final String WAREHOUSEADDRESS;
//   late final String ABOUTPRODUCT;
//   late final String ADDITIONALINFORMATION;
//   late final String AGENTNAME;
//   late final String ANYTHINGTOSPECIFY;
//   late final String ANYSPECIFICBREED;
//   late final String ANYTHINGMORETOSAY;
//   late final String ANYTHINGTOSAY;
//   late final String ANYTHING_TO_SPECIFY;
//   late final String ASSOCIATIONDESIGNATION;
//   late final String ASSOCIATIONMEMBER;
//   late final String ASSOCIATIONNAME;
//   late final String MANAGERNAME;
//   late final String BRANCHNAME;
//   late final String BREEDERFARMNAME;
//   late final String BREEDNAME;
//   late final String CAPACITY;
//   late final String CATEGORY;
//   late final String CACONCERNPERSON;
//   late final String CHICKENSTORINGCAPACITY;
//   late final String COMPANYNAME;
//   late final String COMPANYWEBSITE;
//   late final String COMPOSITION;
//   late final String CONTACTNUMBER;
//   late final String CONTACTPERSON;
//   late final String CONTACTPERSONCONTACTNUMBER;
//   late final String DATEOFBIRTH;
//   late final String DISTRIBUTORNAME;
//   late final String DEALERFIRMNAME;
//   late final String DEALERNAME;
//   late final String DEPO;
//   late final String DESCRIPTION;
//   late final String DIRECTORNAME;
//   late final String MEMBERNAME;
//   late final String DISTRIBUTOROFCOMPANY;
//   late final String DISTRIBUTOR_PINCODE;
//   late final String DOCTOR;
//   late final String CONSULTANT;
//   late final String DOSE;
//   late final String EDITORNAME;
//   late final String EGGSTORINGCAPACITY;
//   late final String EMAIL;
//   late final String EXHIBITIONNAME;
//   late final String EXPERTISE;
//   late final String FACILITY;
//   late final String FORMULATION;
//   late final String FULLLOAD;
//   late final String INSTITUTENAME;
//   late final String INSTITUTION;
//   late final String ENTREPRENEUR;
//   late final String LABNAME;
//   late final String LINESUPERVISOR;
//   late final String LISTOFPROJECT;
//   late final String LISTOFSERVICE;
//   late final String MARKETINGPERSON;
//   late final String MEMBERDESIGNATION;
//   late final String MOBILENUMBER;
//   late final String MRP;
//   late final String NAME;
//   late final String OTHERS;
//   late final String PACKING;
//   late final String PARTNERNAME;
//   late final String PERSONNAME;
//   late final String PHONENUMBER;
//   late final String POSITION;
//   late final String PRODUCT;
//   late final String PRODUCTDETAILS;
//   late final String PRODUCTNAME;
//   late final String PRODUCTUSAGE;
//   late final String HODNAME;
//   late final String PUBLICATIONHOUSE;
//   late final String QUALIFICATION;
//   late final String RAWMATERIALNAME;
//   late final String REMARK;
//   late final String RETAILOUTLETNAME;
//   late final String SALESPERSONNAME;
//   late final String SOFTWARENAME;
//   late final String SPECIALISATION;
//   late final String MASTERS;
//   late final String SPECIALISEIN;
//   late final String SPECIALITY;
//   late final String SPECIESNAME;
//   late final String SPECIFICATION;
//   late final String STATE;
//   late final String SUBJECT;
//   late final String SUBSIDYLIST;
//   late final String TECHNICIANEMAIL;
//   late final String TECHNICIANNAME;
//   late final String TRANSPORTID;
//   late final String USEDFOR;
//   late final String VALUEADDITION;
//   late final String VALUEADDITIONREMARK;
//   late final String WAREHOUSE;
//   late final String WEBSITE;
//   late final String WHICHTYPEOFLABOUR;
//   late final String YPEOFCERTIFICATION;
//   late final String rdate;
//   late final String updatedAt;
//   late final String createdAt;
//
//   GetVendorListCategory.fromJson(Map<String, dynamic> json){
//     id = json['_id'];
//     CATEGORYAUTOID = json['CATEGORY_AUTO_ID'];
//     ADMINAUTOID = json['ADMIN_AUTO_ID'];
//     APPTYPEID = json['APP_TYPE_ID'];
//     USERAUTOID = json['USER_AUTO_ID'];
//     MINORDERVALUE = json['MIN_ORDER_VALUE'];
//     PRICERANGE = json['PRICE_RANGE'];
//     VENDORPROFILE = json['VENDOR_PROFILE'];
//     SUPPLIERPROFILE = json['SUPPLIER_PROFILE'];
//     FIRMNAME = json['FIRM_NAME'];
//     OWNERNAME = json['OWNER_NAME'];
//     EMAILID = json['EMAIL_ID'];
//     MARKETINGPERSONEMAILID = json['MARKETING_PERSON_EMAIL_ID'];
//     SALESPERSONEMAILID = json['SALES_PERSON_EMAIL_ID'];
//     CONCERNPERSONEMAILID = json['CONCERN_PERSON_EMAIL_ID'];
//     DEALEREMAILID = json['DEALER_EMAIL_ID'];
//     DISTRIBUTOREMAILID = json['DISTRIBUTOR_EMAIL_ID'];
//     EDITOREMAILID = json['EDITOR_EMAIL_ID'];
//     ASSOCIATIONEMAILID = json['ASSOCIATION_EMAIL_ID'];
//     MEMBEREMAILID = json['MEMBER_EMAIL_ID'];
//     LINESUPERVISOREMAILID = json['LINE_SUPERVISOR_EMAIL_ID'];
//     CONSULTANTEMAILID = json['CONSULTANT_EMAIL_ID'];
//     AGENTEMAILID = json['AGENT_EMAIL_ID'];
//     COMPANYEMAILID = json['COMPANY_EMAIL_ID'];
//     CAEMAILID = json['CA_EMAIL_ID'];
//     PHONE_NUMBER = json['PHONE_NUMBER'];
//     MARKETINGPERSONPHONENUMBER = json['MARKETING_PERSON_PHONE_NUMBER'];
//     SALESPERSONPHONENUMBER = json['SALES_PERSON_PHONE_NUMBER'];
//     CONCERNPERSONPHONENUMBER = json['CONCERN_PERSON_PHONE_NUMBER'];
//     DEALERPHONENUMBER = json['DEALER_PHONE_NUMBER'];
//     DISTRIBUTORPHONENUMBER = json['DISTRIBUTOR_PHONE_NUMBER'];
//     EDITORPHONENUMBER = json['EDITOR_PHONE_NUMBER'];
//     ASSOCIATIONPHONENUMBER = json['ASSOCIATION_PHONE_NUMBER'];
//     MEMBERPHONENUMBER = json['MEMBER_PHONE_NUMBER'];
//     LINESUPERVISORPHONENUMBER = json['LINE_SUPERVISOR_PHONE_NUMBER'];
//     CONSULTANTPHONENUMBER = json['CONSULTANT_PHONE_NUMBER'];
//     AGENTPHONENUMBER = json['AGENT_PHONE_NUMBER'];
//     COMPANYPHONENUMBER = json['COMPANY_PHONE_NUMBER'];
//     CAPHONENUMBER = json['CA_PHONE_NUMBER'];
//     TECHNICIANPHONENUMBER = json['TECHNICIAN_PHONE_NUMBER'];
//     CONTACTPERSONPHONENUMBER = json['CONTACTPERSON_PHONE_NUMBER'];
//     HODPHONENUMBER = json['HOD_PHONE_NUMBER'];
//     OUTLETPHONENUMBER = json['OUTLET_PHONE_NUMBER'];
//     OFFICEADDRESS = json['OFFICE_ADDRESS'];
//     AREA = json['AREA'];
//     CONSULTANTAREA = json['CONSULTANT_AREA'];
//     CHICKENSHOPAREA = json['CHICKEN_SHOP_AREA'];
//     AREAOFWORKING = json['AREA_OF_WORKING'];
//     AREASPECIFIC = json['AREA_SPECIFIC'];
//     SALESPERSONAREA = json['SALES_PERSON_AREA'];
//     BRANCHAREA = json['BRANCH_AREA'];
//     AREAOFSUPPLY = json['AREA_OF_SUPPLY'];
//     WAREHOUSEAREA = json['WAREHOUSE_AREA'];
//     AREAOFDELIVERY = json['AREA_OF_DELIVERY'];
//     WORKINGAREA = json['WORKING_AREA'];
//     SUPPLYAREA = json['SUPPLY_AREA'];
//     OUTLETAREA = json['OUTLET_AREA'];
//     PINCODE = json['PINCODE'];
//     CONSULTANTPINCODE = json['CONSULTANT_PINCODE'];
//     DEALERPINCODE = json['DEALER_PINCODE'];
//     CAPINCODE = json['CA_PINCODE'];
//     CHICKENSHOPPINCODE = json['CHICKEN_SHOP_PINCODE'];
//     COMPANY_PINCODE = json['COMPANY_PINCODE'];
//     CONCERN_PERSON_PINCODE = json['CONCERN_PERSON_PINCODE'];
//     DISTRIBUTORPINCODE = json['DISTRIBUTOR_PINCODE'];
//     SALESPERSONPINCODE = json['SALES_PERSON_PINCODE'];
//     LINESUPERVISORPINCODE = json['LINE_SUPERVISOR_PINCODE'];
//     BRANCHPINCODE = json['BRANCH_PINCODE'];
//     OUTLETPINCODE = json['OUTLET_PINCODE'];
//     ASSOCIATIONPINCODE = json['ASSOCIATION_PINCODE'];
//     WAREHOUSEPINCODE = json['WAREHOUSE_PINCODE'];
//     CONCERNPERSON = json['CONCERN_PERSON'];
//     CONCERNPERSONNAME = json['CONCERN_PERSON_NAME'];
//     ADDRESS = json['ADDRESS'];
//     FARMADDRESS = json['FARM_ADDRESS'];
//     CAADDRESS = json['CA_ADDRESS'];
//     DEALERADDRESS = json['DEALER_ADDRESS'];
//     CHICKENSHOPADDRESS = json['CHICKEN_SHOP_ADDRESS'];
//     COMPANYADDRESS = json['COMPANY_ADDRESS'];
//     FACTORYADDRESS = json['FACTORY_ADDRESS'];
//     BRANCHADDRESS = json['BRANCH_ADDRESS'];
//     LINESUPERVISORBRANCHADDRESS = json['LINE_SUPERVISOR_BRANCH_ADDRESS'];
//     AGENTADDRESS = json['AGENT_ADDRESS'];
//     OUTLETADDRESS = json['OUTLET_ADDRESS'];
//     ASSOCIATIONADDRESS = json['ASSOCIATION_ADDRESS'];
//     WAREHOUSEADDRESS = json['WAREHOUSE_ADDRESS'];
//     ABOUTPRODUCT = json['ABOUT_PRODUCT'];
//     ADDITIONALINFORMATION = json['ADDITIONAL_INFORMATION'];
//     AGENTNAME = json['AGENT_NAME'];
//     ANYTHINGTOSPECIFY = json['ANYTHING_TO_SPECIFY'];
//     ANYSPECIFICBREED = json['ANY_SPECIFIC_BREED'];
//     ANYTHINGMORETOSAY = json['ANY_THING_MORE_TO_SAY'];
//     ANYTHINGTOSAY = json['ANY_THING_TO_SAY'];
//     ANYTHING_TO_SPECIFY = json['ANY_THING_TO_SPECIFY'];
//     ASSOCIATIONDESIGNATION = json['ASSOCIATION_DESIGNATION'];
//     ASSOCIATIONMEMBER = json['ASSOCIATION_MEMBER'];
//     ASSOCIATIONNAME = json['ASSOCIATION_NAME'];
//     MANAGERNAME = json['MANAGER_NAME'];
//     BRANCHNAME = json['BRANCH_NAME'];
//     BREEDERFARMNAME = json['BREEDER_FARM_NAME'];
//     BREEDNAME = json['BREED_NAME'];
//     CAPACITY = json['CAPACITY'];
//     CATEGORY = json['CATEGORY'];
//     CACONCERNPERSON = json['CA_CONCERN_PERSON'];
//     CHICKENSTORINGCAPACITY = json['CHICKEN_STORING_CAPACITY'];
//     COMPANYNAME = json['COMPANY_NAME'];
//     COMPANYWEBSITE = json['COMPANY_WEBSITE'];
//     COMPOSITION = json['COMPOSITION'];
//     CONTACTNUMBER = json['CONTACT_NUMBER'];
//     CONTACTPERSON = json['CONTACT_PERSON'];
//     CONTACTPERSONCONTACTNUMBER = json['CONTACT_PERSON_CONTACT_NUMBER'];
//     DATEOFBIRTH = json['DATE_OF_BIRTH'];
//     DISTRIBUTORNAME = json['DISTRIBUTOR_NAME'];
//     DEALERFIRMNAME = json['DEALER_FIRM_NAME'];
//     DEALERNAME = json['DEALER_NAME'];
//     DEPO = json['DEPO'];
//     DESCRIPTION = json['DESCRIPTION'];
//     DIRECTORNAME = json['DIRECTOR_NAME'];
//     MEMBERNAME = json['MEMBER_NAME'];
//     DISTRIBUTOROFCOMPANY = json['DISTRIBUTOR_OF_COMPANY'];
//     DISTRIBUTOR_PINCODE = json['DISTRIBUTOR_PIN_CODE'];
//     DOCTOR = json['DOCTOR'];
//     CONSULTANT = json['CONSULTANT'];
//     DOSE = json['DOSE'];
//     EDITORNAME = json['EDITOR_NAME'];
//     EGGSTORINGCAPACITY = json['EGG_STORING_CAPACITY'];
//     EMAIL = json['EMAIL'];
//     EXHIBITIONNAME = json['EXHIBITION_NAME'];
//     EXPERTISE = json['EXPERTISE'];
//     FACILITY = json['FACILITY'];
//     FORMULATION = json['FORMULATION'];
//     FULLLOAD = json['FULL_LOAD'];
//     INSTITUTENAME = json['INSTITUTE_NAME'];
//     INSTITUTION = json['INSTITUTION'];
//     ENTREPRENEUR = json['ENTREPRENEUR'];
//     LABNAME = json['LAB_NAME'];
//     LINESUPERVISOR = json['LINE_SUPERVISOR'];
//     LISTOFPROJECT = json['LIST_OF_PROJECT'];
//     LISTOFSERVICE = json['LIST_OF_SERVICE'];
//     MARKETINGPERSON = json['MARKETING_PERSON'];
//     MEMBERDESIGNATION = json['MEMBER_DESIGNATION'];
//     MOBILENUMBER = json['MOBILE_NUMBER'];
//     MRP = json['MRP'];
//     NAME = json['NAME'];
//     OTHERS = json['OTHERS'];
//     PACKING = json['PACKING'];
//     PARTNERNAME = json['PARTNER_NAME'];
//     PERSONNAME = json['PERSON_NAME'];
//     PHONENUMBER = json['PHONENUMBER'];
//     POSITION = json['POSITION'];
//     PRODUCT = json['PRODUCT'];
//     PRODUCTDETAILS = json['PRODUCT_DETAILS'];
//     PRODUCTNAME = json['PRODUCT_NAME'];
//     PRODUCTUSAGE = json['PRODUCT_USAGE'];
//     HODNAME = json['HOD_NAME'];
//     PUBLICATIONHOUSE = json['PUBLICATION_HOUSE'];
//     QUALIFICATION = json['QUALIFICATION'];
//     RAWMATERIALNAME = json['RAW_MATERIAL_NAME'];
//     REMARK = json['REMARK'];
//     RETAILOUTLETNAME = json['RETAIL_OUTLET_NAME'];
//     SALESPERSONNAME = json['SALES_PERSON_NAME'];
//     SOFTWARENAME = json['SOFTWARE_NAME'];
//     SPECIALISATION = json['SPECIALISATION'];
//     MASTERS = json['MASTERS'];
//     SPECIALISEIN = json['SPECIALISE_IN'];
//     SPECIALITY = json['SPECIALITY'];
//     SPECIESNAME = json['SPECIES_NAME'];
//     SPECIFICATION = json['SPECIFICATION'];
//     STATE = json['STATE'];
//     SUBJECT = json['SUBJECT'];
//     SUBSIDYLIST = json['SUBSIDY_LIST'];
//     TECHNICIANEMAIL = json['TECHNICIAN_EMAIL'];
//     TECHNICIANNAME = json['TECHNICIAN_NAME'];
//     TRANSPORTID = json['TRANSPORT_ID'];
//     USEDFOR = json['USED_FOR'];
//     VALUEADDITION = json['VALUE_ADDITION'];
//     VALUEADDITIONREMARK = json['VALUE_ADDITION_REMARK'];
//     WAREHOUSE = json['WAREHOUSE'];
//     WEBSITE = json['WEBSITE'];
//     WHICHTYPEOFLABOUR = json['WHICH_TYPE_OF_LABOUR'];
//     YPEOFCERTIFICATION = json['YPE_OF_CERTIFICATION'];
//     rdate = json['rdate'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['_id'] = id;
//     _data['CATEGORY_AUTO_ID'] = CATEGORYAUTOID;
//     _data['ADMIN_AUTO_ID'] = ADMINAUTOID;
//     _data['APP_TYPE_ID'] = APPTYPEID;
//     _data['USER_AUTO_ID'] = USERAUTOID;
//     _data['MIN_ORDER_VALUE'] = MINORDERVALUE;
//     _data['PRICE_RANGE'] = PRICERANGE;
//     _data['VENDOR_PROFILE'] = VENDORPROFILE;
//     _data['SUPPLIER_PROFILE'] = SUPPLIERPROFILE;
//     _data['FIRM_NAME'] = FIRMNAME;
//     _data['OWNER_NAME'] = OWNERNAME;
//     _data['EMAIL_ID'] = EMAILID;
//     _data['MARKETING_PERSON_EMAIL_ID'] = MARKETINGPERSONEMAILID;
//     _data['SALES_PERSON_EMAIL_ID'] = SALESPERSONEMAILID;
//     _data['CONCERN_PERSON_EMAIL_ID'] = CONCERNPERSONEMAILID;
//     _data['DEALER_EMAIL_ID'] = DEALEREMAILID;
//     _data['DISTRIBUTOR_EMAIL_ID'] = DISTRIBUTOREMAILID;
//     _data['EDITOR_EMAIL_ID'] = EDITOREMAILID;
//     _data['ASSOCIATION_EMAIL_ID'] = ASSOCIATIONEMAILID;
//     _data['MEMBER_EMAIL_ID'] = MEMBEREMAILID;
//     _data['LINE_SUPERVISOR_EMAIL_ID'] = LINESUPERVISOREMAILID;
//     _data['CONSULTANT_EMAIL_ID'] = CONSULTANTEMAILID;
//     _data['AGENT_EMAIL_ID'] = AGENTEMAILID;
//     _data['COMPANY_EMAIL_ID'] = COMPANYEMAILID;
//     _data['CA_EMAIL_ID'] = CAEMAILID;
//     _data['PHONE_NUMBER'] = PHONE_NUMBER;
//     _data['MARKETING_PERSON_PHONE_NUMBER'] = MARKETINGPERSONPHONENUMBER;
//     _data['SALES_PERSON_PHONE_NUMBER'] = SALESPERSONPHONENUMBER;
//     _data['CONCERN_PERSON_PHONE_NUMBER'] = CONCERNPERSONPHONENUMBER;
//     _data['DEALER_PHONE_NUMBER'] = DEALERPHONENUMBER;
//     _data['DISTRIBUTOR_PHONE_NUMBER'] = DISTRIBUTORPHONENUMBER;
//     _data['EDITOR_PHONE_NUMBER'] = EDITORPHONENUMBER;
//     _data['ASSOCIATION_PHONE_NUMBER'] = ASSOCIATIONPHONENUMBER;
//     _data['MEMBER_PHONE_NUMBER'] = MEMBERPHONENUMBER;
//     _data['LINE_SUPERVISOR_PHONE_NUMBER'] = LINESUPERVISORPHONENUMBER;
//     _data['CONSULTANT_PHONE_NUMBER'] = CONSULTANTPHONENUMBER;
//     _data['AGENT_PHONE_NUMBER'] = AGENTPHONENUMBER;
//     _data['COMPANY_PHONE_NUMBER'] = COMPANYPHONENUMBER;
//     _data['CA_PHONE_NUMBER'] = CAPHONENUMBER;
//     _data['TECHNICIAN_PHONE_NUMBER'] = TECHNICIANPHONENUMBER;
//     _data['CONTACTPERSON_PHONE_NUMBER'] = CONTACTPERSONPHONENUMBER;
//     _data['HOD_PHONE_NUMBER'] = HODPHONENUMBER;
//     _data['OUTLET_PHONE_NUMBER'] = OUTLETPHONENUMBER;
//     _data['OFFICE_ADDRESS'] = OFFICEADDRESS;
//     _data['AREA'] = AREA;
//     _data['CONSULTANT_AREA'] = CONSULTANTAREA;
//     _data['CHICKEN_SHOP_AREA'] = CHICKENSHOPAREA;
//     _data['AREA_OF_WORKING'] = AREAOFWORKING;
//     _data['AREA_SPECIFIC'] = AREASPECIFIC;
//     _data['SALES_PERSON_AREA'] = SALESPERSONAREA;
//     _data['BRANCH_AREA'] = BRANCHAREA;
//     _data['AREA_OF_SUPPLY'] = AREAOFSUPPLY;
//     _data['WAREHOUSE_AREA'] = WAREHOUSEAREA;
//     _data['AREA_OF_DELIVERY'] = AREAOFDELIVERY;
//     _data['WORKING_AREA'] = WORKINGAREA;
//     _data['SUPPLY_AREA'] = SUPPLYAREA;
//     _data['OUTLET_AREA'] = OUTLETAREA;
//     _data['PINCODE'] = PINCODE;
//     _data['CONSULTANT_PINCODE'] = CONSULTANTPINCODE;
//     _data['DEALER_PINCODE'] = DEALERPINCODE;
//     _data['CA_PINCODE'] = CAPINCODE;
//     _data['CHICKEN_SHOP_PINCODE'] = CHICKENSHOPPINCODE;
//     _data['COMPANY_PINCODE'] = COMPANY_PINCODE;
//     _data['CONCERN_PERSON_PINCODE'] = CONCERN_PERSON_PINCODE;
//     _data['DISTRIBUTOR_PINCODE'] = DISTRIBUTORPINCODE;
//     _data['SALES_PERSON_PINCODE'] = SALESPERSONPINCODE;
//     _data['LINE_SUPERVISOR_PINCODE'] = LINESUPERVISORPINCODE;
//     _data['BRANCH_PINCODE'] = BRANCHPINCODE;
//     _data['OUTLET_PINCODE'] = OUTLETPINCODE;
//     _data['ASSOCIATION_PINCODE'] = ASSOCIATIONPINCODE;
//     _data['WAREHOUSE_PINCODE'] = WAREHOUSEPINCODE;
//     _data['CONCERN_PERSON'] = CONCERNPERSON;
//     _data['CONCERN_PERSON_NAME'] = CONCERNPERSONNAME;
//     _data['ADDRESS'] = ADDRESS;
//     _data['FARM_ADDRESS'] = FARMADDRESS;
//     _data['CA_ADDRESS'] = CAADDRESS;
//     _data['DEALER_ADDRESS'] = DEALERADDRESS;
//     _data['CHICKEN_SHOP_ADDRESS'] = CHICKENSHOPADDRESS;
//     _data['COMPANY_ADDRESS'] = COMPANYADDRESS;
//     _data['FACTORY_ADDRESS'] = FACTORYADDRESS;
//     _data['BRANCH_ADDRESS'] = BRANCHADDRESS;
//     _data['LINE_SUPERVISOR_BRANCH_ADDRESS'] = LINESUPERVISORBRANCHADDRESS;
//     _data['AGENT_ADDRESS'] = AGENTADDRESS;
//     _data['OUTLET_ADDRESS'] = OUTLETADDRESS;
//     _data['ASSOCIATION_ADDRESS'] = ASSOCIATIONADDRESS;
//     _data['WAREHOUSE_ADDRESS'] = WAREHOUSEADDRESS;
//     _data['ABOUT_PRODUCT'] = ABOUTPRODUCT;
//     _data['ADDITIONAL_INFORMATION'] = ADDITIONALINFORMATION;
//     _data['AGENT_NAME'] = AGENTNAME;
//     _data['ANYTHING_TO_SPECIFY'] = ANYTHINGTOSPECIFY;
//     _data['ANY_SPECIFIC_BREED'] = ANYSPECIFICBREED;
//     _data['ANY_THING_MORE_TO_SAY'] = ANYTHINGMORETOSAY;
//     _data['ANY_THING_TO_SAY'] = ANYTHINGTOSAY;
//     _data['ANY_THING_TO_SPECIFY'] = ANYTHING_TO_SPECIFY;
//     _data['ASSOCIATION_DESIGNATION'] = ASSOCIATIONDESIGNATION;
//     _data['ASSOCIATION_MEMBER'] = ASSOCIATIONMEMBER;
//     _data['ASSOCIATION_NAME'] = ASSOCIATIONNAME;
//     _data['MANAGER_NAME'] = MANAGERNAME;
//     _data['BRANCH_NAME'] = BRANCHNAME;
//     _data['BREEDER_FARM_NAME'] = BREEDERFARMNAME;
//     _data['BREED_NAME'] = BREEDNAME;
//     _data['CAPACITY'] = CAPACITY;
//     _data['CATEGORY'] = CATEGORY;
//     _data['CA_CONCERN_PERSON'] = CACONCERNPERSON;
//     _data['CHICKEN_STORING_CAPACITY'] = CHICKENSTORINGCAPACITY;
//     _data['COMPANY_NAME'] = COMPANYNAME;
//     _data['COMPANY_WEBSITE'] = COMPANYWEBSITE;
//     _data['COMPOSITION'] = COMPOSITION;
//     _data['CONTACT_NUMBER'] = CONTACTNUMBER;
//     _data['CONTACT_PERSON'] = CONTACTPERSON;
//     _data['CONTACT_PERSON_CONTACT_NUMBER'] = CONTACTPERSONCONTACTNUMBER;
//     _data['DATE_OF_BIRTH'] = DATEOFBIRTH;
//     _data['DISTRIBUTOR_NAME'] = DISTRIBUTORNAME;
//     _data['DEALER_FIRM_NAME'] = DEALERFIRMNAME;
//     _data['DEALER_NAME'] = DEALERNAME;
//     _data['DEPO'] = DEPO;
//     _data['DESCRIPTION'] = DESCRIPTION;
//     _data['DIRECTOR_NAME'] = DIRECTORNAME;
//     _data['MEMBER_NAME'] = MEMBERNAME;
//     _data['DISTRIBUTOR_OF_COMPANY'] = DISTRIBUTOROFCOMPANY;
//     _data['DISTRIBUTOR_PIN_CODE'] = DISTRIBUTOR_PINCODE;
//     _data['DOCTOR'] = DOCTOR;
//     _data['CONSULTANT'] = CONSULTANT;
//     _data['DOSE'] = DOSE;
//     _data['EDITOR_NAME'] = EDITORNAME;
//     _data['EGG_STORING_CAPACITY'] = EGGSTORINGCAPACITY;
//     _data['EMAIL'] = EMAIL;
//     _data['EXHIBITION_NAME'] = EXHIBITIONNAME;
//     _data['EXPERTISE'] = EXPERTISE;
//     _data['FACILITY'] = FACILITY;
//     _data['FORMULATION'] = FORMULATION;
//     _data['FULL_LOAD'] = FULLLOAD;
//     _data['INSTITUTE_NAME'] = INSTITUTENAME;
//     _data['INSTITUTION'] = INSTITUTION;
//     _data['ENTREPRENEUR'] = ENTREPRENEUR;
//     _data['LAB_NAME'] = LABNAME;
//     _data['LINE_SUPERVISOR'] = LINESUPERVISOR;
//     _data['LIST_OF_PROJECT'] = LISTOFPROJECT;
//     _data['LIST_OF_SERVICE'] = LISTOFSERVICE;
//     _data['MARKETING_PERSON'] = MARKETINGPERSON;
//     _data['MEMBER_DESIGNATION'] = MEMBERDESIGNATION;
//     _data['MOBILE_NUMBER'] = MOBILENUMBER;
//     _data['MRP'] = MRP;
//     _data['NAME'] = NAME;
//     _data['OTHERS'] = OTHERS;
//     _data['PACKING'] = PACKING;
//     _data['PARTNER_NAME'] = PARTNERNAME;
//     _data['PERSON_NAME'] = PERSONNAME;
//     _data['PHONENUMBER'] = PHONENUMBER;
//     _data['POSITION'] = POSITION;
//     _data['PRODUCT'] = PRODUCT;
//     _data['PRODUCT_DETAILS'] = PRODUCTDETAILS;
//     _data['PRODUCT_NAME'] = PRODUCTNAME;
//     _data['PRODUCT_USAGE'] = PRODUCTUSAGE;
//     _data['HOD_NAME'] = HODNAME;
//     _data['PUBLICATION_HOUSE'] = PUBLICATIONHOUSE;
//     _data['QUALIFICATION'] = QUALIFICATION;
//     _data['RAW_MATERIAL_NAME'] = RAWMATERIALNAME;
//     _data['REMARK'] = REMARK;
//     _data['RETAIL_OUTLET_NAME'] = RETAILOUTLETNAME;
//     _data['SALES_PERSON_NAME'] = SALESPERSONNAME;
//     _data['SOFTWARE_NAME'] = SOFTWARENAME;
//     _data['SPECIALISATION'] = SPECIALISATION;
//     _data['MASTERS'] = MASTERS;
//     _data['SPECIALISE_IN'] = SPECIALISEIN;
//     _data['SPECIALITY'] = SPECIALITY;
//     _data['SPECIES_NAME'] = SPECIESNAME;
//     _data['SPECIFICATION'] = SPECIFICATION;
//     _data['STATE'] = STATE;
//     _data['SUBJECT'] = SUBJECT;
//     _data['SUBSIDY_LIST'] = SUBSIDYLIST;
//     _data['TECHNICIAN_EMAIL'] = TECHNICIANEMAIL;
//     _data['TECHNICIAN_NAME'] = TECHNICIANNAME;
//     _data['TRANSPORT_ID'] = TRANSPORTID;
//     _data['USED_FOR'] = USEDFOR;
//     _data['VALUE_ADDITION'] = VALUEADDITION;
//     _data['VALUE_ADDITION_REMARK'] = VALUEADDITIONREMARK;
//     _data['WAREHOUSE'] = WAREHOUSE;
//     _data['WEBSITE'] = WEBSITE;
//     _data['WHICH_TYPE_OF_LABOUR'] = WHICHTYPEOFLABOUR;
//     _data['YPE_OF_CERTIFICATION'] = YPEOFCERTIFICATION;
//     _data['rdate'] = rdate;
//     _data['updated_at'] = updatedAt;
//     _data['created_at'] = createdAt;
//     return _data;
//   }
// }