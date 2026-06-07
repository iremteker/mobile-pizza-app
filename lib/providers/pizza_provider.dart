import 'package:flutter/material.dart';
import '../models/pizza_model.dart';
import '../services/pizza_service.dart';

/// Pizza listesini ve filtrelemeyi yöneten Provider
class PizzaProvider extends ChangeNotifier {
  final PizzaService _pizzaService = PizzaService();

  List<PizzaModel> _allPizzas = [];
  List<PizzaModel> _filteredPizzas = [];
  List<PizzaModel> _popularPizzas = [];
  bool _isLoading = false;
  String _selectedCategory = 'Tümü';
  String _searchQuery = '';

  List<PizzaModel> get allPizzas => _allPizzas;
  List<PizzaModel> get filteredPizzas => _filteredPizzas;
  List<PizzaModel> get popularPizzas => _popularPizzas;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<String> get categories => [
        'Tümü', 'Klasik', 'Özel', 'Vejetaryen', 'Etli', 'Tavuklu', 'Deniz Ürünleri',
      ];

  Future<void> loadPizzas() async {
    _isLoading = true;
    notifyListeners();

    _allPizzas = await _pizzaService.getAllPizzas();
    _filteredPizzas = List.from(_allPizzas);
    _popularPizzas = _allPizzas.where((p) => p.isPopular).toList();

    _isLoading = false;
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void searchPizzas(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    List<PizzaModel> result = List.from(_allPizzas);

    if (_selectedCategory != 'Tümü') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q)).toList();
    }

    _filteredPizzas = result;
    notifyListeners();
  }
}
