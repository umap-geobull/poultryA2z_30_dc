import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../Home/Components/AddNewComponent/models/sub_category_model.dart';
import '../Utils/App_Apis.dart';
import '/Utils/constants.dart';
import 'Model/SubCat_Model_List.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Vendor_Product_List.dart';
class Choose_Subcategories extends StatefulWidget {


   Choose_Subcategories({Key? key,required this.main_cat_id, required this.sub_cat_List})
       : super(key: key);
   String main_cat_id;
   List<GetmainSubcategorylist>? sub_cat_List = [];
  @override
  _Choose_SubcategoriesState createState() => _Choose_SubcategoriesState();
}

class _Choose_SubcategoriesState extends State<Choose_Subcategories> {
  int selected = -1;
  String sub_cat_id = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text(
              "Choose Sub-Category",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
          ),
      bottomSheet: Checkout_Section(context),
      body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 3.0, right: 3),
                    child: Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [BoxShadow(color: Color(0xffECF0F1), spreadRadius: 1)],
                        color: Colors.white,
                      ),
                      child: GridView.builder(
                        itemCount: widget.sub_cat_List!.length,
                        // The length Of the array
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (context, index) =>  CategoryItem(
                          widget.sub_cat_List![index].subCategoryName!,
                          widget.sub_cat_List![index].subcategoryImageApp!,
                          //widget.sub_cat_List![index].isSelected!,
                          index,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
  Widget Checkout_Section(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                if(sub_cat_id == '')
                {
                  Fluttertoast.showToast(msg: "Choose main category", backgroundColor: Colors.grey,);

                }
                else{

                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Vendor_Product_List(main_cat_id: widget.main_cat_id, sub_cat_id: sub_cat_id, brand_id: '', type: 'add_product',)),
                  );
                }

              },
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )),
    );
  }
  Widget CategoryItem(String name, String img, int index) {
    return GestureDetector(
      child: Padding(

        padding: const EdgeInsets.all(3.0),
        child: Container(


          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: selected == index ? Colors.green : Colors.grey,
                  width: 2)
            // isSelected ? kPrimaryColor : Colors.grey.shade100, width: 1.5),

          ),
          child: SizedBox(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),


                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: img != ''
                        ? CachedNetworkImage(
                      height: 45,
                      width: 45,
                      imageUrl: sub_categories_base_url+img,
                      placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[400],
                          )),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                        : Container(
                        child: const Icon(Icons.error),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[400],
                        )),
                  ),
                ),

                Padding(
                  padding:  const EdgeInsets.all(3.0),
                  child: SizedBox(
                    height: 10,
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 10, color: black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

      ),
      onTap: () =>
      {
        if(mounted)
          {
            setState(() =>
            {
              selected = index,

              sub_cat_id = widget.sub_cat_List![index].id!

            })
          }

      },
    );
  }
}
