import '../../app_exports.dart';

class AppStyles {
  // 🔹 Base Style (defined once)
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: "ZalandoSans",
    color: kTextPrimaryColor,
  );

  static TextStyle w500f15inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );
  static TextStyle w500f16inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );
  static TextStyle w500f14inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static TextStyle w400f16inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static TextStyle w600f32inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 32,
  );
  static TextStyle w500f24inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 24,
  );

  static TextStyle w400f12inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );
  static TextStyle w400f10inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 10,
  );
  static TextStyle w500f12inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );static TextStyle w600f12inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 12,
  ); static TextStyle w500f10inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  static TextStyle w400f14inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static TextStyle w500f8inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 8,
  );

  static TextStyle w600f24inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );
  static TextStyle w600f18inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  static TextStyle w600f16inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  ); static TextStyle w600f14inter = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  // 🔹 Body
  static TextStyle bodyRegular = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  static TextStyle bodyMedium = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  static TextStyle bodySemiBold = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  // 🔹 Subtitle
  static TextStyle subtitleRegular = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static TextStyle subtitleMedium = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static TextStyle subtitleSemiBold = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  // 🔹 Title
  static TextStyle titleRegular = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static TextStyle titleMedium = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static TextStyle titleSemibold = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  // 🔹 Headings
  static TextStyle subHeadingSemibold = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static TextStyle headingSemibold = _baseStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );
}
