import 'package:flutter/material.dart';

class RoundedMainButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final void Function()? onTap;

  const RoundedMainButton({super.key, required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:const  Color.fromRGBO(2, 2, 2, 0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(width: 10,),
            icon,
          ],
        ),
      ),
    );
  }
}
