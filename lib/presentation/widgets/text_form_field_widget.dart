import 'package:flutter/material.dart';

Widget defaultTextFormFiled({
  required context,
  required TextEditingController controller,
  required Function(String) validate,
  required String label,
  required IconData prefix,
  required Function onTap,
  TextInputType inputType = TextInputType.text,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: (value) => validate(value!),
      onTap: () => onTap(),
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(
          prefix,
          color: Theme.of(context).primaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
    );
