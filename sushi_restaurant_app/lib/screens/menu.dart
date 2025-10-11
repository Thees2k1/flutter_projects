import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_restaurant_app/models/food.dart';
import 'package:sushi_restaurant_app/themes/colors.dart';
import 'package:sushi_restaurant_app/widgets/button.dart';
import 'package:sushi_restaurant_app/widgets/food_tile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List foodMenu = [
    Food(
      name: 'Nigiri sushi',
      price: '25.00',
      imagePath: 'assets/images/nigiri.png',
      rating: '4.9',
    ),
     Food(
      name: 'onigiri sushi',
      price: '35.00',
      imagePath: 'assets/images/onigiri.png',
      rating: '3.9',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.menu,
          color: textColor,
        ),
        title: const Text(
          'Menu',
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(25)),
            margin: EdgeInsets.symmetric(horizontal: 25),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      'Get 23% Promo',
                      style: GoogleFonts.dmSerifDisplay(
                          fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedMainButton(
                      text: 'Redeem',
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/nigiri.png',
                  height: 100,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0 ,left: 25,right: 25),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          //menulist
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Food Menu',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          //popular food
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodMenu.length,
              itemBuilder: (context,index){
                return FoodTile(food: foodMenu[index]);
            }),
          ),

          const SizedBox(height: 25,)
        ],
      ),
    );
  }
}
