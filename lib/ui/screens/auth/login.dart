import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/ui/screens/auth/register.dart';
import 'package:progress_app/services/auth.dart';
import 'package:progress_app/shared/application_logo.dart';
import 'package:progress_app/shared/input_field.dart';
import 'package:progress_app/shared/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _processing = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  _showMsg(msg) {
    final snackBar = SnackBar(
      elevation: 6.0,
      backgroundColor: dangerBgColor,
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _registerAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account yet?"),
          const SizedBox(
            width: 5
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const RegisterScreen())
              );
            },
            child: const Text(
              'Register',
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
      body: Container(
        height: height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: height * .15),
              ApplicationLogo(),
              const SizedBox(height: 20,),
              InputField(
                'Email',
                emailController,
              ),
              InputField(
                'Password',
                passwordController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              PrimaryButton(
                text: "Login",
                press: () async => _login(),
              ),
              SizedBox(
                height: height * .3,
              ),
              _registerAccountLabel(),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (!_processing) {
      setState(() {
        _processing = true;
      });
      
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email == '' || password == '') {
        _showMsg('All fields are required!');
      } else if (!email.contains('@')) {
        _showMsg('Invalid email. Please try again');
      } else if (password.length < 6) {
        _showMsg('The password must be at least 6 characters.');
      } else {
        var data = await _auth.login(emailController.text.trim(), passwordController.text.trim());

        if (data['success'] == true) {
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        } else {
          _showMsg(data['message']['message']);
        }
      }
    }

    setState(() {
      _processing = false;
    });
  }

}