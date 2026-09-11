import 'dart:developer';

import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

import '/app_exports.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label; // ✅ Added for "Email" text above field
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
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double borderRadius;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
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
    this.hintStyle,
    this.textStyle,
    this.borderRadius = 12,
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
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppStyles.w500f14inter.copyWith(color: kTextPrimaryColor),
          ),
          6.heightBox,
        ],
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
          style:
              widget.textStyle ??
              AppStyles.w400f16inter.copyWith(color: kTextPrimaryColor),
          cursorColor: kGreenColor,
          decoration: InputDecoration(
            counter: const SizedBox.shrink(),
            suffixIcon:
                widget.suffixIcon?.withPaddingAll(14) ??
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
                        child: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kDarkTextColor.withValues(alpha: 0.60),
                        ),
                      )
                    : null),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.textHorizontalPadding!,
              vertical: 14,
            ),
            prefixIcon: widget.prefixIcon?.withPaddingAll(14),
            prefixIconColor: widget.prefixIconColor,
            errorStyle: AppStyles.w400f12inter.copyWith(color: kRedColor),
            hintText: widget.hintText,
            hintStyle:
                widget.hintStyle ??
                AppStyles.w400f14inter.copyWith(
                  color: kTextSecondary.withValues(alpha: 0.50),
                ),
            filled: true,
            fillColor: widget.fillColor ?? kWhiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: kBlackColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
