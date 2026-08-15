// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:quadraclub_app/app_exports.dart';
//
// class CustomDropdown extends StatelessWidget {
//   final List<String> items;
//   final String? value;
//   final String label;
//   final String hintText;
//   final ValueChanged<String?> onChanged;
//
//   const CustomDropdown({
//     super.key,
//     required this.items,
//     required this.value,
//     required this.label,
//     required this.hintText,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// Label (like "Graduation Year")
//         Text(
//           label,
//           style: AppStyles.w400f14inter.copyWith(
//             color: kBlackColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         DropdownButtonHideUnderline(
//           child: DropdownButton2<String>(
//             isExpanded: true,
//             hint: Text(
//               hintText,
//               style: AppStyles.w400f16inter.copyWith(
//                 fontSize: 14,
//                 color: kTextColor,
//               ),
//             ),
//             items: items
//                 .map(
//                   (String item) => DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(
//                       item,
//                       style: AppStyles.w400f16inter.copyWith(
//                         color: kBlackColor,
//                         fontSize: 16,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 )
//                 .toList(),
//             value: value,
//             onChanged: onChanged,
//             buttonStyleData: ButtonStyleData(
//               height: getProportionateScreenHeight(50),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: const Color(0xFFF5F5F5),
//               ),
//             ),
//             iconStyleData: const IconStyleData(
//               icon: Icon(Icons.keyboard_arrow_down, color: kBlackColor),
//               iconSize: 24,
//             ),
//             dropdownStyleData: DropdownStyleData(
//               maxHeight: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: kWhiteColor,
//               ),
//               scrollbarTheme: ScrollbarThemeData(
//                 radius: const Radius.circular(40),
//                 thickness: WidgetStateProperty.all<double>(6),
//                 thumbVisibility: WidgetStateProperty.all<bool>(true),
//               ),
//             ),
//             menuItemStyleData: const MenuItemStyleData(
//               height: 40,
//               padding: EdgeInsets.symmetric(horizontal: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
