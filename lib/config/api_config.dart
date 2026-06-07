class ApiConfig {
  // Android emülatör için: 10.0.2.2
  // iOS simülatör için: localhost
  // Fiziksel cihaz için: bilgisayarınızın LAN IP'si (örn: 192.168.1.100)
  static const String _host = '10.0.2.2';
  static const int _port = 3000;

  static const String baseUrl = 'http://$_host:$_port/api';

  // Endpoint'ler
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String me = '$baseUrl/auth/me';
  static const String pizzas = '$baseUrl/pizzas';
  static const String orders = '$baseUrl/orders';
  static const String profile = '$baseUrl/users/profile';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
