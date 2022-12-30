import 'package:flutter/material.dart';

class Product_Model {
  final int id;
  final String title, icon, offer, Gender, price, offer_price, seller_name;
  final double rating;
  final List<String> product_images;
  final List<Color> product_colours;
  final List<String> product_size;




  Product_Model({
    required this.id,
    required this.title,
    required this.icon,
    required this.rating,
    required this.offer,
    required this.Gender,
    required this.price,
    required this.offer_price,
    required this.seller_name,

    required this.product_images,
    required this.product_colours,
    required this.product_size,

  });
}

// Our demo Products

List<Product_Model> Product_Model_List = [
  Product_Model(
      id: 1,
      title: "Zoom Shoes",
      icon: "assets/footwear/Loafers.jpg",
      rating: 4,
      offer: "10% off",
      Gender: "Men",
      price: "₹500",
      offer_price: "₹450",
      seller_name: "Bata Traders",
      product_images: [
        'assets/banner/mens_slider1.jpg',
        'assets/banner/mens_slider2.jpg',
        'assets/banner/mens_slider3.jpg'

      ],
    product_colours: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    product_size: [
      '5','5','5','5','5','5',

    ],

  ),
  Product_Model(
    id: 2,
    title: "RONOZO CLARKS 110",
    icon: "assets/footwear/Oxfords.jpg",
    rating: 3.5,
    offer: "10% off",
    Gender: "Men",
    price: "₹1000",
    offer_price: "₹900",
    seller_name: "Bata Traders",
    product_images: [
      'assets/banner/mens_slider1.jpg',
      'assets/banner/mens_slider2.jpg',
      'assets/banner/mens_slider3.jpg'

    ],
    product_colours: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    product_size: [
      '5','5','5','5','5','5',

    ],

  ),
  Product_Model(
    id: 3,
    title: "LEONCINO 001",
    icon: "assets/footwear/Brogues.jpg",
    rating: 4.5,
    offer: "20% off",
    Gender: "Men",
    price: "₹1000",
    offer_price: "₹800",
    seller_name: "Bata Traders",
    product_images: [
      'assets/banner/mens_slider1.jpg',
      'assets/banner/mens_slider2.jpg',
      'assets/banner/mens_slider3.jpg'

    ],
    product_colours: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    product_size: [
      '5','5','5','5','5','5',

    ],

  ),
  Product_Model(
    id: 4,
    title: "ANTIRE SHOES 024",
    icon: "assets/footwear/Loafers.jpg",
    rating: 3.5,
    offer: "50% off",
    Gender: "Men",
    price: "₹1000",
    offer_price: "₹500",
    seller_name: "Bata Traders",
    product_images: [
      'assets/banner/mens_slider1.jpg',
      'assets/banner/mens_slider2.jpg',
      'assets/banner/mens_slider3.jpg'

    ],
    product_colours: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    product_size: [
      '5','5','5','5','5','5',

    ],

  ),
  Product_Model(
    id: 5,
    title: "COOL WAVES 126",
    icon: "assets/footwear/Oxfords.jpg",
    rating: 4.5,
    offer: "30% off",
    Gender: "Men",
    price: "₹1000",
    offer_price: "₹700",
    seller_name: "Bata Traders",
    product_images: [
      'assets/banner/mens_slider1.jpg',
      'assets/banner/mens_slider2.jpg',
      'assets/banner/mens_slider3.jpg'

    ],
    product_colours: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    product_size: [
      '5','5','5','5','5','5',

    ],

  ),
  Product_Model(
    id: 6,
    title: "GOMTI JI 055",
    icon: "assets/footwear/Brogues.jpg",
    rating: 4,
    offer: "30% off",
    Gender: "Men",
    price: "₹1000",
    offer_price: "₹700",
    seller_name: "Bata Traders",
    product_images: [
      'assets/banner/mens_slider1.jpg',
      'assets/banner/mens_slider2.jpg',
      'assets/banner/mens_slider3.jpg'

    ],
    product_colours: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    product_size: [
      '5','5','5','5','5','5',

    ],

  ),


];



