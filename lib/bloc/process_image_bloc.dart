import 'package:bloc/bloc.dart';

import 'process_image_event.dart';
import 'process_image_state.dart';

class ProcessImageBloc extends Bloc<ProcessImageEvent, ProcessImageState> {
  ProcessImageBloc() : super(ProcessImageInitial()) {
    on<ProcessImageEvent>(_onImageProcess);
  }

  void _onImageProcess(ProcessImageEvent event, Emitter<ProcessImageState> emit){
    emit(ProcessStatus(event.isProcessing));
  }
}
