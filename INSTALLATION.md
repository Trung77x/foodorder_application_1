# 🚀 Installation & Setup Guide - Order Food App

## ⚙️ Yêu Cầu Hệ Thống

### Tối thiểu

- Flutter SDK: ^3.10.7
- Dart SDK: ^3.10.7
- Android SDK 21+ (để build Android)
- Xcode 14+ (để build iOS - macOS)

### Khuyến nghị

- Flutter SDK: Latest (3.13+)
- Dedicated Android Emulator hoặc Real Device
- 8GB RAM tối thiểu

## 📝 Installation Steps

### 1. Clone / Mở Dự Án

```bash
# Nếu bạn chưa có dự án, clone từ repo
git clone <repo-url>
cd foodorder_application_1

# Hoặc nếu đã có dự án, mở thư mục
cd d:\BaiFood\foodorder_application_1
```

### 2. Kiểm Tra Flutter Installation

```bash
# Kiểm tra phiên bản Flutter
flutter --version

# Kiểm tra doctor status
flutter doctor
```

**Output mong đợi:**

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.13.0, ...)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 14.3.1)
[✓] VS Code (version 1.78)
...
```

### 3. Lấy Dependencies

```bash
# Clean pub cache (tùy chọn)
flutter clean
flutter pub cache clean

# Lấy packages
flutter pub get

# Hoặc upgrade to latest versions
flutter pub upgrade
```

### 4. Kiểm Tra Project Structure

```bash
# Verify project structure
flutter analyze

# Hoặc check for lint issues
dart analyze
```

### 5. Chạy Ứng Dụng

#### Trên Emulator/Android Device

```bash
# Liệt kê các devices có sẵn
flutter devices

# Chạy trên device mặc định
flutter run

# Chạy trên device cụ thể
flutter run -d <device-id>

# Chạy với release mode
flutter run --release

# Chạy với profile mode (tốt cho performance testing)
flutter run --profile
```

#### Trên iOS Simulator/Device (macOS)

```bash
# Chạy trên iOS Simulator
flutter run -d "iPhone 14"

# Hoặc lấy danh sách các simulators
xcrun simctl list devices
```

### 6. Build APK (Android)

```bash
# Build APK
flutter build apk

# Output: build/app/outputs/apk/release/app-release.apk

# Build split APKs (tối ưu file size)
flutter build apk --split-per-abi

# Build Bundle (recommended for Play Store)
flutter build appbundle
```

### 7. Build IPA (iOS)

```bash
# Yêu cầu: macOS và Xcode

# Build IPA
flutter build ios

# Output: build/ios/archive/Runner.xcarchive
```

## 🔧 Configuration

### pubspec.yaml

Các dependencies quan trọng đã được tải:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0 # State management
  intl: ^0.18.0 # Localization
  uuid: ^4.0.0 # ID generation
  shared_preferences: ^2.1.1 # Local storage
  google_fonts: ^6.0.0 # Fonts
  http: ^1.1.0 # API calls
  shimmer: ^3.0.0 # Loading effects
  cached_network_image: ^3.3.0
  smooth_page_indicator: ^1.0.0
  flutter_rating_bar: ^4.0.0
```

### Android Configuration (android/app/build.gradle)

```gradle
android {
    compileSdkVersion 33

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

### iOS Configuration (ios/Podfile)

```ruby
platform :ios, '12.0'

target 'Runner' do
    use_frameworks!
    flutter_root = File.expand_path(File.join(packages_path, 'flutter'))
end
```

## 🐛 Troubleshooting

### Issue 1: "flutter: command not found"

**Solution:**

```bash
# Tambahkan Flutter ke PATH
# Windows (Command Prompt):
set PATH=%PATH%;C:\flutter\bin

# Windows (PowerShell):
$env:Path += ";C:\flutter\bin"

# macOS/Linux:
export PATH="$PATH:$(pwd)/flutter/bin"

# Verify
flutter --version
```

### Issue 2: "No connected devices"

**Solution:**

```bash
# Bật Android Emulator hoặc kết nối Physical Device
# Kiểm tra USB debugging (Physical Device)

# List devices
flutter devices

# Kiểm tra ADB status
adb devices
```

### Issue 3: "Gradle build failed"

**Solution:**

```bash
# Clean build
flutter clean
flutter pub get

# Build lại
flutter pub upgrade
flutter run
```

### Issue 4: "CocoaPods error" (iOS)

**Solution:**

```bash
cd ios
pod repo update
pod install --repo-update
cd ..
flutter run
```

### Issue 5: "Resource not found" (Image URLs)

**Giải pháp:**

- Ứng dụng sử dụng URL hình ảnh từ internet
- Đảm bảo kết nối internet ổn định
- Hình ảnh sẽ được cache tự động

## 📊 Development Workflow

### Hot Reload

```bash
# Trong terminal đang chạy flutter run
# Nhấn 'r' để hot reload
# Nhấn 'R' để hot restart
```

### Debugging

```bash
# Chạy với debug info
flutter run -v

# Xem logs trong realtime
flutter logs

# Attach debugger
flutter attach
```

### Testing

```bash
# Chạy unit tests
flutter test

# Chạy integration tests
flutter test integration_test

# Coverage report
flutter test --coverage
```

## 🔐 Security Best Practices

1. **Mật khẩu:**
   - Không lưu mật khẩu ở SharedPreferences
   - Sử dụng keychain/keystore cho production
   - Implement proper hashing

2. **API Keys:**
   - Không commit API keys vào git
   - Sử dụng environment variables
   - Rotate keys thường xuyên

3. **Data:**
   - Encrypt sensitive data
   - Validate input từ users
   - Use HTTPS cho API calls

## 🌐 Network Configuration

### Android (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS (ios/Runner/Info.plist)

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>App needs to access local network</string>
<key>NSBonjourServiceTypes</key>
<array>
    <string>_http._tcp</string>
</array>
```

## 📚 Project Structure Explanation

```
lib/
├── main.dart              # App entry point
├── models/                # Data models (Food, User, Order, etc.)
├── providers/             # State management (Provider pattern)
├── screens/               # UI screens
│   ├── auth/             # Login/Signup screens
│   ├── home/             # Home/Menu screens
│   ├── cart/             # Shopping cart screen
│   ├── orders/           # Order tracking screen
│   └── profile/          # User profile screen
└── widgets/              # Reusable custom widgets

test/                     # Unit test files
integration_test/         # Integration test files
```

## 📦 Building for Production

### Android

```bash
# Build signed APK
flutter build apk --release

# Build AppBundle
flutter build appbundle --release
```

### iOS

```bash
# Build for release
flutter build ios --release

# Create IPA
flutter build ios --release -v
```

## 🚀 Deployment

### Google Play Store (Android)

1. Create Google Play Developer account
2. Create App listing
3. Build signed APK/AAB
4. Upload to Google Play Console
5. Review & publish

### Apple App Store (iOS)

1. Create Apple Developer account
2. Create App listing in App Store Connect
3. Build signed IPA
4. Upload using Xcode or Transporter
5. Review & publish

## 📞 Support & Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Dart Docs**: https://dart.dev/guides
- **Provider Package**: https://pub.dev/packages/provider
- **Stack Overflow**: Tag `flutter`

---

**Happy Coding! 🎉**
