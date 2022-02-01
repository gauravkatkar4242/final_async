import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:final_async/timer.dart';
import 'package:flutter/cupertino.dart';

part 'test_page_camera_event.dart';

part 'test_page_camera_state.dart';

class TestPageCameraBloc
    extends Bloc<TestPageCameraEvent, TestPageCameraState> {
  CameraController? _controller;
  final Timer _timer = const Timer();
  StreamSubscription<int>? _timerSubscription;

  int totalRecordingTime = 10;

  TestPageCameraBloc() : super(TestPageCameraInitial()) {
    on<InitCameraEvent>(_initCamera);
    on<StartRecordingEvent>(_startRecording);
    on<TimerTickedEvent>(_onTimerTicked);
    on<StopRecordingEvent>(_getRecording);
    on<DisposeCameraEvent>(_disposeCamera);
  }

  Future<void> _initCamera(InitCameraEvent event, Emitter<TestPageCameraState> emit) async {
    debugPrint("--- Event :- _initCamera :: Current State :- $state");
    emit(const CameraInitializingState(null));
    try {
      var cameraList =
          await availableCameras(); // gets all available cameras from device

      if (_controller != null) {
        _timerSubscription?.cancel();
        await _controller!.dispose();
      }
      CameraDescription cameraDescription;
      if (cameraList.length == 1) {
        cameraDescription = cameraList[0]; // for desktop
      } else {
        cameraDescription = cameraList[1]; // for mobile select front camera
      }

      final CameraController cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.medium,
        enableAudio: true,
      );
      _controller = cameraController;
      if (cameraController.value.hasError) {
        emit(CameraExceptionState(
            cameraController.value.errorDescription.toString()));
      }
      await cameraController.initialize();
      emit(CameraReadyState(cameraController));
    } on CameraException catch (e) {
      emit(CameraExceptionState(e.description.toString()));
    }
  }

  Future<void> _startRecording(StartRecordingEvent event, Emitter<TestPageCameraState> emit) async {
    debugPrint("--- Event :- _startRecording :: CurrentState :- $state");
    if (_controller == null || _controller!.value.isRecordingVideo) {
      return;
    }
    try {
      await _controller?.startVideoRecording();
      emit(RecordingInProgressState(_controller, totalRecordingTime));
      _timerSubscription?.cancel();
      _timerSubscription = _timer
          .countDownTimer(timeRemaining: totalRecordingTime)
          .listen((duration) => add(TimerTickedEvent(duration: duration)));
    } on CameraException catch (e) {
      //will set state to CameraExceptionState state
      emit(CameraExceptionState(e.description.toString()));
    }
  }

  void _onTimerTicked(TimerTickedEvent event, Emitter<TestPageCameraState> emit) {
    debugPrint("_timerTicked ${event.duration}");
    if (event.duration == 0) {
      add(StopRecordingEvent());
    } else {
      emit(RecordingInProgressState(_controller, event.duration));
      debugPrint(state.toString());
    }
  }

  Future<void> _getRecording(StopRecordingEvent event, Emitter<TestPageCameraState> emit) async {
    XFile? file = await _stopRecording();
    if (file == null) {
      // emit(const CameraExceptionState("Issue in recorded video. Please try again"));
      return;
    }


    // file.saveTo("path");

    emit(RecordingCompletedState(file.path));

    emit(CameraReadyState(_controller));
  }

  Future<XFile?> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) {
      emit(const CameraExceptionState("Issue in recorded video. Please try again"));
      return null;
    }
    try {
      XFile file = await _controller!.stopVideoRecording();
      _timerSubscription?.cancel();
      debugPrint("--- Event :- _stoppedRecording :: CurrentState :- $state");
      return file;
    } on CameraException catch (e) {
      //will set state to CameraExceptionState state
      emit(CameraExceptionState(e.description.toString()));
      return null;
    }
  }

  Future<void> _disposeCamera(DisposeCameraEvent event, Emitter<TestPageCameraState> emit) async {
    debugPrint("--- Event :- _disposeCamera :: CurrentState :- $state");
    emit(CameraDisposedState());
    if (_controller != null) {
      await _controller?.dispose();
    debugPrint("Camera Disposed");
  }
    _timerSubscription?.cancel();
  }
}
