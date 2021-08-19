part of 'intro_bloc.dart';

class IntroEvent extends Equatable {
  final bool firstRun;

  const IntroEvent(this.firstRun);

  @override
  List<Object> get props => [firstRun];
}
