import 'package:flutter/material.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVn;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  TodoListField({
    Key? key,
    required this.label,
    this.suffixIconButton,
    this.obscureText = false,
    this.controller,
    this.validator,
  }) : assert(
         obscureText == true ? suffixIconButton == null : true,
         "obscureText não pode ser enviado em conjunto com suffixIconButton",
       ),
       obscureTextVn = ValueNotifier(obscureText),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextVn,
      builder: (_, obscureTextValue, child) {
        return TextFormField(
          obscureText: obscureTextVn.value,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            labelStyle: TextStyle(fontSize: 15, color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red),
            ),
            labelText: label,
            suffixIcon:
                suffixIconButton ??
                (obscureText == true
                    ? IconButton(
                        onPressed: () {
                          obscureTextVn.value = !obscureTextValue;
                        },
                        icon: Icon(
                          obscureTextValue
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      )
                    : null),
          ),
        );
      },
    );
  }
}
