import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../models/pizza_model.dart';
import '../providers/cart_provider.dart';
import '../utils/helpers.dart';

/// Pizza detay ekranı
/// Pizza bilgileri, boyut seçimi, ekstra malzemeler ve sepete ekleme
class PizzaDetailScreen extends StatefulWidget {
  final PizzaModel pizza;
  const PizzaDetailScreen({super.key, required this.pizza});

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  String _selectedSize = 'Orta';
  int _quantity = 1;
  final List<String> _selectedExtras = [];

  final List<String> _availableExtras = [
    'Ekstra Peynir', 'Mantar', 'Zeytin', 'Mısır',
    'Soğan', 'Biber', 'Sucuk', 'Sosis',
  ];

  double get _currentPrice {
    double price = widget.pizza.getPriceBySize(_selectedSize);
    price += _selectedExtras.length * 5.0;
    return price * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Görsel app bar
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İsim ve puan
                  _buildNameRow(),
                  const SizedBox(height: 12),
                  // Açıklama
                  Text(widget.pizza.description,
                      style: TextStyle(fontSize: 15, color: AppColors.textSecondary.withOpacity(0.8), height: 1.5)),
                  const SizedBox(height: 24),
                  // Malzemeler
                  _buildIngredients(),
                  const SizedBox(height: 24),
                  // Boyut seçimi
                  _buildSizeSelector(),
                  const SizedBox(height: 24),
                  // Ekstra malzemeler
                  _buildExtras(),
                  const SizedBox(height: 24),
                  // Adet seçimi
                  _buildQuantitySelector(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Sepete ekle butonu
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'pizza_${widget.pizza.id}',
          child: CachedNetworkImage(
            imageUrl: widget.pizza.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: Colors.grey.shade100,
              child: const Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
            ),
            errorWidget: (_, __, ___) => Container(
              color: Colors.grey.shade100,
              child: const Icon(Icons.local_pizza, size: 80, color: AppColors.primaryRed),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameRow() {
    return Row(
      children: [
        Expanded(
          child: Text(widget.pizza.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentYellow.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: AppColors.accentYellow, size: 18),
              const SizedBox(width: 4),
              Text(widget.pizza.rating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(' (${widget.pizza.reviewCount})',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withOpacity(0.7))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Malzemeler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.pizza.ingredients.map((ing) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(ing, style: const TextStyle(color: AppColors.primaryRed, fontSize: 13, fontWeight: FontWeight.w500)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    final sizes = ['Küçük', 'Orta', 'Büyük', 'Ekstra Büyük'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Boyut Seçin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Row(
          children: sizes.map((size) {
            final isSelected = _selectedSize == size;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                    boxShadow: isSelected
                        ? [BoxShadow(color: AppColors.primaryRed.withOpacity(0.3), blurRadius: 8)]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(size,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(Helpers.formatPrice(widget.pizza.getPriceBySize(size)),
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : AppColors.textSecondary,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExtras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ekstra Malzemeler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text('Her biri +5,00 ₺', style: TextStyle(fontSize: 13, color: AppColors.textSecondary.withOpacity(0.7))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableExtras.map((extra) {
            final isSelected = _selectedExtras.contains(extra);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedExtras.remove(extra);
                  } else {
                    _selectedExtras.add(extra);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16),
                    if (isSelected) const SizedBox(width: 4),
                    Text(extra,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        )),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text('Adet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const Spacer(),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
          child: Row(
            children: [
              IconButton(
                onPressed: () { if (_quantity > 1) setState(() => _quantity--); },
                icon: const Icon(Icons.remove, color: AppColors.primaryRed),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$_quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: () => setState(() => _quantity++),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Toplam', style: TextStyle(fontSize: 13, color: AppColors.textSecondary.withOpacity(0.7))),
                Text(Helpers.formatPrice(_currentPrice),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<CartProvider>().addItem(
                    pizza: widget.pizza, size: _selectedSize,
                    quantity: _quantity, extras: _selectedExtras,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.pizza.name} sepete eklendi!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.primaryRed.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Sepete Ekle', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
