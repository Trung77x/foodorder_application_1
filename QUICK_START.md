# 🚀 Quick Start - Chạy App Với API

## ⚡ Bắt Đầu Nhanh (2 Phút)

### 1️⃣ Chuẩn Bị

```bash
# Mở terminal/PowerShell
cd d:\BaiFood\foodorder_application_1

# Cài đặt packages (nếu chưa)
flutter pub get
```

### 2️⃣ Chạy Ứng Dụng

```bash
# Chạy trên device/emulator mặc định
flutter run

# Hoặc chỉ định device
flutter devices                    # Liệt kê devices
flutter run -d emulator-5554      # Chạy trên device cụ thể
```

### 3️⃣ Hot Reload

```bash
# Trong terminal đang chạy app:
r     # Hot reload
R     # Hot restart
q     # Quit
```

---

## 🔍 Kiểm Tra API Hoạt Động

### Dấu Hiệu Thành Công ✅

1. **App Khởi Động**
   - Splash screen hiển thị (2 giây)
   - Loading spinner hiện lên

2. **Menu Screen Hiển Thị**
   - Danh mục: "All", "Seafood", "Pasta", "Breakfast", etc.
   - Các món ăn từ API được tải

3. **Ảnh Hiển Thị**
   - Các ảnh từ TheMealDB API
   - Chất lượng cao, tiêu đề tiếng Anh

4. **Tìm Kiếm Hoạt Động**
   - Gõ "chicken" → Xuất hiện 50+ kết quả
   - Gõ "pasta" → Xuất hiện các loại mì
   - Gõ "fish" → Xuất hiện các loại cá

### Dấu Hiệu Có Vấn Đề ⚠️

| Vấn Đề        | Nguyên Nhân       | Giải Pháp                             |
| ------------- | ----------------- | ------------------------------------- |
| Chỉ 10 món ăn | API thất bại      | Fallback hoạt động, đó là bình thường |
| Ảnh bị xám    | Không có internet | Kiểm tra kết nối Wi-Fi                |
| App crash     | Lỗi JSON parse    | Xem console logs                      |
| Tìm kiếm rỗng | API chậm          | Thực hiện ngay lại                    |

---

## 📱 Các Tính Năng Để Test

### Test 1: Trang Chủ (Menu)

```
✓ Danh mục hiển thị
✓ Món ăn từ API hiểm thị ở
✓ Click vào món ăn → Xem chi tiết
✓ Ratings & reviews hiển thị
```

### Test 2: Tìm Kiếm

```
Nhấn thanh tìm kiếm
Gõ: "chicken"          → Xem 50+ kết quả
Gõ: "pizza"            → Xem các loại pizza
Gõ: "soup"             → Xem các loại súp
Xóa → Lại danh cụm ban đầu
```

### Test 3: Chi Tiết Sản Phẩm

```
Click vào một món ăn
✓ Hình ảnh từ API
✓ Tên tiếng Anh (từ API)
✓ Mô tả công thức nấu
✓ Giá (tính toán từ API)
✓ Đánh giá và thời gian chuẩn bị
```

### Test 4: Giỏ Hàng

```
Thêm 2-3 món vào giỏ
Giỏ hàng → Xem chi tiết
✓ Các món từ API hiển thị
✓ Tính toán giá chính xác
✓ Thanh toán hoạt động
```

---

## 📊 Dữ Liệu Xắp Nhập API

### Từ TheMealDB:

```
✓ Tên mon ăn (tiếng Anh)
✓ Hình ảnh chất lượng cao
✓ Danh mục (Seafood, Pasta, etc.)
✓ Công thức nấu
✓ Vùng xuất xứ
```

### Tính Toán Trong App:

```
✓ Giá: 45,000 + (index * 5,000) VND
✓ Đánh giá: 4-5 sao (ngẫu nhiên)
✓ Reviews: 50 + (index * 10)
✓ Thời gian: 15-40 phút
```

---

## 🔧 Debug Mode

### Xem Logs API

```bash
# Chạy app với verbose mode
flutter run -v

# Xem tất cả logs
flutter logs

# Filter logs (chỉ app)
flutter logs --grep "Order"
```

### Console Debug

```dart
// Kiểm tra dữ liệu được tải
print('Foods loaded: ${foodProvider.foods.length}');
print('First food: ${foodProvider.foods.first.name}');
```

---

## 📝 Ví Dụ Đầu Ra

### Console Output Kỳ Vọng

```
I/chromium: [INFO:CONSOLE(1)] "Loaded 20 foods from API"
I/flutter: Foods loaded: 20
I/flutter: First food: Corba (Turkish Soup)
```

### Menu Screen

```
[Danh mục]
All | Seafood | Pasta | Breakfast | Beef | ...

[Danh sách món ăn]
[ 🖼️ Corba            ]
[ 🖼️ Falafel & Hummus ]
[ 🖼️ Tuna & Egg Pasta ]
[ 🖼️ Spring Rolls     ]
...
```

---

## ⚙️ Thiết Lập Tối Ưu

### Android Emulator

```bash
# Đảm bảo kết nối internet
# Trong emulator: Cài đặt → Kết nối → Wi-Fi

# Hoặc dùng mobile device thực
flutter run -d <device-id>
```

### iOS Simulator

```bash
# Mở Simulator
open -a Simulator

# Chạy app
flutter run -d "iPhone 14"
```

---

## 🆘 Lỗi Thường Gặp

### ❌ "flutter: command not found"

```bash
# Thêm Flutter vào PATH
export PATH="$PATH:$(pwd)/flutter/bin"
```

### ❌ "No connected devices"

```bash
# Bật emulator/device
flutter devices
flutter run -d <device-id>
```

### ❌ "Connection refused"

```bash
# Kiểm tra internet
# Hoặc dùng mobile device thực (có network)
```

### ❌ "Images not loading"

```bash
# Bình thường, cache cuộc gọi sau
# Hoặc dùng Wi-Fi tốt hơn
```

---

## ✅ Checklist Trước Chạy

- [ ] Flutter installed (`flutter --version`)
- [ ] Device connected/emulator running (`flutter devices`)
- [ ] Internet connection active
- [ ] No other Flutter instances running
- [ ] Dependencies installed (`flutter pub get`)
- [ ] No build artifacts (`flutter clean` if needed)

---

## 🎉 Bây Giờ Bạn Đã Sẵn Sàng!

```bash
cd d:\BaiFood\foodorder_application_1
flutter run
```

**Ứng dụng của bạn sẽ:**
✅ Tải TheMealDB API
✅ Hiển thị 20+ mon ăn thực
✅ Cho phép tìm kiếm
✅ Hoạt động toàn bộ

---

**Thưởng thức! 🍽️**
