
import 'package:flutter/material.dart';
import 'package:food_delivery/colors.dart';

Widget Button(Size size, String buttonName) {
  return Padding(
    padding: EdgeInsets.only(top: size.height / 30),
    child: SizedBox(
      width: size.width / 1.4,
      height: size.height / 20,
      child: ElevatedButton(
          onPressed: () {
            if (buttonName == "Login") {
              print("Login");
            } else {
              print("Register");
            }
          },
          style: ElevatedButton.styleFrom(
              primary: c5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Text(buttonName)),
    ),
  );
}

