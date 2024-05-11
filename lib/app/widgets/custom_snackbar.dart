import 'package:flutter/material.dart';

class BeautifulSnackBar {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.deepPurple,
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'ACTION',
        onPressed: () {
          // Custom action
        },
        textColor: Colors.amberAccent,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 6.0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
