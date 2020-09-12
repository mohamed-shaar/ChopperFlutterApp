import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:connectivity/connectivity.dart';

class MobileDataInterceptor implements RequestInterceptor{
  @override
  FutureOr<Request> onRequest(Request request) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool isMobile = connectivityResult == ConnectivityResult.mobile;
    final bool isLargeFile = request.url.contains(RegExp(r'(/large|/video|posts)'));

    if (isMobile && isLargeFile) {
      throw MobileDataClassException();
    }
    return request;
  }

}

class MobileDataClassException implements Exception {
  final message = 'Downloading large files on mobile data will incur costs';

  @override
  String toString() {
    return message;
  }
}