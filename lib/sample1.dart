import 'package:flutter/material.dart';

class sample1 extends StatefulWidget {
  const sample1({super.key});

  @override
  State<sample1> createState() => _sample1State();
}

class _sample1State extends State<sample1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(

        children: [
          Container(width: 100,height: 100,color: Colors.black,)
        ],
      ),
    );
  }
}
