import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/screens/auth/login.dart';
import 'package:progress_app/services/account.dart';
import 'package:progress_app/shared/application_logo.dart';
import 'package:progress_app/shared/input_field.dart';
import 'package:progress_app/shared/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({ Key? key }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool _processing = false;

  _showMsg(msg) {
    final snackBar = SnackBar(
      elevation: 6.0,
      backgroundColor: dangerBgColor,
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already registered?'),
          const SizedBox(
            width: 5
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // ignore: sized_box_for_whitespace
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: height * .15),
                  const ApplicationLogo(),
                  const SizedBox(height: 20,),
                  InputField(
                    'Name',
                    nameController
                  ),
                  InputField(
                    'Email',
                    emailController
                  ),
                  InputField(
                    'Password',
                    passwordController,
                    isPassword: true
                  ),
                  InputField(
                    'Confirm Password',
                    passwordConfirmController,
                    isPassword: true
                  ),
                  SizedBox(height: 20),
                  PrimaryButton(text: 'Register', press: () async => register()),
                  SizedBox(height: height * .1,),
                  _loginAccountLabel(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void register() async {
    if (!_processing) {
      setState(() {
        _processing = true;
      });

      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String passwordConfirm = passwordConfirmController.text.trim();

      if (name == "" || email == "" || password == "" || passwordConfirm == "") {
        _showMsg('All fields are required!');
      } else if (!email.contains('@')) {
        _showMsg('Invalid email. Please try again');
      } else if (password.length < 6) {
        _showMsg('The password must be at least 6 characters.');
      } else if (password != passwordConfirm) {
        _showMsg('The password confirmation does not match.');
      } else {
        var data = await Account().register(name, email, password, passwordConfirm);

        if (data['success'] == true) {
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        } else {
          _showMsg('The email has already been taken.');
        }
      }
    }

    setState(() {
      _processing = false;
    });
  }
}