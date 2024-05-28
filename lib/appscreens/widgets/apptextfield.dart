import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextInputType inputType;
  final TextEditingController controller;
  final String label;
  const AppTextField({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    required this.inputType
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: [
            if(inputType == TextInputType.number)FilteringTextInputFormatter.allow(RegExp(r'[.0-9]'))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
        ),
        validator:(value){
          if(value == null || value.isEmpty){
            return 'Please fill your $hint';
          }
          return null;
        } ,
      ),
    );
  }
}
