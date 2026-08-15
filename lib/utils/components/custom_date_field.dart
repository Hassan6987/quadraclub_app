import '/app_exports.dart';

class CustomDateField extends StatefulWidget {
  final TextEditingController controller;

  const CustomDateField({super.key, required this.controller});

  @override
  CustomDateFieldState createState() => CustomDateFieldState();
}

class CustomDateFieldState extends State<CustomDateField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 5 * 365)),
    );

    if (selectedDate != null) {
      setState(() {
        widget.controller.text = "${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        style: AppStyles.w400f12inter.copyWith(
          fontSize: 16,
          color: kBlackColor,
        ),
        controller: widget.controller,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          hintText: "Expire Date",
          hintStyle: AppStyles.w400f16inter.copyWith(
            color: kTertiaryColor,
            fontSize: 16,
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
