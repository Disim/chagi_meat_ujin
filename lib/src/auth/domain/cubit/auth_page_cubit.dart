import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_page_state.dart';

class AuthPageCubit extends Cubit<AuthPageState> {
  AuthPageCubit() : super(AuthPageInitial());

  void login(String username, String password) {
    emit(AuthPageLoading());
    // Simulate a network call
    Future.delayed(const Duration(seconds: 2), () {
      if (username == 'admin' && password == 'password') {
        emit(const AuthPageSuccess('Login successful'));
      } else {
        emit(const AuthPageError('Invalid credentials'));
      }
    });
  }
}
