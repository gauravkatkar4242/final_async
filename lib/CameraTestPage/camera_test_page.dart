import 'package:final_async/CameraTestPage/bloc/test_page_camera_bloc.dart';
import 'package:final_async/CameraTestPage/test_p_camera_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';

class CameraTestPage extends StatefulWidget {
  const CameraTestPage({Key? key}) : super(key: key);
  @override
  _CameraTestPageState createState() => _CameraTestPageState();
}

class _CameraTestPageState extends State<CameraTestPage>
    with WidgetsBindingObserver {
  late TestPageCameraBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = context.read<TestPageCameraBloc>();
    bloc.add(InitCameraEvent());
    WidgetsBinding.instance!.addObserver(this);
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      context
          .read<TestPageCameraBloc>()
          .add(DisposeCameraEvent()); // Free up memory when camera not active
    } else if (state == AppLifecycleState.resumed) {
      context.read<TestPageCameraBloc>().add(
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
    return Scaffold(
      // appBar: kIsWeb? AppBar(title: const Text("JOMBAY.....")):,
      body: SafeArea(
        child: kIsWeb ? _webLayout() : _mobileLayout(),
      ),
    );
  }

  Widget _webLayout() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 51),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: constraints.maxHeight * 0.7,
              width: constraints.maxWidth * 0.55,
              color: Colors.red,
              child: const TestPageCameraScreen(),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: constraints.maxHeight * 0.7,
                width: constraints.maxWidth * 0.35,
                child: _textContent(),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _mobileLayout() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: _textContent(),
            ),
            Expanded(
              child: Container(
                  width: constraints.maxWidth * 0.95,
                  color: Colors.redAccent,
                  child: const TestPageCameraScreen()),
            ),
          ],
        ),
      );
    });
  }

  Widget _textContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Test your camera & microphone',
            style: TextStyle(
              fontSize: kIsWeb ? 18 : 14,
              color: kIsWeb ? Colors.black : Colors.white,
              fontWeight: kIsWeb ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Speak this phrase out loud while recording the practice video: “Two blue fish swam in the tank.",
            style: TextStyle(
              color: kIsWeb ? Colors.black : Colors.white,
              fontWeight: kIsWeb ? FontWeight.normal : FontWeight.bold,
              fontSize: kIsWeb ? 16 : 16,
            ),
          ),
          if (kIsWeb) ...{
            const Divider(
              color: Colors.black54,
              thickness: 0.5,
              height: 20,
            ),
            const Text(
              "You must test your video and audio by recording a practice video before moving ahead",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
            const SizedBox(
              height: kIsWeb ? 20 : 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white10,
              ), // set the background color
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Go Next "),
                  Icon(Icons.arrow_forward, size: 15)
                ],
              ),
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed(
                //   '/nextPage',
                // );
              },
            ),
          }
        ],
      ),
    );
  }
}
