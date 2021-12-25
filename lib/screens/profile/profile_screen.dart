import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/models/user.dart';
import 'package:progress_app/services/account.dart';
import 'package:progress_app/shared/header.dart';
import 'package:progress_app/shared/input_field.dart';
import 'package:progress_app/shared/primary_button.dart';
import 'package:progress_app/shared/side_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();

    futureUser = Account().getAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "Profile",),
      drawer: SideMenu(),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return EditProfileForm(user: snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  EditProfileForm({ Key? key, required this.user }) : super(key: key);

  User user;

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.network(widget.user.profileUrl, height: 75, width: 75,),
          ),
          InputField(
            "Name",
            nameController,
          ),
          InputField(
            "Email",
            emailController,
          ),
          PrimaryButton(
              text: "Save".toUpperCase(),
              press: () {}
          )
        ],
      ),
    );
  }
}
