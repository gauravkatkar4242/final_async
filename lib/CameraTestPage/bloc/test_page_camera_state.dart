part of 'test_page_camera_bloc.dart';

abstract class TestPageCameraState extends Equatable {
  const TestPageCameraState();
  @override
  List<Object> get props => [];
}

class TestPageCameraInitial extends TestPageCameraState {
  @override
  List<Object> get props => [];
}

class CameraInitializingState extends TestPageCameraState{
  final CameraController? controller;
  const CameraInitializingState(this.controller);

}

class CameraReadyState extends TestPageCameraState{
  final CameraController? controller;
  const CameraReadyState(this.controller);

}

class RecordingInProgressState extends TestPageCameraState{
  final CameraController? controller;
  final int timeRemaining;
  const RecordingInProgressState(this.controller, this.timeRemaining);
  @override
  List<Object> get props => [timeRemaining];
}


class RecordingCompletedState extends TestPageCameraState{
  final String videoURL;
  const RecordingCompletedState(this.videoURL);
}

class CameraExceptionState extends TestPageCameraState{
  final String errorMsg;
  const CameraExceptionState(this.errorMsg);
}

class CameraDisposedState extends TestPageCameraState{}