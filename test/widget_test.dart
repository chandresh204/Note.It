// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_it/data/encrypt_decrypt.dart';

import 'package:note_it/main.dart';

void main() {
  final string =
      '{"notes":[{"id":1706701307236,"note":"vsdvxc+9216544564","editTime":1706701307236,"isEncrypt":false},{"id":1706701299538,"note":"dvsdvtggf","editTime":1706701299538,"isEncrypt":false}],"password":""}';
  final encrypted =
      'hASRDqynbb2JAw0M7sgxHdqKTj8sL4bjxRtrTwDjS673AFWj81SwsJb7A3488WRdf2UefrOEwMUOTv8FCZilSaQHWSmlah7cxLyjw7fBKhHXjwu10Sz2F91nnkJdBUbaOozYpjK8ypZWkCtlwNssZnGtB9q2mODZ8Se6sozbCSDQmBOtPFrnnpOxSgjpeA0vwLgFbLBtR3/O2H+WhItCzDr2g0NEY0MVc8V3jyOImiO3A1Z1bGoilJjAtqNsDp8S7M9/rutJRTiii8A2blOvSQ==';

  final toDecrypt =
      'jbXZcjfv5gywsiHcQ1S6e2So9nXdcyKvb41fwue1U5U3KFfdk3JqxICeWMA4sGdbEXJTw3bZtOI0iX73ta8KYc4qBComaRgjHYyL6E7/WYua8yArN+WIJccSf51QD8N8QFAK4Q7B+NwAx7uOEssbKt7BFyIqZRbBa5hD5pHbYXLoxaEkQunOvYUe92pmN53yNy2IEIKQAdqTggg15KcSFeIzCn1X+O6VWIZfNVzfjmFwTnQBYNiSncEsBzVevyJYG0bMPR+eJPzaZzLcdfHf4O3BHxrtUZMajXwlgThSdVL7Qi23TDgEmvCzH7R+MUuGDE8iFMvdY6QNOLnC0AwykD22Mv8BDO7uuQ0a7pGPjG195D2POD08YJZWVTh/mZJ2jWKAoxLohdd/qPW7OQlLWqhpc1r8SN9OF4ueSTtjg8pSSI9yvpYWgd0fnL53RC+ICDn0AVwONC/SIXm6CTrLb4xpRP9OmP9vf1ehAp6/GkucieDbXvOe4PTUtv5zwlTvonjB9CGDz/DaYvhraef+6etGn7HM7d3/Y3cFwOz1oWq8ONqPheiVN8fDf3tLtOK3U4wrqNFq3fQ2Ez5TB7o9CPigxZy/ntIBu2JcWlP2Qww+ZbfIB78+LRaD/05DwTwlKdz5oOK/VV6UfbeNqbG7YTHSXirPIYkvdBwbrUQ0ZdyHT3nti/ZhW6OR0oz/KWV/VB6tQWvqMbS3xlDdXz60v7izVlLjjvbut10WouIn3aR+KfV1O1EToB/RMcARCYxl2FZ/xS1pOLoiRST+RplQX2o2fMxaOfZZF/yIztEQ4Ceuth+xrYdD3VUhlnQHjZy6P4V57zQNgVzau3A0XsBXEjukcM+E38JEhGVqzce/FRqm+jMci6hgWDYvwc1yAcsFzOzA+KMu6+ilthOyTwoKjzaAtaxlJz8Qi5sdyQlyyDHEMHszCn/I4vAQztWCdnwPs+iTzghWsCqeIW58OIkFUN6Y267TQTt8RZSFRze1Z';

  final hereEnc =EncDec.getEncryptedText(string);
  print(hereEnc);
  print(EncDec.getDecryptText(hereEnc));
}
