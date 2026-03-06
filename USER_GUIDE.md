# 🍕 Hướng Dẫn Sử Dụng Order Food App

## 🎬 Quy Trình Sử Dụng

### 1️⃣ Đăng Nhập / Đăng Ký

```
Màn hình Splash
    ↓
Màn hình Đăng Nhập
    ↓
Nhập Email & Mật khẩu
    ↓
Nhấn "Đăng Nhập"
    ↓
Hoặc nhấn "Đăng Ký" để tạo tài khoản mới
```

### 2️⃣ Duyệt Danh Mục (HomePage)

```
Trang Chủ
    ├─ Thanh tìm kiếm (Search)
    ├─ Danh mục (Categories)
    │   ├─ All
    │   ├─ Cơm
    │   ├─ Mì & Phở
    │   ├─ Bánh
    │   ├─ Gà
    │   ├─ Bún
    │   ├─ Canh
    │   ├─ Đồ Uống
    │   └─ Tráng Miệng
    └─ Danh sách món ăn
```

### 3️⃣ Xem Chi Tiết Sản Phẩm

```
Tấn vào một món ăn bất kì
    ↓
Xem ảnh, mô tả, giá, đánh giá
    ↓
Chọn số lượng (+ / -)
    ↓
Nhấn "Thêm vào Giỏ Hàng"
```

### 4️⃣ Quản Lý Giỏ Hàng

```
Tab "Giỏ Hàng"
    ↓
Xem danh sách sản phẩm
    ├─ Chỉnh sửa số lượng
    ├─ Xóa sản phẩm
    └─ Xem tổng giá
    ↓
Nhấn "Thanh Toán" để tiếp tục
```

### 5️⃣ Thanh Toán (Checkout)

```
Nhập địa chỉ giao hàng
    ↓
Chọn phương thức thanh toán
    ├─ Tiền mặt
    ├─ Thẻ tín dụng
    └─ E-Wallet
    ↓
Thêm ghi chú (tùy chọn)
    ↓
Xem chi tiết đơn hàng
    ├─ Tạm tính
    ├─ Thuế (10%)
    ├─ Phí giao hàng
    └─ Tổng cộng
    ↓
Nhấn "Đặt Hàng"
```

### 6️⃣ Theo Dõi Đơn Hàng

```
Tab "Đơn Hàng"
    ↓
Xem danh sách đơn hàng
    ├─ Mã đơn hàng
    ├─ Thời gian đặt
    ├─ Trạng thái (Status)
    ├─ Tổng tiền
    └─ Chi tiết
    ↓
Nhấn vào đơn hàng để xem chi tiết
```

### 7️⃣ Quản Lý Tài Khoản

```
Tab "Tài Khoản"
    ↓
Xem thông tin cá nhân
    ├─ Ảnh đại diện
    ├─ Họ và tên
    ├─ Email
    ├─ Số điện thoại
    └─ Địa chỉ
    ↓
Nhấn "Chỉnh Sửa" để cập nhật
    ↓
Nhấn "Đăng Xuất" để thoát
```

## 🔢 Tính Toán Giá

### Công Thức

```
Tạm tính = Giá × Số lượng

Thuế = Tạm tính × 10%

Phí giao hàng =
  - 0 đ    (Nếu tạm tính ≥ 100,000 đ)
  - 50 đ   (Nếu tạm tính < 100,000 đ)

Tổng cộng = Tạm tính + Thuế + Phí giao hàng
```

### Ví Dụ

```
Cơm Chiên (85K) × 2 = 170K
Phở Bò (75K) × 1 = 75K
─────────────────────────
Tạm tính   = 245K
Thuế (10%) = 24.5K
Phí giao hàng = 0K (vì 245K > 100K)
─────────────────────────
Tổng cộng  = 269.5K
```

## 🏷️ Trạng Thái Đơn Hàng

| Trạng Thái     | Mô Tả                   | Màu    |
| -------------- | ----------------------- | ------ |
| Đang xử lý     | Đơn hàng vừa được tạo   | Orange |
| Đã xác nhận    | Nhà hàng xác nhận đơn   | Blue   |
| Đang chuẩn bị  | Đang chuẩn bị thức ăn   | Purple |
| Sẵn sàng       | Thức ăn sẵn sàng pickup | Indigo |
| Đang giao hàng | Đơn hàng đang được giao | Cyan   |
| Đã giao hàng   | Giao hàng thành công    | Green  |
| Đã hủy         | Đơn hàng bị hủy         | Red    |

## 🔐 Thông Tin Đăng Nhập Demo

```
Email: demo@example.com
Mật khẩu: password123

Hoặc tạo tài khoản mới!
```

## ⚡ Mẹo & Thủ Thuật

### 1. Tìm Kiếm Nhanh

- Sử dụng thanh tìm kiếm để tìm sản phẩm theo tên hoặc mô tả
- Ví dụ: "phở", "cơm chiên", "trà sữa"

### 2. Lọc Danh Mục

- Nhấn vào từng danh mục để xem chỉ sản phẩm trong danh mục đó
- Nhấn vào "All" để xem tất cả sản phẩm

### 3. Miễn Phí Giao Hàng

- Đặt hàng trên 100K để được miễn phí giao hàng
- Ví dụ: Cơm (89K) + Gà (89K) = 178K > 100K ✓

### 4. Chỉnh Sửa Địa Chỉ

- Thường xuyên cập nhật địa chỉ trong tab Tài Khoản
- Khi thanh toán, có thể nhập địa chỉ khác

### 5. Ghi Chú Đơn Hàng

- Sử dụng ghi chú để yêu cầu không cay, không tiêu, v.v.
- Nhà hàng sẽ nhận được ghi chú của bạn

## ❓ Câu Hỏi Thường Gặp

### Q: Làm sao để đăng ký?

A: Nhấn "Đăng Ký" trên màn hình Đăng Nhập, nhập thông tin và xác nhận.

### Q: Có thể thanh toán online không?

A: Hiện tại app hỗ trợ thanh toán tiền mặt, thẻ và E-Wallet (để triển khai).

### Q: Làm sao để hủy đơn hàng?

A: Vào tab Đơn Hàng, nhấn vào đơn hàng, nhấn nút "Hủy Đơn Hàng".

### Q: Thời gian giao hàng là bao lâu?

A: Xấp xỉ 30-45 phút tùy vào vị trí và thời gian bận của nhà hàng.

### Q: Làm sao để cập nhật profile?

A: Vào tab Tài Khoản, nhấn "Chỉnh Sửa", cập nhật thông tin, nhấn "Lưu Thay Đổi".

### Q: Có thể xóa tài khoản không?

A: Hiện tại không, bạn có thể đăng xuất và tạo tài khoản mới.

## 🚀 Cải Tiến Trong Tương Lai

- ✨ Tích hợp thanh toán trực tuyến
- ✨ Đánh giá món ăn
- ✨ Hệ thống voucher/khuyến mãi
- ✨ Chat với nhà hàng
- ✨ Xem bản đồ theo dõi giao hàng
- ✨ Đa ngôn ngữ
- ✨ Dark mode

---

**Cảm ơn đã sử dụng Order Food App! 🎉**
