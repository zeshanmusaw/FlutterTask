

import 'package:json_annotation/json_annotation.dart';
part 'blog_model.g.dart';


@JsonSerializable()
class Blog {
  final int? userId;
  final int? id;
  final String title;
  final String body;

  Blog({
    this.userId,
    this.id,
    required this.title,
    required this.body,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
  Map<String, dynamic> toJson() => _$BlogToJson(this);
}
