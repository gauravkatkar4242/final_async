part of 'test_page_camera_bloc.dart';

abstract class TestPageCameraEvent extends Equatable {
  const TestPageCameraEvent();
  @override
  List<Object?> get props => [];
}

class InitCameraEvent extends TestPageCameraEvent{}

class StartRecordingEvent extends TestPageCameraEvent{}

class StopRecordingEvent extends TestPageCameraEvent{}

class TimerTickedEvent extends TestPageCameraEvent{
  final int duration;
  const TimerTickedEvent({required this.duration});
}

class DisposeCameraEvent extends TestPageCameraEvent{}