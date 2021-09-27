part of 'connectivity_monitor_cubit.dart';

class ConnectivityMonitorState extends Equatable {

  const ConnectivityMonitorState({
    required this.connectivityStatus,
    required this.isInternetAvailable
  });

  
  final ConnectivityResult connectivityStatus;
  final bool isInternetAvailable;

  factory ConnectivityMonitorState.initial() {
    return ConnectivityMonitorState(
      connectivityStatus: ConnectivityResult.none,
      isInternetAvailable: false
    );
  }
  

  @override
  List<Object> get props => [connectivityStatus, isInternetAvailable];
}


