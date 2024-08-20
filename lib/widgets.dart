import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  const IconAndText ( this.icon, this.text, {super.key});    // Constructeur avec 2 propriétés

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all (8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon , color: Colors.red , ),
            const SizedBox(width: 8),
            Text(text , style: const TextStyle(color:Colors.blue ),) ,],         ),  );  }     }
