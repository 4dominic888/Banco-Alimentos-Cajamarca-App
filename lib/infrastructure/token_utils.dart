import 'dart:io';

import 'package:bancalcaj_app/data/backend/express_backend.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenUtils{

  static final _prefs = GetIt.I<SharedPreferences>();

  static String? get accessToken => _prefs.getString('token');
  static String? get refreshToken => _prefs.getString('refreshToken');
  
  /// Retorna el estado del refresco, si se refresco o no
  static Future<void> refreshingToken() async {
    if(accessToken == null || !isTokenExpired(accessToken!)) return;
    if(refreshToken == null || !isTokenExpired(refreshToken!)) {
      cleanTokens();
      throw const HttpException('Debe iniciar sesion nuevamente para refrescar su sesion');
    }

    final response = await ExpressBackend.solicitude('employee/refresh-token',
      RequestType.post,
      body: { 'refreshToken': refreshToken }
    );

    if(response['message'] != null) throw HttpException(response['message']);

    await TokenUtils.setTokens(response);
    return;
  }

  static bool isTokenExpired(String token) {
    if (token.isEmpty) return true;

    try {
      final decodedToken = JwtDecoder.decode(token);
      final expiration = decodedToken['exp'];

      if (expiration == null) return true;

      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;

      return expiration < currentTime;
    } catch (e) { return true; }
  }

  static Future<void> setTokens(Map<String, dynamic> container) async {     

    if(container['token'] != null) {
      await _prefs.setString('token', container['token']);
    }

    if(container['refreshToken'] != null){
      await _prefs.setString('refreshToken', container['refreshToken']);
    }
  }

  static Future<void> cleanTokens() async{
    await _prefs.remove('token');
    await _prefs.remove('refreshToken');
  }
}
