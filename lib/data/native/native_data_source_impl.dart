import 'package:flutter/services.dart';

import 'constants.dart';
import 'model/notification_data.dart';
import 'native_date_source.dart';

class NativeDataSourceImpl implements NativeDataSource {

  static const methodChannel = MethodChannel(Constants.methodChannelName);

  @override
  showNotification(String title, String description, int importance) {
    print('calling native method: show notification');
    methodChannel.invokeMethod(Constants.methodShowNotification,
      NotificationData(title: title, desc: description, importance: importance).toJson());
  }

}