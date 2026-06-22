import 'package:quadraclub_app/app_exports.dart';

extension BuiltInPadding on Widget {
  Widget paddingOnly({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(left),
        right: getProportionateScreenWidth(right),
        top: getProportionateScreenHeight(top),
        bottom: getProportionateScreenHeight(bottom),
      ),
      child: this,
    );
  }

  Widget withPaddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }

  Widget withPaddingSymmetric(double horizontal, double vertical) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(horizontal),
        vertical: getProportionateScreenHeight(vertical),
      ),
      child: this,
    );
  }
}
