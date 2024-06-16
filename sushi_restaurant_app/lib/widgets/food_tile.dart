import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_restaurant_app/models/food.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  const FoodTile({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25),
      padding: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(food.imagePath,height: 140,),
          Text(food.name, style: GoogleFonts.dmSerifDisplay(fontSize: 20,),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text("\$" + food.price,style:   TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold),),
            Icon(Icons.star,color: Colors.yellow[800],),
            Text(food.rating,style: const TextStyle(color: Colors.grey),),
          ],)
          
        ],
      ),
    );
  }
}