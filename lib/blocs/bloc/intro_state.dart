part of 'intro_bloc.dart';

class IntroState extends Equatable {
  final bool firstRun;

  const IntroState(this.firstRun);

  @override
  List<Object> get props => [firstRun];
}
