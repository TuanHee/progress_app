import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/screens/dashboard/body.dart';
import 'package:progress_app/shared/header.dart';
import 'package:progress_app/shared/side_menu.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({ Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: SideMenu(),
      body: Body(),
    );
  }
}
