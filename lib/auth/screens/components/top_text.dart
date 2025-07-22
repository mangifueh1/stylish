
  import 'package:flutter/material.dart';

Widget topText() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's Get Started",
                  style: TextStyle(fontSize: 32, color: Colors.black),
                ),
                Text(
                  "Fill the form to continue",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            );
  }
