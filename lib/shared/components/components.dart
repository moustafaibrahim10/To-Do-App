import 'package:flutter/material.dart';

Widget defultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  required String label,
  required Widget icon,
  void Function()? ontap,

}) => TextFormField(
controller: controller,
keyboardType: type,
validator: validate,
onTap: ontap,
decoration: InputDecoration(
labelText: label,
prefixIcon: icon,
border: OutlineInputBorder(),
),
);