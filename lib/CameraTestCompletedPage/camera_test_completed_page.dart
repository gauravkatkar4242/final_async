import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CameraTestCompletedPage extends StatefulWidget {
  const CameraTestCompletedPage(this.videoURL, {Key? key}) : super(key: key);

  final String videoURL;

  @override
  _CameraTestCompletedPageState createState() =>
      _CameraTestCompletedPageState();
}

class _CameraTestCompletedPageState extends State<CameraTestCompletedPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(
          widget.videoURL),
    );  }


  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }

  // Future<void> _initVideoController() async {
  //   print("_initVideoController");
  //   // _videoPlayerController = VideoPlayerController.network(
  //   //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
  //   //   widget.videoURL)
  //   //   ..initialize().then((_) {
  //   //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //   //     setState(() {});
  //   //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: kIsWeb ? _webLayout() : _mobileLayout()),
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
              child: Stack(
                children: [
                  Center(
                    child:  FlickVideoPlayer(
                        flickManager: flickManager
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         _videoPlayerController.value.isPlaying
                  //             ? _videoPlayerController.pause()
                  //             : _videoPlayerController.play();
                  //       });
                  //     },
                  //     child: Icon(
                  //       _videoPlayerController.value.isPlaying
                  //           ? Icons.pause
                  //           : Icons.play_arrow,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
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
                child: Text(widget.videoURL),
              ),
            )
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrangeAccent,
            ), // set the background color
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Go Next "),
                Icon(Icons.arrow_forward, size: 15)
              ],
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                '/cameraTestPage',
              );
            },
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
                primary: Colors.deepOrangeAccent,
              ), // set the background color
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Go Next "),
                  Icon(Icons.arrow_forward, size: 15)
                ],
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  '/cameraTestPage',
                );
              },
            ),
          }
        ],
      ),
    );
  }
}
