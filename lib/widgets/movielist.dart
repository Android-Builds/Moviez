import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:moviez/models/movies.dart';
import 'package:moviez/utils/constants.dart';

class MovieList extends StatelessWidget {
  const MovieList({
    Key? key,
    required this.edit,
  }) : super(key: key);

  final Function(int) edit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('movies').listenable(),
      builder: (context, Box moviesBox, _) {
        return ListView.builder(
          itemCount: moviesBox.length,
          itemBuilder: (context, index) {
            final Movies movie = moviesBox.getAt(index) as Movies;
            return Container(
              height: 250.0,
              width: size.width,
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: getImage(movie),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 200.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: getPosterImage(movie),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                text(context, 'Movie', movie.name),
                                text(context, 'Director', movie.dirName),
                                SizedBox(height: 30.0),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => edit(index),
                                      icon: Icon(
                                        Icons.edit,
                                        size: size.width * 0.04,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          moviesBox.deleteAt(index),
                                      icon: Icon(
                                        Icons.delete,
                                        size: size.width * 0.04,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  getImage(Movies movie) {
    return movie.netwokImage
        ? CachedNetworkImageProvider(movie.imageUrl)
        : FileImage(File(movie.imageUrl));
  }

  getPosterImage(Movies movie) {
    return movie.netwokImage
        ? CachedNetworkImage(
            imageUrl: movie.imageUrl,
            placeholder: (_, i) => CircularProgressIndicator(),
          )
        : Image.file(File(movie.imageUrl));
  }

  Widget text(
    BuildContext context,
    String header,
    String value,
  ) {
    return SizedBox(
      width: size.width * 0.3,
      height: size.height * 0.08,
      child: RichText(
        text: TextSpan(
          text: '$header:\n',
          style: DefaultTextStyle.of(context).style.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.04,
                color: Colors.red.shade300,
              ),
          children: <TextSpan>[
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
