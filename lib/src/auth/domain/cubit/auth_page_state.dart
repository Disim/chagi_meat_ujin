part of 'auth_page_cubit.dart';

sealed class AuthPageState extends Equatable {
  const AuthPageState();

  @override
  List<Object> get props => [];
}

final class AuthPageInitial extends AuthPageState {
  const AuthPageInitial();

  @override
  List<Object> get props => [];
}

final class AuthPageLoading extends AuthPageState {}

final class AuthPageSuccess extends AuthPageState {
  final String message;

  const AuthPageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthPageError extends AuthPageState {
  final String error;

  const AuthPageError(this.error);

  @override
  List<Object> get props => [error];
}
