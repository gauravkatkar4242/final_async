part of 'record_response_page_camera_bloc.dart';

abstract class RecordResponsePageCameraState extends Equatable {
  const RecordResponsePageCameraState();
  @override
  List<Object> get props => [];
}

class RecordResponsePageCameraInitial extends RecordResponsePageCameraState {}

class CameraInitializingState extends RecordResponsePageCameraState{

  final CameraController? _controller;
  const CameraInitializingState(this._controller);
}
class PreRecordingState extends RecordResponsePageCameraState{
  final CameraController? controller;
  final int timeRemaining;
  const PreRecordingState(this.controller, this.timeRemaining);
  @override
  List<Object> get props => [timeRemaining];
}
class RecordingInProgressState extends RecordResponsePageCameraState{
  final CameraController? controller;
  final int timeRemaining;
  const RecordingInProgressState(this.controller, this.timeRemaining);
  @override
  List<Object> get props => [timeRemaining];
}
class RecordingCompletedState extends RecordResponsePageCameraState{}

class VideoUploadInProgressState extends RecordResponsePageCameraState{
  final CameraController? controller;
  const VideoUploadInProgressState(this.controller);
}
class VideoUploadSuccessfulState extends RecordResponsePageCameraState{
  final CameraController? controller;
  const VideoUploadSuccessfulState(this.controller);
}
class VideoUploadFailedState extends RecordResponsePageCameraState{}

class CameraExceptionState extends RecordResponsePageCameraState{
  final String errorMsg;
  const CameraExceptionState(this.errorMsg);
}
class CameraDisposedState extends RecordResponsePageCameraState{}

