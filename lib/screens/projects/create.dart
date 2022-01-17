import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/services/network.dart';
import 'package:progress_app/shared/input_field.dart';
import 'package:progress_app/shared/primary_button.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({ Key? key }) : super(key: key);

  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  bool _processing = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _showMsg(msg) {
    final snackBar = SnackBar(
      elevation: 6.0,
      backgroundColor: dangerBgColor,
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Project'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Projects Create",
              style: Theme.of(context).textTheme.headline6!.copyWith(color: kPrimaryColor),
            ),
            SizedBox(height: kDefaultPadding * .5),
            InputField(
              "Title",
              titleController,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: kDefaultPadding * .5),
                  TextField(
                    controller: descriptionController,
                    minLines: 5,
                    maxLines: null,
                    decoration: progressTextInputDecoration,
                  ),
                ],
              ),
            ),
            PrimaryButton(text: "Submit", press: () => _createProject()),
          ],
        ),
      ),
    );
  }

  void _createProject() async {
    if (!_processing) {
      setState(() {
        _processing = true;
      });
      
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();

      if (title == '') {
        _showMsg('Title fields are required!');
      } else {
        var res = await NetworkService().postRequest('/projects', data: {
          "title": title,
          "description": description,
        }, withAuth: true);

        var body =  convert.jsonDecode(res.body);

        if (res.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/projects');
        } else {
          _showMsg("The title has already been taken.");
        }
      }
    }

    setState(() {
      _processing = false;
    });
  }
}