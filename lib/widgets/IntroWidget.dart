import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:moviez/blocs/intro_bloc/intro_bloc.dart';

class IntroWidget extends StatefulWidget {
  const IntroWidget({Key? key}) : super(key: key);

  @override
  _IntroWidgetState createState() => _IntroWidgetState();
}

class _IntroWidgetState extends State<IntroWidget> {
  static bool firstInstruction = true;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ),
        firstInstruction
            ? Positioned(
                right: 5.0,
                top: MediaQuery.of(context).padding.top + 5.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => {
                        setState(() {
                          firstInstruction = false;
                        })
                      },
                      child: CircleAvatar(
                        radius: 25.0,
                        child: Icon(
                          Icons.add,
                          color: Colors.red.shade300,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 150.0,
                        child: Text(
                          'Log in via google account to add movies from here',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: size.width * 0.7,
                        child: Text(
                          'Click here to import precompiled list',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextButton(
                          onPressed: () {
                            Hive.box('prefs').put('firstLaunch', false);
                            BlocProvider.of<IntroBloc>(context)
                                .add(IntroEvent(false));
                          },
                          child: Text('Import from file'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
