part of 'record_response_page_camera_bloc.dart';

abstract class RecordResponsePageCameraEvent extends Equatable {
  const RecordResponsePageCameraEvent();
  @override
  List<Object?> get props => [];
}

class InitCameraEvent extends RecordResponsePageCameraEvent{}

class StartPrerecordingTimerEvent extends RecordResponsePageCameraEvent{}

class PreRecordingTimerTickedEvent extends RecordResponsePageCameraEvent{
  final int duration;
  const PreRecordingTimerTickedEvent({required this.duration});
}
class StartRecordingEvent extends RecordResponsePageCameraEvent{}

class StopRecordingEvent extends RecordResponsePageCameraEvent{}

class TimerTickedEvent extends RecordResponsePageCameraEvent{
  final int duration;
  const TimerTickedEvent({required this.duration});
}

class UploadVideoEvent extends RecordResponsePageCameraState{}

class DisposeCameraEvent extends RecordResponsePageCameraEvent{}