import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_restaurant_app/widgets/button.dart';
import 'package:sushi_restaurant_app/widgets/vspace.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 138, 65, 55),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const VSpace(),
            Text(
              'Oishi SuShi',
              style:
                  GoogleFonts.dmSerifDisplay(fontSize: 28, color: Colors.white),
            ),
            const VSpace(),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset('assets/images/sushi.png'),
            ),
            const VSpace(),
            Text(
              'THE TASTE OF JAPANESE FOOD',
              style:
                  GoogleFonts.dmSerifDisplay(fontSize: 44, color: Colors.white),
            ),
            const VSpace(),
            const Text(
              'Feel the taste of the most popular japanese food from anywhere and anytime',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const VSpace(),
             RoundedMainButton(
              text: 'Get Started',
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: (){
                Navigator.pushNamed(context, '/menu');
              },
            ),
          ],
        ),
      ),
    );
  }
}
