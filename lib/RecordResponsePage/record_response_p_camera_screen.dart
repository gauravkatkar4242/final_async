import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:final_async/RecordResponsePage/bloc/record_response_page_camera_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordResponsePageCameraScreen extends StatefulWidget {
  const RecordResponsePageCameraScreen({Key? key}) : super(key: key);

  @override
  _RecordResponsePageCameraScreenState createState() =>
      _RecordResponsePageCameraScreenState();
}

class _RecordResponsePageCameraScreenState
    extends State<RecordResponsePageCameraScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecordResponsePageCameraBloc,
        RecordResponsePageCameraState>(listener: (context, state) {
      // print("***************" + state.toString());
      if (state is RecordingCompletedState) {
        // Navigator.of(context).pushReplacementNamed('/cameraTestCompletedPage',
        //     arguments: "hello");
        // context.read<RecordResponsePageCameraBloc>().add(DisposeCameraEvent()); // need to dispose camera when only PUSH NAMED used
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
      } else if (state is PreRecordingState) {
        return Stack(
          children: [
            _cameraView(state),
            /* for Timer before Starting Rec👇 */
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Recording Starts in ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    state.timeRemaining.toString(),
                    style: const TextStyle(
                      fontSize: 75,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ],
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
                        .read<RecordResponsePageCameraBloc>()
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
      } else if (state is VideoUploadInProgressState) {
        return Stack(
          children: [
            _cameraView(state),
            /* for Upload status 👇 */
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 10),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Uploading your Response",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(width: 500, child: LinearProgressIndicator()),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Progress: 87%",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Time Remaining: 30 sec",
                        style: TextStyle(color: Colors.white, fontSize: 15))
                  ],
                ),
              ),
            ),
          ],
        );
      } else if (state is VideoUploadSuccessfulState) {
        return Stack(
          children: [
            _cameraView(state),
            /* for Upload status 👇 */
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 10),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Response Uploaded!",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10,),

                    const Text(
                      "Go to the next question",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(height: 10,),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrangeAccent,
                      ), // set the background color
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("Next Question "),
                          Icon(Icons.arrow_forward, size: 15)
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          '/cameraTestPage',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        return const Text("Something went Wrong");
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
