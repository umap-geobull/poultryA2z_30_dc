
import 'package:cross_file/src/types/io.dart';
class Add_Product_Details {
  final int product_id;
  final String product_name;
  final XFile product_image;


  Add_Product_Details( {
    required this.product_id,
    required this.product_name,
    required this.product_image
  });
}

List<Add_Product_Details> add_product_model = [];