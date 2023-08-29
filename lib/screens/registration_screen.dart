import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static final String id = "registrationscreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late FirebaseAuth _auth;
  void initFB() {
    _auth = FirebaseAuth.instance;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initFB();
  }

  bool isShowSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isShowSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.pinkAccent,
                btnText: "Registration",
                onPressed: () async {
                  setState(() {
                    isShowSpinner = true;
                  });

                  print(email);
                  print(password);
                  try {
                    await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? newUser) {
                      if (newUser != null) {
                        // print(
                        //     " Created!! FireBaseAuth.createUserWithEmailAndPassword");
                        // print(newUser.uid);
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    });
                    setState(() {
                      isShowSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  } 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
