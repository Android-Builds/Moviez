import 'package:hive/hive.dart';

part 'movies.g.dart';

@HiveType(typeId: 0)
class Movies {
  @HiveField(0)
  String name;

  @HiveField(1)
  String dirName;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  bool netwokImage;

  Movies({
    required this.name,
    required this.dirName,
    required this.imageUrl,
    required this.netwokImage,
  });
}
