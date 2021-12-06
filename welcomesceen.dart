import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shreya_demo/emailandgoogleauth/sign_in.dart';

class WelcomeSceen extends StatefulWidget {
  const WelcomeSceen({Key? key}) : super(key: key);

  @override
  _WelcomeSceenState createState() => _WelcomeSceenState();
}

class _WelcomeSceenState extends State<WelcomeSceen> {
  //
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  //
  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reload() async {
    user = firebaseAuth.currentUser;

    await user!.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () async {
              //
              await firebaseAuth.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignIn(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('${user!.displayName}'),
      ),
    );
  }
}
