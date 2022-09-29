import 'package:crud_app/models/loginuser.dart';
import 'package:crud_app/screens/home/home.dart';
import 'package:crud_app/services/auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function? toggleView;
  Login({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  bool _obscureText = true;

  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {

    final heading = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'CRUD with AUTH',
        textScaleFactor: 2,
      ),
    );

    final emailField = TextFormField(
        controller: _email,
        autofocus: false,
        validator: (value) {
          if (value != null) {
            if (value.contains('@') && value.endsWith('.com')) {
              return null;
            }
            return 'Enter a Valid Email Address';
          }
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final passwordField = TextFormField(
        obscureText: _obscureText,
        controller: _password,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          if (value.trim().length < 8) {
            return 'Password must be at least 8 characters in length';
          }
          // Return null if the entered password is valid
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )));

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('New? Register here'));

    final loginEmailPasswordButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromARGB(255, 4, 94, 155),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
          
             dynamic result = await _auth.signInEmailPassword(LoginUser(email: _email.text,password: _password.text));
              if (result.uid == null) { //null means unsuccessfull authentication
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(result.code),
                      );
                    });
          }
          }
        },
        child: Text(
          "Log in",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            ),
          textAlign: TextAlign.center,
          textScaleFactor: 1.2,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login Demo Page'),
        backgroundColor: Color.fromARGB(255, 4, 94, 155),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  heading,
                  emailField,
                  const SizedBox(height: 25.0),
                  passwordField,
                  txtbutton,
                  const SizedBox(height: 35.0),
                  loginEmailPasswordButon,
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}