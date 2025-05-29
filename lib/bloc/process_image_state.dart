
class ProcessImageState {}

class ProcessImageInitial extends ProcessImageState {}

class ProcessStatus extends ProcessImageState{
  final bool isProcessing;

  ProcessStatus(this.isProcessing);
}
