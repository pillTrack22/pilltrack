import 'package:flutter/material.dart';
import 'package:iot/models/currUser.dart';
import 'package:iot/shared.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot/validator.dart';
import 'package:iot/providers/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "sign_up_page";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  UserData user = UserData(uid: '', name: '', password: '', refill_day: '');
  String dropdownvalue = items[1];
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusName.unfocus();
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: [
                    Color(0xFFE1B60B),
                    Color(0xFFE5CE22),
                    Color(0xFFEADE98),
                  ])),
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            // #signup_text
                            Text(
                              "Sign Up",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            // #welcome
                            Text(
                              "Welcome",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.brown, fontSize: 18),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),

                          // #text_field
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 20,
                                      spreadRadius: 10,
                                      offset: const Offset(0, 10))
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  key: _registerFormKey,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: _nameTextController,
                                        focusNode: _focusName,
                                        validator: (value) =>
                                            Validator.validateName(
                                          name: value,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Name",
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      TextFormField(
                                        controller: _emailTextController,
                                        focusNode: _focusEmail,
                                        validator: (value) =>
                                            Validator.validateEmail(
                                          email: value,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Email",
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      TextFormField(
                                        controller: _passwordTextController,
                                        focusNode: _focusPassword,
                                        obscureText: true,
                                        validator: (value) =>
                                            Validator.validatePassword(
                                          password: value,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 32.0),
                                      _isProcessing
                                          ? CircularProgressIndicator()
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        _isProcessing = true;
                                                      });

                                                      if (_registerFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        User? user =
                                                            await FirebaseAuthHelper
                                                                .registerUsingEmailPassword(
                                                          name:
                                                              _nameTextController
                                                                  .text,
                                                          email:
                                                              _emailTextController
                                                                  .text,
                                                          password:
                                                              _passwordTextController
                                                                  .text,
                                                        );

                                                        setState(() {
                                                          _isProcessing = false;
                                                        });

                                                        if (user != null) {
                                                          // go to screen according to user

                                                        }
                                                      } else {
                                                        setState(() {
                                                          _isProcessing = false;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      'Sign up',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .deepOrangeAccent),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                                TextField(
                                  onSubmitted: (String input) {
                                    //assert id;
                                    user.uid = input;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      hintText: "ID",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                                Divider(
                                  thickness: 2,
                                  height: 2,
                                ),
                                TextField(
                                  onSubmitted: (String input) {
                                    //assert id;
                                    user.name = input;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      hintText: "Name",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                                Divider(
                                  thickness: 2,
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Text('  Choose Refill Day:',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(width: 30),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DropdownButton(
                                            // Initial Value
                                            value: dropdownvalue,

                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),

                                            // Array list of items
                                            items: items.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownvalue = newValue!;
                                                user.refill_day = newValue;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                  height: 2,
                                ),
                                TextField(
                                  onSubmitted: (String input) {
                                    //assert id;
                                    user.password = input;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                                Divider(
                                  thickness: 2,
                                  height: 2,
                                ),
                                TextField(
                                  onSubmitted: (String input) {
                                    //assert id;
                                    user.password = input;
                                    setState(() {});
                                  },
                                  cursorHeight: 1,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      hintText: "Password Again",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),

                          // #signup_button
                          MaterialButton(
                            onPressed: () {
                              String uid = user.uid,
                                  password = user.password,
                                  name = user.name;
                              String refill_day = user.refill_day;
                              //can pass arguments to pushnamed after path
                              _database.child('$currUserID/info/').update({
                                'id': '$uid',
                                'name': '$name',
                                'password': '$password',
                                'refill day': '$refill_day'
                              });
                              currUserType = 'patient';
                              Navigator.pushReplacementNamed(
                                  context, '/log_in');
                            },
                            height: 45,
                            minWidth: 240,
                            shape: const StadiumBorder(),
                            color: const Color(0xFFE5B60E),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
