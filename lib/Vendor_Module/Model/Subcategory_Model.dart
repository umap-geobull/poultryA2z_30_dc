
class Subcategory_Model {
  final int id;
  final String title, icon;

  final List<String> slider_images;
  final List<dynamic> categories;



  Subcategory_Model({
    required this.id,
    required this.title,
    required this.icon,

    required this.slider_images,
    required this.categories
  });
}

// Our demo Products

List<Subcategory_Model> Subcategory_Model_list = [
  Subcategory_Model(
    id: 1,
    title: "Mens",
    icon: "assets/category/mens_footwear.jpg",

    slider_images: [
      'assets/banner/mens_slider1.jpg',
      'assets/banner/mens_slider2.jpg',
      'assets/banner/mens_slider3.jpg'

    ],
      categories: [
        {"Name": "Chappals", "icon": "assets/shop_by_category/mens_chappals.jpg",},
        {"Name": "Sandals", "icon": "assets/shop_by_category/mens_sliders.jpg",},
        {"Name": "Shooes", "icon": "assets/footwear/Oxfords.jpg",},
        {"Name": "Lofers", "icon": "assets/shop_by_category/mens_lofers.jpg",},
        {"Name": "Mochi", "icon": "assets/shop_by_category/mens_mochi.jpg", },
        {"Name": "Slippers", "icon": "assets/shop_by_category/mens_slippers.jpg",},
        /*{"Name": "Sliders", "icon": "assets/shop_by_category/mens_sliders.jpg",},*/
        /*{"Name": "Slippers", "icon": "assets/shop_by_category/mens_slippers.jpg",},
        {"Name": "Sneakers", "icon": "assets/shop_by_category/mens_snekaers.jpg", },*/
      ]
  ),
  Subcategory_Model(
    id: 2,
    title: "Womens",
    icon: "assets/category/womes_footwear.jpg",

    slider_images: [
      'assets/banner/womens_slider1.png',
      'assets/banner/womes_slider2.png'

    ],
      categories: [
        {"Name": "Lofers", "icon": "assets/shop_by_category/womens_lofers.jpg",},
        {"Name": "Sandals", "icon": "assets/shop_by_category/womens_sandals.jpg",},


        {"Name": "Chappals", "icon": "assets/shop_by_category/womes_chappal.jpg",},
        {"Name": "Mochi", "icon": "assets/shop_by_category/womes_mochi.jpg",},
       /* {"Name": "Sliders", "icon": "assets/shop_by_category/womes_sliders.jpg",},
        {"Name": "Sneakers", "icon": "assets/shop_by_category/womens_snekers.jpg", },
       ,*/
        {"Name": "Slippers", "icon": "assets/shop_by_category/womes_slippers.jpg", },
        {"Name": "Shooes", "icon": "assets/shop_by_category/womens_shooes.jpg",}
      ]
  ),
  Subcategory_Model(
    id: 3,
    title: "Kids",
    icon: "assets/category/kids_footwear.jpg",

    slider_images: [
      'assets/banner/kids_slider1.jpg',
      'assets/banner/kids_slider2.jpg',
      'assets/banner/kids_slider3.jpg',
    ],
      categories: [

        {"Name": "Chappals", "icon": "assets/shop_by_category/kids_chappals.jpg",},
        {"Name": "Casuals", "icon": "assets/shop_by_category/kids_causals.jpg",},
        {"Name": "Mochi", "icon": "assets/shop_by_category/kids_mochi.jpg", },
        {"Name": "Sandals", "icon": "assets/shop_by_category/kids_sandal.jpg",},
        {"Name": "Shooes", "icon": "assets/shop_by_category/kids_shooes.jpg",},
        {"Name": "Sliders", "icon": "assets/shop_by_category/kids_sliders.jpg",},
      /*  {"Name": "Sneakers", "icon": "assets/shop_by_category/kids_snekers.jpg", },
        ,
        {"Name": "Lofers", "icon": "assets/shop_by_category/kids_lofers.jpg",},*/
      ]
  ),
];



