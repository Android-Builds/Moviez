import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:moviez/screens/homepage.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => moveToHome(true));
  }

  void moveToHome(bool googleLogIn) async {
    //if (!Hive.isBoxOpen('prefs')) await Hive.openBox('prefs');
    final prefBox = Hive.box('prefs');
    prefBox.put('googleLogIn', googleLogIn);
    prefBox.put('loggedIn', true);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(googleLogIn: googleLogIn)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moviez'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Lottie.asset('assets/MovieAnim.json', height: 200.0),
              Spacer(),
              TextButton(
                  onPressed: () => moveToHome(false),
                  child: Text(
                    'Continue as a guest',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  )),
              Spacer(),
              Text(
                'OR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              Spacer(),
              Text(
                'Login With Google Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                splashColor: Colors.transparent,
                onTap: signInWithGoogle,
                child: Image.asset(
                  'assets/google.png',
                  scale: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
