import 'package:final_async/CameraTestCompletedPage/camera_test_completed_page.dart';
import 'package:final_async/CameraTestPage/bloc/test_page_camera_bloc.dart';
import 'package:final_async/RecordResponsePage/bloc/record_response_page_camera_bloc.dart';
import 'package:final_async/RecordResponsePage/record_response_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CameraTestPage/camera_test_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/cameraTestPage':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<TestPageCameraBloc>(
                        create: (BuildContext context) => TestPageCameraBloc()),
                  ],
                  child: const CameraTestPage(),
                ));

      case '/cameraTestCompletedPage':
        return MaterialPageRoute(builder: (_) => CameraTestCompletedPage(args.toString()));

        case '/recordResponsePage':
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<RecordResponsePageCameraBloc>(
                  create: (BuildContext context) => RecordResponsePageCameraBloc()),
            ],
            child:  const RecordResponsePage()));


      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
