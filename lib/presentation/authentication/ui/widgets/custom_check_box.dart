import '/app_exports.dart';

class CustomCheckbox extends StatelessWidget {
  final ValueNotifier<bool> isCheckedNotifier;
  final Function(bool)? onChanged;

  const CustomCheckbox({
    super.key,
    required this.isCheckedNotifier,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isCheckedNotifier,
      builder: (context, isChecked, _) {
        return Checkbox(
          value: isChecked,
          fillColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return kWhiteColor;
            }
            return Colors.transparent;
          }),
          checkColor: kGreenColor,
          side: WidgetStateBorderSide.resolveWith((states) {
            return const BorderSide(color: kGreenColor, width: 1);
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          onChanged: (value) {
            if (value != null) {
              isCheckedNotifier.value = value;
              onChanged?.call(value);
            }
          },
        );
      },
    );
  }
}
