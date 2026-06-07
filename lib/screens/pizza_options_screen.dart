import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/pizza_provider.dart';
import '../widgets/pizza_card.dart';

/// Pizza seçenekleri ekranı
/// Kategoriye göre filtrelenmiş pizza listesi
class PizzaOptionsScreen extends StatelessWidget {
  const PizzaOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'Pizza Menüsü 🍕',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Text(
              'Size en uygun pizzayı seçin',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
          // Kategori filtreleri
          _buildCategoryFilters(),
          const SizedBox(height: 16),
          // Pizza listesi
          Expanded(child: _buildPizzaList()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Consumer<PizzaProvider>(
      builder: (context, pizzaProvider, child) {
        return SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pizzaProvider.categories.length,
            itemBuilder: (context, index) {
              final cat = pizzaProvider.categories[index];
              final isSelected = cat == pizzaProvider.selectedCategory;
              return GestureDetector(
                onTap: () => pizzaProvider.filterByCategory(cat),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPizzaList() {
    return Consumer<PizzaProvider>(
      builder: (context, pizzaProvider, child) {
        if (pizzaProvider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
        }
        final pizzas = pizzaProvider.filteredPizzas;
        if (pizzas.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_pizza_outlined, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text('Bu kategoride pizza bulunamadı', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.68,
          ),
          itemCount: pizzas.length,
          itemBuilder: (context, index) => PizzaCard(pizza: pizzas[index]),
        );
      },
    );
  }
}
