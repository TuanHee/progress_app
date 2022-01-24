import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/models/project.dart';
import 'package:progress_app/shared/input_field.dart';
import 'package:progress_app/shared/primary_button.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';

class ProjectInformationPage extends StatefulWidget {
  const ProjectInformationPage({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  _ProjectInformationPageState createState() => _ProjectInformationPageState();
}

class _ProjectInformationPageState extends State<ProjectInformationPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    titleController.text = widget.project.title;
    descriptionController.text = widget.project.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                TitleWithCustomUnderline(title: "Project Information"),
              ],
            ),
            // FutureBuilder(
            //   future: ,
            // ),
            InputField("Title", titleController),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: kDefaultPadding * .5),
            TextField(
              controller: descriptionController,
              minLines: 5,
              maxLines: null,
              decoration: progressTextInputDecoration,
            ),
            const SizedBox(height: kDefaultPadding * .5),
            PrimaryButton(text: "Save", press: () {})
          ],
        ),
      ),
    );
  }
}

class ProjectInfoForm extends StatelessWidget {
  const ProjectInfoForm({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField("Title", TextEditingController()),
      ],
    );
  }
}