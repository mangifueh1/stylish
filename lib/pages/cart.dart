import 'package:flutter/material.dart';
import 'package:stylish/widgets.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: Text('Cart Page')),
            Column(
              children: [CustomAppBar(), Spacer(), CustomNavBar(whatPage: 2)],
            ),
          ],
        ),
      ),
    );
  }
}