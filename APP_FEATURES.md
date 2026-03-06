# Order Food App - Ứng Dụng Đặt Hàng Ăn Uống

Một ứng dụng Flutter đầy đủ tính năng cho phép người dùng đặt hàng ăn uống trực tuyến với giao diện thân thiện và trải nghiệm mượt mà.

## 🎯 Các Tính Năng Chính

### 1. **Xác Thực & Quản Lý Tài Khoản**

- ✅ Đăng nhập (Login)
- ✅ Đăng ký (Sign Up)
- ✅ Lưu thông tin đăng nhập dùng SharedPreferences
- ✅ Chỉnh sửa hồ sơ cá nhân
- ✅ Đăng xuất (Logout)

### 2. **Danh Mục Sản Phẩm & Tìm Kiếm**

- ✅ Hiển thị danh mục các loại món ăn:
  - Cơm
  - Mì & Phở
  - Bánh
  - Gà
  - Bún
  - Canh
  - Đồ Uống
  - Tráng Miệng
- ✅ Lọc theo danh mục
- ✅ Tìm kiếm động theo tên hoặc mô tả
- ✅ Hiển thị thông tin chi tiết: giá, đánh giá, thời gian chuẩn bị

### 3. **Giỏ Hàng & Thanh Toán**

- ✅ Thêm/xóa sản phẩm vào giỏ hàng
- ✅ Cập nhật số lượng sản phẩm
- ✅ Tính toán tạm tính, thuế (10%), và phí giao hàng
- ✅ Miễn phí giao hàng cho đơn hàng trên 100K
- ✅ Hiển thị chi tiết giá trong giỏ hàng

### 4. **Checkout & Đặt Hàng**

- ✅ Điền địa chỉ giao hàng
- ✅ Chọn phương thức thanh toán:
  - Tiền mặt
  - Thẻ tín dụng
  - E-Wallet (Momo, ZaloPay...)
- ✅ Thêm ghi chú cho đơn hàng
- ✅ Xem chi tiết đơn hàng trước khi thanh toán
- ✅ Xác nhận đặt hàng

### 5. **Quản Lý Đơn Hàng**

- ✅ Xem danh sách tất cả đơn hàng
- ✅ Xem trạng thái đơn hàng:
  - Đang xử lý (Pending)
  - Đã xác nhận (Confirmed)
  - Đang chuẩn bị (Preparing)
  - Sẵn sàng (Ready)
  - Đang giao hàng (Out For Delivery)
  - Đã giao hàng (Delivered)
  - Đã hủy (Cancelled)
- ✅ Xem chi tiết từng đơn hàng
- ✅ Hủy đơn hàng

### 6. **Hồ Sơ Cá Nhân**

- ✅ Xem thông tin tài khoản
- ✅ Chỉnh sửa tên, số điện thoại, địa chỉ
- ✅ Đổi mật khẩu
- ✅ Quản lý thông tin giao hàng
- ✅ Đăng xuất từ ứng dụng

### 7. **Giao Diện & UX**

- ✅ Giao diện đẹp với màu sắc chủ đề (Orange)
- ✅ Navigation bar dưới cùng với 4 tab chính
- ✅ Splash screen chào mừng
- ✅ Responsive design
- ✅ Loading indicators
- ✅ Snackbar thông báo

## 📁 Cấu Trúc Dự Án

```
lib/
├── main.dart                 # Entry point của ứng dụng
├── models/                   # Data models
│   ├── food_model.dart
│   ├── cart_item_model.dart
│   ├── user_model.dart
│   ├── order_model.dart
│   ├── review_model.dart
│   └── index.dart
├── providers/                # State management (Provider)
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── food_provider.dart
│   ├── order_provider.dart
│   └── index.dart
├── screens/                  # UI Screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── menu_screen.dart
│   │   └── food_detail_screen.dart
│   ├── cart/
│   │   ├── cart_screen.dart
│   │   └── checkout_screen.dart
│   ├── orders/
│   │   └── orders_screen.dart
│   └── profile/
│       └── profile_screen.dart
└── widgets/                  # Reusable widgets
    └── common_widgets.dart
```

## 🚀 Bắt Đầu

### Yêu Cầu

- Flutter SDK: ^3.10.7
- Dart SDK: ^3.10.7

### Cài Đặt

1. **Clone dự án**

```bash
cd d:\BaiFood\foodorder_application_1
```

2. **Cài đặt dependencies**

```bash
flutter pub get
```

3. **Chạy ứng dụng**

```bash
flutter run
```

## 📦 Dependencies

```yaml
- provider: ^6.0.0 # State management
- intl: ^0.18.0 # Internationalization
- uuid: ^4.0.0 # Unique IDs
- shared_preferences: ^2.1.1 # Local storage
- google_fonts: ^6.0.0 # Custom fonts
- http: ^1.1.0 # HTTP requests
- shimmer: ^3.0.0 # Loading effects
- cached_network_image: ^3.3.0 # Image caching
- smooth_page_indicator: ^1.0.0 # Page indicators
- flutter_rating_bar: ^4.0.0 # Rating widget
```

## 💾 Lưu Trữ Dữ Liệu

- **Người dùng**: SharedPreferences
- **Giỏ hàng**: Provider (In-memory)
- **Đơn hàng**: Provider (In-memory)
- **Danh mục**: Provider (Hard-coded data)

## 🎨 Màu Sắc & Theme

- **Primary Color**: Orange (Colors.orange)
- **Background**: White
- **Text**: Black/Grey

## 🔐 Bảo Mật

- Mật khẩu được xác thực (demo)
- Token lưu trữ an toàn trong SharedPreferences
- Có thể mở rộng để hỗ trợ Firebase Authentication

## 📝 Dữ Liệu Mẫu

Ứng dụng bao gồm 10 monomer ăn mẫu:

1. Cơm Chiên Dương Châu (85K)
2. Phở Bò (75K)
3. Bánh Mì Thập Cẩm (45K)
4. Gà Rán Giòn (89K)
5. Bún Chả (55K)
6. Chè Ba Màu (25K)
7. Cơm Cà Chua Trứng (65K)
8. Bánh Xèo (48K)
9. Canh Cua (95K)
10. Trà Sữa Trân Châu (35K)

## ✨ Tính Năng Nâng Cao (Có Thể Mở Rộng)

- [ ] Tích hợp thanh toán thực (Momo, ZaloPay, Stripe)
- [ ] Đánh giá và bình luận sản phẩm
- [ ] Lịch sử đơn hàng chi tiết
- [ ] Map integration cho giao hàng
- [ ] Push notifications
- [ ] Chat with restaurant
- [ ] Favorite/Bookmark món ăn
- [ ] Loyalty points system
- [ ] Admin dashboard
- [ ] Multiple language support

## 📞 Hỗ Trợ

Nếu bạn gặp vấn đề hoặc có đề xuất, vui lòng liên hệ.

---

**Version**: 1.0.0  
**Last Updated**: 2026  
**Language**: Vietnamese/Tiếng Việt
