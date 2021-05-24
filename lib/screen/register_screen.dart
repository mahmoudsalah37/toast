import 'package:Toast/screen/constant.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:pubnub/pubnub.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PubNub pubNub = PubNub(
    defaultKeyset: Keyset(
      subscribeKey: kSubscribeKey,
      publishKey: kPublishKey,
      secretKey: kSecretKey,
    ),
  );

  TextEditingController nameTEC = TextEditingController(text: ''),
      emailTEC = TextEditingController(text: ''),
      passwordTEC = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 12),
        child: Column(
          children: [
            TextField(
              controller: nameTEC,
              decoration: kRoundedDecorationTF.copyWith(hintText: 'Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailTEC,
              decoration: kRoundedDecorationTF.copyWith(hintText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordTEC,
              decoration: kRoundedDecorationTF.copyWith(hintText: 'password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = await pubNub.objects.setUUIDMetadata(
                  UuidMetadataInput(
                    name: nameTEC.text,
                    email: emailTEC.text,
                    custom: {'password': passwordTEC.text},
                  ),
                  includeCustomFields: true,
                  uuid: emailTEC.text,
                );
                print(user.metadata.email + '  ' + user.metadata.name);
                Navigator.pop(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
