import 'package:maestro_api/maestro_api.dart';
import '../models/models.dart';

class UserRestProvider {
  UserRestProvider(this._authApi);
  final AuthApi _authApi;

  Future<User?> getUserData() async {
    final response = await _authApi.userDetailsAuthUserDetailsGet();
    if (response.data?.phone == null) return null;
    return User(
      phone: response.data?.phone ?? '',
      email: response.data?.email ?? '',
      firstName: response.data?.firstName ?? '',
      lastName: response.data?.lastName ?? '',
    );
  }
}
