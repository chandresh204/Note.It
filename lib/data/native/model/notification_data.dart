import 'package:json_annotation/json_annotation.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData {

  final String title;
  final String desc;
  final int importance;

  NotificationData({required this.title, required this.desc, required this.importance});


  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

}