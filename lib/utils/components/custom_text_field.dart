import 'dart:developer';

import '/app_exports.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label; // ✅ Added for "Email" text above field
  final String hintText;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? prefixIconColor;
  final double? textHorizontalPadding;
  final int? maxLines, maxLength;
  final String? Function(String?)? validator;
  final bool? autoFocus, readOnly;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final double alphaColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.fillColor,
    this.borderColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.maxLines,
    this.validator,
    this.autoFocus,
    this.readOnly,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.maxLength,
    this.inputFormatters,
    this.textHorizontalPadding = 18,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.alphaColor = 0.8,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ✅ Label on top (like "Email")
        Text(
          widget.label,
          style: AppStyles.w400f14inter.copyWith(
            color: kBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        6.heightBox,

        TextFormField(
          maxLength: widget.maxLength,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onFieldSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines ?? 1,
          autofocus: widget.autoFocus ?? false,
          readOnly: widget.readOnly ?? false,
          obscureText: widget.obscureText && hidePassword,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          style: AppStyles.w400f16inter.copyWith(
            fontSize: 16,
            color: Colors.black.withValues(alpha: widget.alphaColor),
          ),
          cursorColor: kGreenColor,
          decoration: InputDecoration(
            counter: const SizedBox.shrink(),
            suffixIcon:
                widget.suffixIcon ??
                (widget.obscureText
                    ? InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                          log(
                            'Hide Password: ${hidePassword && widget.obscureText}',
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: getProportionateScreenWidth(16),
                          ),
                          child: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : null),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.textHorizontalPadding!,
              vertical: 14,
            ),
            prefixIcon: widget.prefixIcon,
            prefixIconColor: widget.prefixIconColor,
            errorStyle: AppStyles.w400f12inter.copyWith(color: kRedColor),
            hintText: widget.hintText,
            hintStyle: AppStyles.w400f16inter.copyWith(
              color: kTextColor,
              fontSize: 12,
            ),
            filled: true,
            fillColor: widget.fillColor ?? const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBlackColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
