part of 'loading_hud_cubit.dart';

abstract class LoadingHudState extends Equatable {
  const LoadingHudState();
}

class LoadingHudInitial extends LoadingHudState {
  @override
  List<Object> get props => [];
}

class ShowError extends LoadingHudState {
  final String message;

  const ShowError(this.message);

  @override
  List<Object?> get props => [message];
}

class DismissLoadingHud extends LoadingHudState {
  @override
  List<Object?> get props => [];
}
