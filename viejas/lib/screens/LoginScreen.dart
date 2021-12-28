import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _playerId = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 70, 15, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.asset('images/Logo.png', fit: BoxFit.fill),
                  ),
                  _buildTextField(_playerId, false),
                  SizedBox(height: 15),
                  _buildTextField(_password, false),
                  _buildSigninButton(context),
                  _buildForgetPassword(),
                  SizedBox(height: 25),
                  _buildSignup(),
                ],
              ),
            ),
          ),
        ));
  }

  Row _buildSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            'Need a mobile app account?',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.white),
          ),
        ),
        SizedBox(
          width: 7,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            'Signup',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  InkWell _buildForgetPassword() {
    return InkWell(
      onTap: () {},
      child: Text(
        'Forget Password',
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white),
      ),
    );
  }

  Container _buildSigninButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      width: 100,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            Navigator.pop(context);
          });
        },
        child: const Text(
          'Sign In',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.white),
      ),
    );
  }

  Container _buildTextField(TextEditingController controller, bool isObscure) {
    return Container(
      height: 40,
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: isObscure,
          textAlign: TextAlign.center,
          cursorColor: Colors.black,
          style: const TextStyle(
              fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
            hintText: 'Username',
            hintStyle: TextStyle(color: Colors.black),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        ),
      ),
    );
  }
}
