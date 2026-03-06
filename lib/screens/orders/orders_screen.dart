import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
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
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            final userOrders = orderProvider.getUserOrders(
              authProvider.user?.id ?? '',
            );

            if (userOrders.isEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.orange.shade600,
                    elevation: 0,
                    pinned: true,
                    title: const Text(
                      'TH3 - Ho Sy Trung - 2351160560',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Chưa có đơn hàng',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Hãy bắt đầu đặt hàng để xem lịch sử',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
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

            return CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  expandedHeight: 80,
                  backgroundColor: Colors.orange.shade600,
                  elevation: 0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade400,
                            Colors.orange.shade600,
                          ],
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
                            'TH3 - Ho Sy Trung - 2351160560',
                            style: TextStyle(
                              fontSize: 16,
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
                // Orders List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final order = userOrders[index];
                      final statusColor = _getStatusColor(order.status);
                      final statusText = _getStatusText(order.status);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Đơn #${order.id.substring(0, 8)}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat(
                                          'dd/MM/yyyy HH:mm',
                                        ).format(order.orderDate),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 16, thickness: 0.5),
                              // Details
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${order.items.length} món ăn',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${(order.total.toInt() ~/ 1000)} k đ',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Button
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Colors.orange.shade200,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    showOrderDetails(context, order);
                                  },
                                  child: const Text(
                                    'Xem Chi Tiết',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: userOrders.length),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }

  void showOrderDetails(BuildContext context, dynamic order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chi Tiết Đơn Hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                ...order.items.map<Widget>((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.food.name} x ${item.quantity}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Text(
                          '${(item.totalPrice.toInt() ~/ 1000)} k',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(dynamic status) {
    final statusString = status.toString();
    if (statusString.contains('pending')) return Colors.orange;
    if (statusString.contains('confirmed')) return Colors.blue;
    if (statusString.contains('preparing')) return Colors.purple;
    if (statusString.contains('ready')) return Colors.indigo;
    if (statusString.contains('outForDelivery')) return Colors.cyan;
    if (statusString.contains('delivered')) return Colors.green;
    if (statusString.contains('cancelled')) return Colors.red;
    return Colors.grey;
  }

  String _getStatusText(dynamic status) {
    final statusString = status.toString();
    if (statusString.contains('pending')) return 'Đang xử lý';
    if (statusString.contains('confirmed')) return 'Đã xác nhận';
    if (statusString.contains('preparing')) return 'Đang chuẩn bị';
    if (statusString.contains('ready')) return 'Sẵn sàng';
    if (statusString.contains('outForDelivery')) return 'Đang giao hàng';
    if (statusString.contains('delivered')) return 'Đã giao hàng';
    if (statusString.contains('cancelled')) return 'Đã hủy';
    return 'Không xác định';
  }
}
