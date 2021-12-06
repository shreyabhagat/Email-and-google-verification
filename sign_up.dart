import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shreya_demo/emailandgoogleauth/sign_in.dart';
import 'package:shreya_demo/emailandgoogleauth/welcomesceen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String errormsg = '';
  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(
        title: Text('Sign up'),
      ),

      //
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            errormsg == ''
                ? Container()
                : Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    color: Colors.red.withOpacity(0.4),
                    height: 100,
                    width: double.infinity,
                    child: Text(errormsg),
                  ),
            SizedBox(height: 16),
            //Name
            TextField(
              //
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              //
              decoration: InputDecoration(
                prefixIcon: Icon(CupertinoIcons.person_alt_circle),
                hintText: 'Name',
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            SizedBox(height: 32),
            //email
            TextField(
              //
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              //
              decoration: InputDecoration(
                prefixIcon: Icon(CupertinoIcons.mail),
                hintText: 'Email',
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            SizedBox(height: 32),

            //Password
            TextField(
              //
              controller: passwordController,
              obscureText: true,
              //
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.visibility),
                hintText: 'Password',
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            SizedBox(height: 32),
            //

            ElevatedButton(
              child: Text('Sign up'),
              onPressed: () {
                //
                signup(context);
              },
            ),
            SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Already have an account ?'),
                TextButton(
                  child: Text('Sign in'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SignIn()),
                    );
                  },
                )
              ],
            ),

            SizedBox(
              height: 16,
            ),

            SignInButton(
              Buttons.Google,
              elevation: 3,
              onPressed: () {
                signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signup(BuildContext context) async {
    try {
      //
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //
      User? user = userCredential.user;

      if (user != null) {
        user.sendEmailVerification();
        await user.updateDisplayName(nameController.text);

        await user.reload();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => WelcomeSceen(),
          ),
        );
      } else {
        setState(() {
          errormsg = 'Unable to create account.';
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        errormsg = error.message!;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // create object of google sign in
      GoogleSignIn googleSignIn = GoogleSignIn();

      // open all google account in phone
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // create authentication object that send to google server
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      // send authentication object to google server
      AuthCredential authCredential = await GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      // sign in with credential
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);

      //
      User? user = userCredential.user;

      if (user != null) {
        await user.reload();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => WelcomeSceen(),
          ),
        );
      } else {
        setState(() {
          errormsg = 'Unable to create account.';
        });
      }
    } on Exception catch (error) {
      setState(() {
        errormsg = errormsg;
      });
    }
  }
}
