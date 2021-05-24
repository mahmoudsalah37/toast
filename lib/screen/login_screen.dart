import 'package:Toast/screen/chat_screen.dart';
import 'package:Toast/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:pubnub/pubnub.dart';

import 'constant.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = true;
  TextEditingController passwordTEC = TextEditingController(text: ''),
      emailTEC = TextEditingController(text: '');
  final PubNub pubNub = PubNub(
    defaultKeyset: Keyset(
      subscribeKey: kSubscribeKey,
      publishKey: kPublishKey,
      secretKey: kSecretKey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/login_toast.png', width: 150),
            SizedBox(height: 100),
            TextField(controller: emailTEC, decoration: kRoundedDecorationTF),
            SizedBox(height: 12),
            TextField(
              controller: passwordTEC,
              obscureText: isPasswordVisible,
              decoration: kRoundedDecorationTF.copyWith(
                hintText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: isPasswordVisible
                      ? Icon(Icons.visibility_off, color: Colors.brown)
                      : Icon(Icons.visibility, color: Colors.brown),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  final login = await pubNub.objects.getUUIDMetadata(
                    includeCustomFields: true,
                    uuid: emailTEC.text,
                  );
                  final Map<String, dynamic> custom = login.metadata.custom;
                  final String password = custom.entries
                      .singleWhere((element) => element.key == 'password')
                      .value;
                  if (password == passwordTEC.text) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(email: login.metadata.email),
                      ),
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('not valid'),
                      ),
                    );
                  }
                } catch (e) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('something went wrong'),
                    ),
                  );
                  print('exception>>> $e');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Login', style: TextStyle(fontSize: 20)),
              ),
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            ),
            SizedBox(height: 20),
            Text(
              'OR',
              style: TextStyle(
                  decoration: TextDecoration.underline, color: Colors.brown),
            ),
            SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, RegisterScreen.id),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20, color: Colors.brown),
                ),
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 2.0, color: Colors.brown),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration kRoundedDecorationTF = InputDecoration(
  fillColor: Colors.white,
  hintText: 'Email',
  labelStyle: TextStyle(color: Colors.brown),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.brown, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.brown, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);
