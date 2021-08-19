import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moviez/models/movies.dart';
import 'package:moviez/screens/homepage.dart';
import 'package:moviez/screens/intropage.dart';
import 'package:moviez/utils/constants.dart';
import 'package:moviez/utils/themes.dart';

import 'blocs/intro_bloc/intro_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(MoviesAdapter());
  await Hive.openBox('movies');
  await Hive.openBox('prefs');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> openPrefs() async {
    if (!Hive.isBoxOpen('prefs')) await Hive.openBox('prefs');
  }

  @override
  Widget build(BuildContext context) {
    //openPrefs();
    firstLaunch = Hive.box('prefs').get('firstLaunch') ?? true;
    var loggedIn = Hive.box('prefs').get('loggedIn') ?? false;
    var googleLogIn = Hive.box('prefs').get('googleLogIn') ?? false;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IntroBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: !loggedIn ? IntroPage() : HomePage(googleLogIn: googleLogIn),
      ),
    );
  }
}
