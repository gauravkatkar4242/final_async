import 'package:final_async/RecordResponsePage/bloc/record_response_page_camera_bloc.dart';
import 'package:final_async/RecordResponsePage/record_response_p_camera_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class RecordResponsePage extends StatefulWidget {
  const RecordResponsePage({Key? key}) : super(key: key);

  @override
  _RecordResponsePageState createState() => _RecordResponsePageState();
}

class _RecordResponsePageState extends State<RecordResponsePage>
    with WidgetsBindingObserver {
  late RecordResponsePageCameraBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = context.read<RecordResponsePageCameraBloc>();
    bloc.add(InitCameraEvent());
    WidgetsBinding.instance!.addObserver(this);
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      context
          .read<RecordResponsePageCameraBloc>()
          .add(DisposeCameraEvent()); // Free up memory when camera not active
    } else if (state == AppLifecycleState.resumed) {
      context.read<RecordResponsePageCameraBloc>().add(
          InitCameraEvent()); // Reinitialize the camera with same properties
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    bloc.add(DisposeCameraEvent());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: kIsWeb ? _webLayout() : _mobileLayout()));
  }

  Widget _webLayout() {
    return LayoutBuilder(builder: (context, constraints){
      return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.7,
              width: constraints.maxWidth * 0.7,
              color: Colors.red,
              child: const RecordResponsePageCameraScreen(),
            ),
            Container(
              height: constraints.maxHeight * 0.2,
              width: constraints.maxWidth * 0.7,
              color: Colors.blueGrey,
            )
          ],
        ),
      );
    });
  }

  Widget _mobileLayout(){
    return LayoutBuilder(builder: (context, constraints){
      return Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.8,
              color: Colors.red,
              child: const RecordResponsePageCameraScreen(),
            ),
            Container(
              height: constraints.maxHeight * 0.2,
              color: Colors.blueGrey,
            )
          ],
        ),
      );
    });
  }
}
