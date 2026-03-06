import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedPaymentMethod = 'cash';

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              expandedHeight: 80,
              backgroundColor: Colors.orange.shade600,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.orange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      16 + MediaQuery.of(context).padding.top,
                      20,
                      16,
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Thanh Toán',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Section
                    _SectionTitle(title: 'Địa Chỉ Nhận Hàng'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _addressController,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Nhập địa chỉ giao hàng',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.orange.shade600,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Payment Method Section
                    _SectionTitle(title: 'Phương Thức Thanh Toán'),
                    const SizedBox(height: 12),
                    ..._buildPaymentMethods(),
                    const SizedBox(height: 20),
                    // Special Notes
                    _SectionTitle(title: 'Ghi Chú (Tùy Chọn)'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Thêm ghi chú cho đơn hàng...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Order Summary Section
                    _SectionTitle(title: 'Chi Tiết Đơn Hàng'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...cartProvider.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.food.name} x ${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${(item.totalPrice.toInt() ~/ 1000)} k',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Price Breakdown
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _PriceSummaryRow(
                            label: 'Tạm tính',
                            value:
                                '${(cartProvider.subtotal.toInt() ~/ 1000)} k đ',
                          ),
                          const SizedBox(height: 12),
                          _PriceSummaryRow(
                            label: 'Thuế (10%)',
                            value: '${(cartProvider.tax.toInt() ~/ 1000)} k đ',
                          ),
                          const SizedBox(height: 12),
                          _PriceSummaryRow(
                            label: 'Phí giao hàng',
                            value: cartProvider.subtotal > 100
                                ? 'Miễn phí'
                                : '${(cartProvider.deliveryFee.toInt() ~/ 1000)} k đ',
                            valueColor: cartProvider.subtotal > 100
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const Divider(height: 16, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng cộng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${(cartProvider.total.toInt() ~/ 1000)} k đ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                          shadowColor: Colors.orange.shade200,
                        ),
                        onPressed: () async {
                          if (_addressController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Vui lòng nhập địa chỉ giao hàng',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final order = OrderModel(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            userId: authProvider.user!.id,
                            items: cartProvider.items,
                            subtotal: cartProvider.subtotal,
                            deliveryFee: cartProvider.deliveryFee,
                            tax: cartProvider.tax,
                            total: cartProvider.total,
                            deliveryAddress: _addressController.text,
                            paymentMethod: _selectedPaymentMethod,
                            status: OrderStatus.pending,
                            orderDate: DateTime.now(),
                            estimatedDelivery: DateTime.now().add(
                              const Duration(minutes: 45),
                            ),
                            notes: _notesController.text,
                          );

                          final orderProvider = Provider.of<OrderProvider>(
                            context,
                            listen: false,
                          );
                          final success = await orderProvider.createOrder(
                            order,
                          );

                          if (success && mounted) {
                            cartProvider.clearCart();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Đặt hàng thành công! 🎉'),
                              ),
                            );

                            Future.delayed(
                              const Duration(milliseconds: 1500),
                              () {
                                if (mounted) {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/home');
                                }
                              },
                            );
                          }
                        },
                        child: const Text(
                          'Xác Nhận Đặt Hàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPaymentMethods() {
    return [
      _PaymentMethodCard(
        title: 'Thanh Toán Tiền Mặt',
        icon: Icons.money,
        value: 'cash',
        selectedValue: _selectedPaymentMethod,
        onChanged: (value) => setState(() => _selectedPaymentMethod = value),
        subtitle: 'Trả tiền khi nhận hàng',
      ),
      const SizedBox(height: 12),
      _PaymentMethodCard(
        title: 'Thẻ Tín Dụng/Ghi Nợ',
        icon: Icons.credit_card,
        value: 'card',
        selectedValue: _selectedPaymentMethod,
        onChanged: (value) => setState(() => _selectedPaymentMethod = value),
        subtitle: 'Visa, Mastercard',
      ),
      const SizedBox(height: 12),
      _PaymentMethodCard(
        title: 'Ví điện tử',
        icon: Icons.account_balance_wallet,
        value: 'ewallet',
        selectedValue: _selectedPaymentMethod,
        onChanged: (value) => setState(() => _selectedPaymentMethod = value),
        subtitle: 'Momo, ZaloPay, Apple Pay',
      ),
    ];
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String selectedValue;
  final Function(String) onChanged;
  final String subtitle;

  const _PaymentMethodCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.orange.shade600 : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.orange.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected
                    ? Colors.orange.shade600
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedValue,
              onChanged: (value) => onChanged(value!),
              activeColor: Colors.orange.shade600,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PriceSummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
