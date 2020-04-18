import 'package:flutter/material.dart';
/*
 * This custom button provides the same height as its parent with 8-pixel padding
 */
class CustomButton1 extends StatelessWidget {
  final Function() onPressed; 
  final Widget child;
  
  const CustomButton1({Key key, this.child, this.onPressed}): super(key:key);
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        elevation: 2.0,
        height: double.maxFinite,
        color: Colors.grey[300],
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}