import 'package:flutter/services.dart';
import 'package:note_it2/data/native/model/notification_data.dart';
import 'package:note_it2/data/native/native_date_source.dart';

import 'constants.dart';

class NativeDataSourceImpl implements NativeDataSource {

  static const methodChannel = MethodChannel(Constants.methodChannelName);

  @override
  showNotification(String title, String description, int importance) {
    print('calling native method: show notification');
    methodChannel.invokeMethod(Constants.methodShowNotification,
      NotificationData(title: title, desc: description, importance: importance).toJson());
  }

}