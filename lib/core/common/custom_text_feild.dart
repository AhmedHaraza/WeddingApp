import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.hint,
    required this.secure,
    required this.icon,
    required this.type,
    this.validator,
    this.controller,
  });

  final String hint;
  final bool secure;
  final Icon icon;
  final TextInputType type;
  final String? Function(String?)? validator;
  TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isEmpty = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
          errorStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: _isEmpty ? Colors.white : Colors.transparent,
            ),
          ),
          fillColor: Colors.white70,
          filled: true,
          prefixIcon: widget.icon),
      keyboardType: widget.type,
      obscureText: widget.secure,
      validator: widget.validator,
    );
  }
}
