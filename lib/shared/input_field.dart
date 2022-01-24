import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';

class InputField extends StatelessWidget {
  const InputField(this.title, this.controller,{
    Key? key,
    this.isPassword = false,
    this.isMulti = false,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final bool isPassword, isMulti;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: kDefaultPadding * .5),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: progressTextInputDecoration,
          )
        ],
      ),
    );
  }
}