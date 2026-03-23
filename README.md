# He thong theo doi vi tri phuong tien thoi gian thuc

Ung dung di dong Flutter ket hop he thong IoT de giam sat vi tri phuong tien theo thoi gian thuc, dong bo du lieu qua Firebase va hien thi tren ban do.

## Muc tieu du an

- Thu thap va dong bo vi tri GPS cua phuong tien theo thoi gian thuc.
- Hien thi vi tri, lo trinh va trang thai ket noi tren ung dung di dong.
- Xay dung nen tang mo rong cho canh bao, thong bao day, va phan tich hanh vi di chuyen.

## Cong nghe su dung

- Flutter va Dart
- Firebase:
	- firebase_core
	- firebase_auth
	- cloud_firestore
	- firebase_database
	- firebase_storage
	- firebase_messaging
	- firebase_remote_config
	- firebase_crashlytics
	- firebase_analytics
	- firebase_performance
- Riverpod (state management) va Riverpod Generator
- Ban do va dinh vi:
	- google_maps_flutter
	- flutter_map
	- geolocator
	- flutter_polyline_points

## Cau truc thu muc chinh

```text
lib/
	main.dart
	firebase_options.dart
	src/
		core/
			error/
			services/firebase/
			usecases/
		features/
```

## Cai dat va chay du an

### 1) Dieu kien tien quyet

- Flutter SDK phu hop voi Dart SDK trong pubspec
- Tai khoan Firebase da tao project
- Android Studio hoac VS Code (kem Flutter extension)

### 2) Cai dependency

```bash
flutter pub get
```

### 3) Cau hinh Firebase

Da co file cau hinh Firebase trong du an:

- Android: android/app/google-services.json
- iOS/macOS/web/options: lib/firebase_options.dart

Neu can tao lai cau hinh, su dung FlutterFire CLI:

```bash
flutterfire configure
```

### 4) Chay code generation

Du an su dung Riverpod Generator, can chay build_runner sau khi thay doi cac file co annotation.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5) Chay ung dung

```bash
flutter run
```

## Kiem tra chat luong

```bash
flutter analyze
flutter test
```

## Dinh huong mo rong

- Theo doi nhieu phuong tien theo doi thoi gian thuc tren cung mot man hinh.
- Geofencing va canh bao ra/vao vung.
- Luu lich su hanh trinh va thong ke quang duong.
- Dashboard quan tri doi xe.
- Toi uu pin va tan suat gui du lieu tu thiet bi IoT.

## Trang thai

Du an dang trong qua trinh phat trien, da co nen tang Firebase service va base core cho error/usecase de tiep tuc mo rong theo Clean Architecture.
