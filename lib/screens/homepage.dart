import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviez/blocs/intro_bloc/intro_bloc.dart';
import 'package:moviez/models/movies.dart';
import 'package:moviez/screens/intropage.dart';
import 'package:moviez/utils/constants.dart';
import 'package:moviez/widgets/IntroWidget.dart';
import 'package:moviez/widgets/emptylist.dart';
import 'package:moviez/widgets/movielist.dart';

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class HomePage extends StatefulWidget {
  final bool googleLogIn;
  HomePage({Key? key, required this.googleLogIn}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? image;
  static int i = 0;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  TextEditingController imageUrl = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController dirName = new TextEditingController();

  final moviesBox = Hive.box('movies');

  void deleteMovie(int index) {
    moviesBox.deleteAt(index);
    moviesBox.compact();
    if (moviesBox.isEmpty) setState(() {});
  }

  void callBackToUpdateState() {
    setState(() {});
  }

  void editMovie(int index) {
    final Movies movie = moviesBox.getAt(index);
    setState(() {
      name.text = movie.name;
      dirName.text = movie.dirName;
      movie.netwokImage
          ? imageUrl.text = movie.imageUrl
          : image = new XFile(movie.imageUrl);
    });
    inputDialog(size, index, true);
  }

  Future<bool> _onWillPop(context) async {
    i++;
    if (i < 2) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Press again to exit'),
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      return true;
    }
    return false;
  }

  Widget _previewImages() {
    if (image != null) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: Image.file(File(image!.path)),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    } else if (response.file != null) {
      setState(() {
        image = response.file;
      });
    }
  }

  Future<void> openGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400.0,
        maxWidth: 400.0,
      );
      setState(() {
        image = pickedFile;
      });
    } catch (e) {
      _pickImageError = e;
      print(e);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Moviez'),
                actions: [
                  IconButton(
                      onPressed: () {
                        if (widget.googleLogIn) signOut();
                        Hive.box('prefs').put('loggedIn', false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroPage()));
                      },
                      icon: Icon(Icons.logout)),
                  widget.googleLogIn
                      ? IconButton(
                          onPressed: () => inputDialog(size, 0, false).then(
                              (value) =>
                                  {if (moviesBox.length == 1) setState(() {})}),
                          icon: Icon(Icons.add),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              body: Hive.box('movies').isEmpty
                  ? EmptyList(
                      callBackToUpdateState: callBackToUpdateState,
                    )
                  : MovieList(
                      edit: editMovie,
                      delete: deleteMovie,
                    ),
            ),
            BlocBuilder<IntroBloc, IntroState>(builder: (context, state) {
              if (state.firstRun)
                return IntroWidget();
              else
                return SizedBox.shrink();
            })
          ],
        ),
      ),
    );
  }

  Future<void> inputDialog(
    Size size,
    int index,
    bool edit,
  ) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(edit ? 'Edit Movie' : 'Add Movie'),
        content: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: size.height - 50.0,
                  maxWidth: size.width * 0.8,
                  minHeight: size.height * 0.2,
                  minWidth: size.width * 0.8),
              child: ListView(
                shrinkWrap: true,
                children: [
                  imageUrl.text == ''
                      ? FutureBuilder<void>(
                          future: retrieveLostData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return SizedBox.shrink();
                              case ConnectionState.done:
                                return _previewImages();
                              default:
                                if (snapshot.hasError) {
                                  return Text(
                                    'Pick image/video error: ${snapshot.error}}',
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                            }
                          },
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl.text,
                          height: 400.0,
                          width: 400.0,
                          placeholder: (_, i) => CircularProgressIndicator(),
                        ),
                  Row(
                    children: [
                      Text('Pick an Image: '),
                      Spacer(),
                      IconButton(
                        onPressed: () =>
                            {openGallery().then((value) => setState(() => {}))},
                        icon: Icon(Icons.image),
                      ),
                      IconButton(
                        onPressed: () =>
                            {pasteImage().then((value) => setState(() => {}))},
                        icon: Icon(Icons.attachment),
                      ),
                    ],
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(hintText: 'Movie'),
                  ),
                  TextField(
                    controller: dirName,
                    decoration: InputDecoration(hintText: 'Director'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              clearAll();
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!edit)
                addNewMovie();
              else
                editMovieInList(index);
              clearAll();
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void editMovieInList(int index) {
    if (name.text != '' &&
        dirName.text != '' &&
        (image != null || imageUrl.text != '')) {
      moviesBox.putAt(
        index,
        new Movies(
          name: name.text,
          dirName: dirName.text,
          imageUrl: image?.path ?? imageUrl.text,
          netwokImage: imageUrl.text != '',
        ),
      );
    } else
      showError();
  }

  showError() {
    List fields = [];
    if (imageUrl.text == '' && image == null) fields.add('Image');
    if (name.text == '') fields.add('Movie Name');
    if (dirName.text == '') fields.add('Director Name');
    showSnackBar(fields.join(', '));
  }

  void addNewMovie() {
    if (name.text != '' &&
        dirName.text != '' &&
        (image != null || imageUrl.text != '')) {
      moviesBox.add(
        new Movies(
          name: name.text,
          dirName: dirName.text,
          imageUrl: image?.path ?? imageUrl.text,
          netwokImage: imageUrl.text != '',
        ),
      );
    } else
      showError();
  }

  void showSnackBar(String field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$field is empty. Add to continue !'),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0,
      ),
    );
  }

  void clearAll() {
    imageUrl.clear();
    dirName.clear();
    name.clear();
    image = null;
  }

  Future<void> pasteImage() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Paste Poster Link'),
        content: TextField(
          controller: imageUrl,
          decoration: InputDecoration(hintText: 'Image Url'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   Hive.box('movies').compact();
  //   Hive.close();
  //   super.dispose();
  // }
}
