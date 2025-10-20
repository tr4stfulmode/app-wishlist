import 'package:flutter/material.dart';
import 'package:app_wishlist/models/wish_item.dart';
import 'package:app_wishlist/widgets/wish_item_card.dart';
import 'package:app_wishlist/widgets/add_wish_form.dart';
import 'package:app_wishlist/services/auth_service.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final List<WishItem> _wishItems = [
    WishItem(
      id: '1',
      title: 'Наушнички',
      description: 'Noise cancelling over-ear headphones with premium sound quality',
      price: 299.99,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      priority: 5,
      createdAt: DateTime.now(),
    ),
    WishItem(
      id: '2',
      title: 'Smart Watch',
      description: 'Fitness tracking and smart notifications',
      price: 199.99,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      priority: 4,
      createdAt: DateTime.now(),
    ),
    WishItem(
      id: '3',
      title: 'Designer Backpack',
      description: 'Waterproof laptop backpack with multiple compartments',
      price: 149.99,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
      priority: 3,
      createdAt: DateTime.now(),
    ),
  ];

  final AuthService _authService = AuthService();

  void _addNewWish() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Добавить новое желание',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: AddWishForm(
          onWishAdded: _addWishItem,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Форма сама закроется после успешного добавления
            },
            child: Text(
              'Добавить',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addWishItem(WishItem newWish) {
    setState(() {
      _wishItems.insert(0, newWish); // Добавляем в начало списка
    });

    // Показываем уведомление об успешном добавлении
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '«${newWish.title}» добавлен в вишлист!',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _togglePurchased(String id) {
    setState(() {
      final index = _wishItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _wishItems[index].isPurchased = !_wishItems[index].isPurchased;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _wishItems[index].isPurchased
                  ? '«${_wishItems[index].title}» отмечен как купленный!'
                  : '«${_wishItems[index].title}» удален из купленных',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: _wishItems[index].isPurchased ? Colors.green : Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _deleteWishItem(String id) {
    final index = _wishItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final deletedItem = _wishItems[index];

      setState(() {
        _wishItems.removeAt(index);
      });

      // Показываем уведомление с возможностью отмены
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '«${deletedItem.title}» удален',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Отменить',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _wishItems.insert(index, deletedItem);
              });
            },
          ),
        ),
      );
    }
  }

  void _logout() async {
    await _authService.signOut();
  }

  double get _totalPrice {
    return _wishItems.fold(0.0, (sum, item) => sum + item.price);
  }

  int get _purchasedCount {
    return _wishItems.where((item) => item.isPurchased).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Мой Вишлист',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: Column(
        children: [
          // Статистика
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Ваши желания',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_wishItems.length} предметов • ₽${_totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                if (_purchasedCount > 0)
                  Text(
                    'Куплено: $_purchasedCount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),

          // Список желаний
          Expanded(
            child: _wishItems.isEmpty
                ? const _EmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _wishItems.length,
              itemBuilder: (context, index) {
                final item = _wishItems[index];
                return WishItemCard(
                  item: item,
                  onTap: () => _togglePurchased(item.id),
                  onDelete: () => _deleteWishItem(item.id),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewWish,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

// Виджет для пустого состояния
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Ваш вишлист пуст',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Нажмите + чтобы добавить первое желание',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}