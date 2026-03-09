import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color _primary = Color(0xFFFF6B35);
  static const Color _darkText = Color(0xFF1A1A2E);
  static const Color _subtle = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          // === EMPTY STATE ===
          if (cartProvider.items.isEmpty) {
            return CustomScrollView(
              slivers: [
                _buildAppBar(0),
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 48,
                              color: _primary.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Giỏ hàng trống',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _darkText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Hãy thêm các món ăn yêu thích\nđể tiếp tục',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: _subtle,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // === HAS ITEMS ===
          return Column(
            children: [
              // ---- HEADER + ITEMS (scrollable) ----
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(cartProvider.totalItems),

                    // Item count badge
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${cartProvider.totalItems} sản phẩm',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                _showClearCartDialog(context, cartProvider);
                              },
                              child: Text(
                                'Xóa tất cả',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Cart items
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = cartProvider.items[index];
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onDismissed: (_) {
                              cartProvider.removeItem(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item.food.image,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: _primary.withValues(
                                              alpha: 0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.fastfood_rounded,
                                            color: _primary.withValues(
                                              alpha: 0.3,
                                            ),
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Name + price + controls
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.food.name,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: _darkText,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatPrice(item.food.price),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: _primary,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Quantity controls
                                          Row(
                                            children: [
                                              _buildQtyButton(
                                                icon: Icons.remove_rounded,
                                                onTap: () {
                                                  if (item.quantity > 1) {
                                                    cartProvider.updateQuantity(
                                                      index,
                                                      item.quantity - 1,
                                                    );
                                                  } else {
                                                    cartProvider.removeItem(
                                                      index,
                                                    );
                                                  }
                                                },
                                                color: _subtle,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                    ),
                                                child: Text(
                                                  item.quantity.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16,
                                                    color: _darkText,
                                                  ),
                                                ),
                                              ),
                                              _buildQtyButton(
                                                icon: Icons.add_rounded,
                                                onTap: () {
                                                  cartProvider.updateQuantity(
                                                    index,
                                                    item.quantity + 1,
                                                  );
                                                },
                                                color: _primary,
                                                filled: true,
                                              ),
                                              const Spacer(),
                                              // Total per item
                                              Text(
                                                _formatPrice(item.totalPrice),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: _darkText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }, childCount: cartProvider.items.length),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ],
                ),
              ),

              // ---- BOTTOM SUMMARY ----
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag indicator
                        Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Subtotal
                        _buildSummaryRow(
                          'Tạm tính',
                          _formatPrice(cartProvider.subtotal),
                        ),
                        const SizedBox(height: 10),
                        // Tax
                        _buildSummaryRow(
                          'Thuế (10%)',
                          _formatPrice(cartProvider.tax),
                        ),
                        const SizedBox(height: 10),
                        // Delivery
                        _buildSummaryRow(
                          'Phí giao hàng',
                          cartProvider.subtotal > 100000
                              ? 'Miễn phí'
                              : _formatPrice(cartProvider.deliveryFee),
                          valueColor: cartProvider.subtotal > 100000
                              ? const Color(0xFF2EC4B6)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Divider(
                            color: Colors.grey.shade200,
                            thickness: 1,
                          ),
                        ),
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng cộng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _darkText,
                              ),
                            ),
                            Text(
                              _formatPrice(cartProvider.total),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: _primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // Checkout button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: _primary.withValues(alpha: 0.4),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.payment_rounded, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'Thanh Toán',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // === APP BAR ===
  SliverAppBar _buildAppBar(int count) {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      elevation: 0,
      backgroundColor: _primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              16 + MediaQuery.of(context).padding.top,
              24,
              16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Giỏ Hàng',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === QTY BUTTON ===
  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? color : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 18, color: filled ? Colors.white : color),
      ),
    );
  }

  // === SUMMARY ROW ===
  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: _subtle,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? _darkText,
          ),
        ),
      ],
    );
  }

  // === FORMAT PRICE ===
  String _formatPrice(double price) {
    final intPrice = price.toInt();
    final formatted = intPrice.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
    return '$formatted đ';
  }

  // === CLEAR CART DIALOG ===
  void _showClearCartDialog(BuildContext context, CartProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Xóa giỏ hàng?',
          style: TextStyle(fontWeight: FontWeight.w700, color: _darkText),
        ),
        content: const Text(
          'Bạn có chắc muốn xóa tất cả món ăn trong giỏ hàng?',
          style: TextStyle(color: _subtle),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            onPressed: () {
              provider.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
  }
}
