class ConsultantResult{
  String consultant_name;
  String experience;
  String timing;
  String fees;
  String logo;
  ConsultantResult(this.consultant_name, this.experience, this.timing,this.fees,this.logo);
}




List<ConsultantResult> consultantList=[
  ConsultantResult('Dr. Manoj Jain', '1-2 years', '10 AM - 7 PM','Rs. 500','assets/consultant1.jpeg'),

  ConsultantResult('Dr. Lorem Ipsum', '5 years', '10 AM - 7 PM','Rs. 400','assets/consulting.png'),

  ConsultantResult('Lorem Ipsum', '2 years', '9 AM - 5 PM','Rs. 500','assets/consultant.png'),

  ConsultantResult('Lorem Ipsum', '2 years', '10 AM - 6 PM','Rs. 400','assets/consultant.png'),
];

class VendorList{
  String name;
  String supplier;
  String minMaxPrice;
  String image;
  VendorList(this.name, this.supplier, this.minMaxPrice,this.image);
}
List<VendorList> vendorList=[
  VendorList('Krishi nutrishian', 'Vijay kumar', '200 - 2000','assets/images/car4.jpeg'),

  VendorList('VRS Entey', 'Akshay patil', '200 - 2000','assets/images/cat1.jpeg'),

  VendorList('Lorem Ipsum', 'Neha sharma', '200 - 2000','assets/images/cat2.jpeg'),

  VendorList('Lorem Ipsum', 'Akash deshmukh', '200 - 2000','assets/images/cat3.jpeg'),
];