import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String uname = "";
  String pass = "";
  String error = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Google auth
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: uname, password: pass);
        setState(() {
          changeButton = !changeButton;
        });
        // await Future.delayed(const Duration(seconds: 1));
        // ignore: use_build_context_synchronously
        await Navigator.pushNamed(context, "/home");
        setState(() {
          changeButton = !changeButton;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            error = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            error = 'Wrong password provided for that user.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                "assets/images/login.png",
                fit: BoxFit.cover,
              ),
              // Instead of Padding, can even insert code in it
              // Can also use padding in the below text
              const SizedBox(
                height: 20,
              ),
              Text(
                "Welcome! $uname",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "$error",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          uname = value;
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: "Username", labelText: "Enter Username"),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password", labelText: "Enter Password"),
                      onChanged: (value) => setState(() {
                        pass = value;
                      }),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Material(
                color: Colors.indigoAccent,
                child: InkWell(
                  onTap: () => handleLogin(context),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: 50,
                    width: changeButton ? 50 : 150,
                    alignment: Alignment.center,
                    child: changeButton
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}