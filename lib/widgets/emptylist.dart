import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:moviez/blocs/intro_bloc/intro_bloc.dart';
import 'package:moviez/models/movies.dart';
import 'package:moviez/utils/moviesimport.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key, required this.callBackToUpdateState})
      : super(key: key);

  final Function() callBackToUpdateState;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<IntroBloc, IntroState>(
            builder: (context, state) {
              return Lottie.asset(
                'assets/EmptyBox.json',
                animate: !state.firstRun,
              );
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: Text(
              'List is Empty. Add some movies to see them pop up here',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 80.0,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Divider(
              thickness: 2.0,
              color: Colors.grey.shade800,
            ),
          ),
          TextButton(
              onPressed: () {
                final movieBox = Hive.box('movies');
                movieprelist.forEach((element) {
                  movieBox.add(new Movies(
                      name: element['movie'] ?? '',
                      dirName: element['director'] ?? '',
                      imageUrl: element['imageUrl'] ?? '',
                      netwokImage: true));
                });
                callBackToUpdateState();
              },
              child: Text('Import from file'))
        ],
      ),
    );
  }
}
