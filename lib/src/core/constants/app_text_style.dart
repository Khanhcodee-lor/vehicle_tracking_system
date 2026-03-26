import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyle {
  static const String beVietnamPro = 'BeVietnamPro';
  static const String inter = 'Inter';

  // HEADING (Dùng Be Vietnam Pro cho các tiêu đề lớn, tên màn hình, biển số xe)
  static const TextStyle heading1 = TextStyle(
    fontFamily: beVietnamPro,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: beVietnamPro,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // BODY (Dùng Inter cho các chi tiết nhỏ: địa chỉ, trạng thái, tọa độ vì nét số rất rõ ràng)
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: beVietnamPro,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}