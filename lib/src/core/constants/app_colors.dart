import 'package:flutter/material.dart';

class AppColors {
  // Màu chủ đạo tươi sáng cho app bản đồ/vị trí xe
  static const Color primary = Color(0xFF1E88E5); // Xanh dương tươi (Blue)
  static const Color secondary = Color(0xFF00BCD4); // Xanh lơ (Cyan)
  static const Color accent = Color(
    0xFFFF9800,
  ); // Cam nổi bật (dùng cho icon xe, cảnh báo)

  // Nền & Surface
  static const Color background = Color(0xFFF5F6FA); // Trắng xám nhạt
  static const Color surface = Colors.white;

  // Màu chữ
  static const Color textPrimary = Color(0xFF1D1F24);
  static const Color textSecondary = Color(0xFF6B7280);

  // Trạng thái (Status)
  static const Color success = Color(0xFF10B981); // Xanh lá - Xe đang chạy tốt
  static const Color error = Color(0xFFEF4444); // Đỏ - Lỗi / Mất tín hiệu
  static const Color warning = Color(0xFFF59E0B); // Vàng cam - Cảnh báo tốc độ
}
