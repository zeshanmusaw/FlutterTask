import 'package:hive/hive.dart';

part 'localdb_model.g.dart';

// @HiveType(typeId: 0)
// class LocaldbModel extends HiveObject {
//   @HiveField(0)
//   late final String title;
//
//   LocaldbModel({required this.title});
// }


@HiveType(typeId: 0)
class LocaldbModel {
  @HiveField(0)
  final String title;

  LocaldbModel({required this.title});
}