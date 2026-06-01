# Báo cáo ứng dụng Vehicle Tracking System

## Giới thiệu ứng dụng

Vehicle Tracking System là ứng dụng di động được xây dựng bằng Flutter, phục vụ như một phần trong hệ thống theo dõi vị trí phương tiện theo thời gian thực. Ứng dụng nhận dữ liệu vị trí GPS và các thông số môi trường của phương tiện từ Firebase Realtime Database, sau đó hiển thị trực quan trên bản đồ cho người dùng.

Ứng dụng hỗ trợ người dùng quan sát vị trí hiện tại của xe, trạng thái di chuyển, tốc độ, thời gian cập nhật, nhiệt độ và độ ẩm từ thiết bị gắn trên phương tiện. Ngoài ra, ứng dụng cũng có chức năng lấy vị trí hiện tại của người dùng và mở ứng dụng bản đồ bên ngoài để chỉ đường đến xe.

## Mục tiêu của ứng dụng

Mục tiêu chính của ứng dụng là xây dựng một giải pháp theo dõi phương tiện đơn giản, trực quan và có khả năng mở rộng. Các mục tiêu cụ thể gồm:

- Theo dõi vị trí phương tiện theo thời gian thực thông qua dữ liệu GPS.
- Hiển thị vị trí xe và vị trí hiện tại của người dùng trên bản đồ.
- Cập nhật các thông tin liên quan đến phương tiện như tốc độ, trạng thái di chuyển, thời gian cập nhật, nhiệt độ và độ ẩm.
- Hỗ trợ người dùng tìm đường đến vị trí xe bằng Google Maps hoặc ứng dụng bản đồ có sẵn trên thiết bị.
- Xây dựng nền tảng để mở rộng các chức năng như cảnh báo, lịch sử hành trình, quản lý nhiều phương tiện và thông báo đẩy.
- Áp dụng cấu trúc mã nguồn rõ ràng theo hướng tách lớp presentation, domain và data để thuận tiện cho bảo trì, kiểm thử và phát triển thêm.

## Chức năng chính của ứng dụng

Ứng dụng hiện tại bao gồm các chức năng chính sau:

- Đăng nhập bằng tài khoản Google thông qua Firebase Authentication.
- Kiểm tra trạng thái đăng nhập và điều hướng người dùng vào màn hình phù hợp.
- Hiển thị bản đồ và marker vị trí xe.
- Hiển thị marker vị trí hiện tại của người dùng sau khi được cấp quyền định vị.
- Lắng nghe dữ liệu vị trí xe theo thời gian thực từ Firebase Realtime Database.
- Hiển thị lộ trình bằng đường polyline trên bản đồ khi có nhiều điểm vị trí.
- Hiển thị thông tin chi tiết của xe trong bottom sheet.
- Chuyển đổi chế độ bản đồ toàn màn hình.
- Làm mới tile bản đồ khi kết nối tải bản đồ gặp lỗi.
- Mở chỉ đường đến xe bằng ứng dụng bản đồ bên ngoài.
- Hiển thị thông tin hồ sơ người dùng và đăng xuất.

## Công nghệ sử dụng

### Nền tảng và ngôn ngữ lập trình

- Flutter: framework dùng để xây dựng ứng dụng đa nền tảng.
- Dart: ngôn ngữ lập trình chính của dự án.
- Android, iOS, Web, Windows, macOS và Linux: các nền tảng dự án Flutter có cấu trúc hỗ trợ.

### Dịch vụ Firebase

- firebase_core: khởi tạo Firebase trong ứng dụng.
- firebase_auth: xác thực người dùng, hỗ trợ đăng nhập Google.
- firebase_database: đọc và lắng nghe dữ liệu thời gian thực của phương tiện.
- cloud_firestore: hỗ trợ lưu trữ dữ liệu dạng tài liệu khi cần mở rộng.
- firebase_storage: hỗ trợ lưu trữ tệp và hình ảnh.
- firebase_messaging: hỗ trợ thông báo đẩy.
- firebase_remote_config: quản lý cấu hình từ xa.
- firebase_crashlytics: ghi nhận lỗi ứng dụng.
- firebase_analytics: thống kê hành vi người dùng.
- firebase_performance: theo dõi hiệu năng ứng dụng.

### Thư viện quản lý trạng thái và sinh mã

- flutter_riverpod: quản lý trạng thái ứng dụng.
- riverpod_annotation và riverpod_generator: khai báo provider bằng annotation và sinh mã tự động.
- freezed và freezed_annotation: tạo state bất biến, hỗ trợ tách trạng thái rõ ràng.
- json_annotation và json_serializable: hỗ trợ chuyển đổi dữ liệu JSON.
- build_runner: công cụ chạy code generation.

### Bản đồ, định vị và xử lý địa chỉ

- flutter_map: hiển thị bản đồ trong ứng dụng.
- latlong2: biểu diễn tọa độ kinh độ, vĩ độ.
- geolocator: lấy vị trí hiện tại của người dùng và quản lý quyền định vị.
- geocoding: chuyển tọa độ thành địa chỉ để hiển thị thân thiện hơn.
- flutter_polyline_points: hỗ trợ xử lý điểm polyline khi mở rộng chức năng lộ trình.
- url_launcher: mở Google Maps hoặc ứng dụng bản đồ bên ngoài để chỉ đường.

### Giao diện và tài nguyên

- flutter_screenutil: hỗ trợ responsive UI theo kích thước màn hình.
- google_fonts: sử dụng font chữ từ Google Fonts.
- lottie: hiển thị animation ở màn hình đăng nhập.
- flutter_svg: hiển thị icon SVG, ví dụ icon Google.
- cupertino_icons: bộ icon mặc định cho ứng dụng Flutter.

## Mô tả luồng hoạt động

1. Người dùng mở ứng dụng.
2. Ứng dụng kiểm tra trạng thái đăng nhập bằng Firebase Authentication.
3. Nếu chưa đăng nhập, ứng dụng hiển thị màn hình đăng nhập Google.
4. Sau khi đăng nhập thành công, người dùng được chuyển đến màn hình bản đồ.
5. Ứng dụng xin quyền định vị để lấy vị trí hiện tại của người dùng.
6. Ứng dụng lắng nghe dữ liệu xe từ Firebase Realtime Database.
7. Khi có dữ liệu GPS, ứng dụng cập nhật marker vị trí xe trên bản đồ.
8. Người dùng có thể xem chi tiết xe, phóng to/thu nhỏ bản đồ, xem vị trí của mình hoặc mở chỉ đường đến xe.

## Hình ảnh ứng dụng

### Màn hình theo dõi vị trí xe

![Màn hình theo dõi vị trí xe](device_home.png)

Hình trên thể hiện màn hình chính của ứng dụng, trong đó bản đồ được dùng để hiển thị vị trí phương tiện, vị trí người dùng và các nút thao tác nhanh như chỉ đường, tải lại bản đồ, chuyển chế độ xem và xem thông tin chi tiết của xe.

## Định hướng phát triển

Trong các phiên bản tiếp theo, ứng dụng có thể được mở rộng theo các hướng sau:

- Theo dõi nhiều phương tiện trên cùng một bản đồ.
- Lưu lịch sử hành trình của xe.
- Tạo cảnh báo khi xe ra khỏi khu vực cho phép.
- Gửi thông báo đẩy khi xe di chuyển bất thường.
- Xây dựng dashboard quản trị đội xe.
- Tối ưu tần suất cập nhật GPS để tiết kiệm pin cho thiết bị IoT.
- Bổ sung thống kê quãng đường, tốc độ trung bình và thời gian di chuyển.

## Kết luận

Vehicle Tracking System đáp ứng mục tiêu cơ bản của một ứng dụng theo dõi phương tiện theo thời gian thực. Ứng dụng đã kết hợp Flutter, Firebase, bản đồ và định vị để tạo ra một giao diện trực quan, giúp người dùng quan sát vị trí xe và các thông số liên quan. Cấu trúc dự án được tổ chức theo từng feature, tạo nền tảng phù hợp để tiếp tục phát triển các chức năng nâng cao trong tương lai.
