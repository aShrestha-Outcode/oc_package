import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../device_information_retrieval/device_information_retrieval_service.dart';
import '../device_information_retrieval/device_information_retrieval_service_impl.dart';
import 'oc_bug_reporter_screen.dart';

class OCBugReporterService {
  factory OCBugReporterService() {
    _instance ??= OCBugReporterService._internal();
    return _instance!;
  }
  OCBugReporterService._internal();
  final ScreenshotController screenshotController = ScreenshotController();
  bool _hasLoggerOpened = false;
  static OCBugReporterService? _instance;
  late final DeviceInformationRetrievalService _deviceInfoService;

  late final GlobalKey<NavigatorState>? _navigatorKey;
  late final String _listId;
  late final String _apiKey;

  void Function(bool flag)? showsReporter;

  Future<void> initService(
      {required GlobalKey<NavigatorState>? key,
      required String listId,
      required String apiKey}) async {
    _deviceInfoService = await DeviceInformationRetrievalServiceImpl.init();

    _navigatorKey = key;
    _listId = listId;
    _apiKey = apiKey;
    return Future.value();
  }

  BuildContext? getContext() => _navigatorKey?.currentState?.overlay?.context;

  void openLogger() {
    screenshotController.capture().then((image) async {
      if (getContext() != null) {
        _openLogger(image);
      }
    }).catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
  }

  void _openLogger(Uint8List? image) {
    if (_hasLoggerOpened) {
      return;
    }
    _hasLoggerOpened = true;
    showsReporter?.call(!_hasLoggerOpened);
    Navigator.push(
        getContext()!,
        OCBugReporterScreen.route(image, () {
          _hasLoggerOpened = false;
          showsReporter?.call(!_hasLoggerOpened);
        }));
  }

  Future<void> createLog(
      Uint8List? image, String title, String description) async {
    final apiUrl = 'https://api.clickup.com/api/v2/list/$_listId/task';
    try {
      final dio = Dio()..options.headers['Authorization'] = _apiKey;
      final deviceInformation =
          await _deviceInfoService.fetchDeviceInformation();
      final packageInformation =
          await _deviceInfoService.fetchPackageInformation();
      final detailedDescription =
          '''$description\n\nAppInformation:\nApp Name: ${packageInformation.appName}\nPackage Name: ${packageInformation.packageName}\nApp Version: ${packageInformation.versionName}\nBuild Number: ${packageInformation.buildNumber}\n\nDevice Information:\Device Version: ${deviceInformation.deviceVersion}\nModel: ${deviceInformation.model}\nDevice Platform:${deviceInformation.platform}''';
      final data = <String, dynamic>{
        'name': title,
        'description': detailedDescription,
        'tags': <String>[deviceInformation.platform]
      };

      final response = await dio.post(apiUrl, data: data);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final id = responseData['id'] as String;
        _uploadAttachement(image, id);
      } else {
        if (kDebugMode) {
          print('Task creation failed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _uploadAttachement(Uint8List? image, String taskId) {
    final apiUrl = 'https://api.clickup.com/api/v2/task/$taskId/attachment';
    try {
      final dio = Dio()..options.headers['Authorization'] = _apiKey;
      final formData = FormData.fromMap(<String, dynamic>{
        'attachment': MultipartFile.fromBytes(image!,
            filename: 'your_attachment_filename.png'),
      });

      dio.post(apiUrl, data: formData);
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
}
