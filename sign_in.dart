import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shreya_demo/emailandgoogleauth/sign_up.dart';
import 'package:shreya_demo/emailandgoogleauth/welcomesceen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //
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
        title: Text('Sign in'),
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

            SizedBox(height: 16),

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

            SizedBox(height: 4),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Forgot Password?'),
                  onPressed: () {
                    forgotPassword();
                  },
                ),
              ],
            ),
            //
            ElevatedButton(
              child: Text('Sign in'),
              onPressed: () {
                //
                signin(context);
              },
            ),
            SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Don\'t have an account ?'),
                TextButton(
                  child: Text('Sign up'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SignUp()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signin(BuildContext context) async {
    try {
      //
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //
      User? user = userCredential.user;
      //
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
          errormsg = 'Unable to login. Please try again.';
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        errormsg = error.message!;
      });
    }
  }

  Future<void> forgotPassword() async {
    try {
      //
      await firebaseAuth.sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException catch (error) {
      setState(() {
        errormsg = error.message!;
      });
    }
  }
}
