import 'package:camera/camera.dart';
import 'package:final_async/CameraTestPage/bloc/test_page_camera_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestPageCameraScreen extends StatefulWidget {
  const TestPageCameraScreen({Key? key}) : super(key: key);

  @override
  _TestPageCameraScreenState createState() => _TestPageCameraScreenState();
}

class _TestPageCameraScreenState extends State<TestPageCameraScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestPageCameraBloc, TestPageCameraState>(
        listener: (context, state) async {
      // print("***************" + state.toString());
      if (state is RecordingCompletedState) {
        await Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pushReplacementNamed('/cameraTestCompletedPage',
              arguments: state.videoURL);
        });
        // context.read<CameraTestingBloc>().add(DisposeCameraEvent()); // need to dispose camera if only PUSH NAMED used

      }
    }, builder: (context, state) {
      if (state is CameraInitializingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is CameraExceptionState) {
        return Center(
          child: Text(state.errorMsg),
        );
      } else if (state is CameraReadyState) {
        return Stack(
          children: [
            _cameraView(state),
            /* for Start recording Button 👇*/
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepOrangeAccent),
                            elevation: MaterialStateProperty.all(5.0)),
                        onPressed: () => context
                            .read<TestPageCameraBloc>()
                            .add(StartRecordingEvent()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Start Recording",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.not_started_outlined)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      } else if (state is RecordingInProgressState) {
        return Stack(
          children: [
            _cameraView(state),
            /* for Stop recording Button 👇*/
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: FittedBox(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all(5.0)),
                    onPressed: () => context
                        .read<TestPageCameraBloc>()
                        .add(StopRecordingEvent()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Stop Recoding",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.stop_circle_outlined)
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /* for recording inProgress Icon 👇 */
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 8),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 16.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
                        child: const Text(
                          "REC",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            /* for timer 👇 */
            Align(
              alignment: Alignment.topRight,
              child: FittedBox(
                  child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      child: Text(
                        "${((state.timeRemaining / 60).round()).toString().padLeft(2, '0')} : ${(state.timeRemaining % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )),
            )
          ],
        );
      } else {
        return Text("None");
      }
    });
  }

  Widget _cameraView(state) {
    return LayoutBuilder(builder: (context, constraints) {
      return kIsWeb
          /* for camera screen web  👇*/
          ? AspectRatio(
              aspectRatio: (constraints.maxWidth / constraints.maxHeight),
              child: CameraPreview(state.controller!))

          /* for camera screen mobile 👇*/
          : Transform.scale(
              scale: 1 /
                  (state.controller!.value.aspectRatio *
                      (constraints.maxWidth / constraints.maxHeight)),
              alignment: Alignment.topCenter,
              child: CameraPreview(state.controller!),
            );
    });
  }
}
