import 'package:flutter/material.dart';

class Header extends StatefulWidget with PreferredSizeWidget {
  Header({ Key? key, this.title }) : super(key: key);

  final String? title;

  @override
  _HeaderState createState() => _HeaderState();

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title != null ? Text(widget.title!) : null,
    );
  }
}