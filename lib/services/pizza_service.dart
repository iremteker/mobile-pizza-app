import '../models/pizza_model.dart';
import 'api_service.dart';

/// Pizza verilerini REST API'den çeken servis
class PizzaService {
  final ApiService _api = ApiService();

  Future<List<PizzaModel>> getAllPizzas() async {
    try {
      final res = await _api.get('/pizzas');
      if (res.data['success'] == true) {
        return (res.data['data'] as List).map((e) => PizzaModel.fromMap(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<PizzaModel>> getPizzasByCategory(String category) async {
    try {
      final res = await _api.get('/pizzas/category/$category');
      if (res.data['success'] == true) {
        return (res.data['data'] as List).map((e) => PizzaModel.fromMap(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<PizzaModel>> getPopularPizzas() async {
    try {
      final res = await _api.get('/pizzas/popular');
      if (res.data['success'] == true) {
        return (res.data['data'] as List).map((e) => PizzaModel.fromMap(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<PizzaModel?> getPizzaById(String id) async {
    try {
      final res = await _api.get('/pizzas/$id');
      if (res.data['success'] == true) {
        return PizzaModel.fromMap(res.data['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<PizzaModel>> searchPizzas(String query) async {
    try {
      final res = await _api.get('/pizzas/search', queryParams: {'q': query});
      if (res.data['success'] == true) {
        return (res.data['data'] as List).map((e) => PizzaModel.fromMap(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
