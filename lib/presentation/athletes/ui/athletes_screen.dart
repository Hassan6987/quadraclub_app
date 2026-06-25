// import 'package:quadraclub_app/presentation/athletes/ui/widgets/scanned_athlete_card_widget.dart';
// import 'package:quadraclub_app/presentation/home/bloc/home_bloc.dart';
// import 'package:quadraclub_app/presentation/home/data/athlete_model.dart';
// import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
//
// import '/app_exports.dart';
// import '../../../utils/components/blue_app_bar.dart';
//
// class AthletesScreen extends StatefulWidget {
//   const AthletesScreen({super.key});
//
//   @override
//   State<AthletesScreen> createState() => _AthletesScreenState();
// }
//
// class _AthletesScreenState extends State<AthletesScreen> {
//   TextEditingController searchController = TextEditingController();
//
//   String? selectedTeam;
//   String? selectedGraduationYear;
//   String? selectedPosition;
//   String? selectedSortBy;
//
//   List<String> getAvailableTeams(List<AthleteModel> athletes) {
//     return athletes
//         .where((a) => a.scannedUserProfile?.teamName != null)
//         .map((a) => a.scannedUserProfile!.teamName!)
//         .toSet()
//         .toList()
//       ..sort();
//   }
//
//   List<String> getAvailableYears(List<AthleteModel> athletes) {
//     return athletes
//         .where((a) => a.scannedUserProfile?.graduationYear != null)
//         .map((a) => a.scannedUserProfile!.graduationYear!.toString())
//         .toSet()
//         .toList()
//       ..sort((a, b) => b.compareTo(a));
//   }
//
//   List<String> getAvailablePositions(List<AthleteModel> athletes) {
//     return athletes
//         .where((a) => a.scannedUserProfile?.position != null)
//         .map((a) => a.scannedUserProfile!.position!)
//         .toSet()
//         .toList()
//       ..sort();
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   List<AthleteModel> _getFilteredAthletes(List<AthleteModel> athletes) {
//     List<AthleteModel> filtered = athletes.where((athlete) {
//       final profile = athlete.scannedUserProfile;
//
//       // Skip if profile is null
//       if (profile == null) return false;
//
//       // Search filter
//       bool matchesSearch = (profile.fullName ?? '').toLowerCase().contains(
//         searchController.text.toLowerCase(),
//       );
//
//       // Team filter
//       bool matchesTeam =
//           selectedTeam == null || profile.teamName == selectedTeam;
//
//       // Graduation year filter
//       bool matchesYear =
//           selectedGraduationYear == null ||
//           profile.graduationYear?.toString() == selectedGraduationYear;
//
//       // Position filter
//       bool matchesPosition =
//           selectedPosition == null || profile.position == selectedPosition;
//
//       return matchesSearch && matchesTeam && matchesYear && matchesPosition;
//     }).toList();
//
//     // Apply sorting
//     if (selectedSortBy == 'Name A-Z') {
//       filtered.sort((a, b) {
//         final nameA = a.scannedUserProfile?.fullName ?? '';
//         final nameB = b.scannedUserProfile?.fullName ?? '';
//         return nameA.compareTo(nameB);
//       });
//     } else if (selectedSortBy == 'Name Z-A') {
//       filtered.sort((a, b) {
//         final nameA = a.scannedUserProfile?.fullName ?? '';
//         final nameB = b.scannedUserProfile?.fullName ?? '';
//         return nameB.compareTo(nameA);
//       });
//     } else if (selectedSortBy == 'Graduation Year') {
//       filtered.sort((a, b) {
//         final yearA = a.scannedUserProfile?.graduationYear ?? 0;
//         final yearB = b.scannedUserProfile?.graduationYear ?? 0;
//         return yearB.compareTo(yearA);
//       });
//     }
//     // If 'Recently Scanned' or null, sort by scannedAt date (most recent first)
//     else {
//       filtered.sort((a, b) {
//         final dateA = a.scannedAt ?? DateTime(1970);
//         final dateB = b.scannedAt ?? DateTime(1970);
//         return dateB.compareTo(dateA);
//       });
//     }
//
//     return filtered;
//   }
//
//   void _showFilterBottomSheet(List<AthleteModel> athletes) {
//     String? tempTeam = selectedTeam;
//     String? tempYear = selectedGraduationYear;
//     String? tempPosition = selectedPosition;
//     String? tempSortBy = selectedSortBy;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Filter',
//                         style: AppStyles.titleSemibold.copyWith(
//                           color: kBlackColor,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: Icon(
//                           Icons.close,
//                           size: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         padding: EdgeInsets.zero,
//                         constraints: BoxConstraints(),
//                       ),
//                     ],
//                   ),
//                   Divider(color: kTertiaryColor, thickness: 1),
//                   Text(
//                     'Team',
//                     style: AppStyles.subtitleMedium.copyWith(
//                       color: kBlackColor,
//                     ),
//                   ),
//                   6.heightBox,
//                   _buildDropdownField(
//                     hint: 'Select Team',
//                     value: tempTeam,
//                     items: getAvailableTeams(athletes),
//                     onChanged: (value) {
//                       setModalState(() => tempTeam = value);
//                     },
//                   ),
//                   12.heightBox,
//                   Text(
//                     'Graduation Year',
//                     style: AppStyles.subtitleMedium.copyWith(
//                       color: kBlackColor,
//                     ),
//                   ),
//                   6.heightBox,
//                   _buildDropdownField(
//                     hint: 'Select Year',
//                     value: tempYear,
//                     items: getAvailableYears(athletes),
//                     onChanged: (value) {
//                       setModalState(() => tempYear = value);
//                     },
//                   ),
//                   12.heightBox,
//
//                   // Position
//                   Text(
//                     'Position',
//                     style: AppStyles.subtitleMedium.copyWith(
//                       color: kBlackColor,
//                     ),
//                   ),
//                   6.heightBox,
//                   _buildDropdownField(
//                     hint: 'Select Position',
//                     value: tempPosition,
//                     items: getAvailablePositions(athletes),
//                     onChanged: (value) {
//                       setModalState(() => tempPosition = value);
//                     },
//                   ),
//                   12.heightBox,
//                   // Sort By
//                   Text(
//                     'Sort By',
//                     style: AppStyles.subtitleMedium.copyWith(
//                       color: kBlackColor,
//                     ),
//                   ),
//                   6.heightBox,
//                   _buildDropdownField(
//                     hint: 'Recently Scanned',
//                     value: tempSortBy,
//                     items: [
//                       'Recently Scanned',
//                       'Name A-Z',
//                       'Name Z-A',
//                       'Graduation Year',
//                     ],
//                     onChanged: (value) {
//                       setModalState(() => tempSortBy = value);
//                     },
//                   ),
//                   10.heightBox,
//                   Divider(color: kTertiaryColor, thickness: 1),
//                   10.heightBox,
//
//                   // Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomActionButton(
//                           buttonText: 'Clear',
//                           onTap: () {
//                             setState(() {
//                               selectedTeam = null;
//                               selectedGraduationYear = null;
//                               selectedPosition = null;
//                               selectedSortBy = null;
//                               searchController.clear();
//                             });
//                             Navigator.pop(context);
//                           },
//                           borderColor: kSecondaryColor,
//                           backgroundColor: kWhiteColor,
//                         ),
//                       ),
//                       8.widthBox,
//                       Expanded(
//                         child: CustomActionButton(
//                           buttonText: "Apply",
//                           onTap: () {
//                             setState(() {
//                               selectedTeam = tempTeam;
//                               selectedGraduationYear = tempYear;
//                               selectedPosition = tempPosition;
//                               selectedSortBy = tempSortBy;
//                             });
//                             Navigator.pop(context);
//                           },
//                           backgroundColor: kSecondaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildDropdownField({
//     required String hint,
//     String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonFormField<String>(
//         initialValue: value,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(color: Colors.grey[600]),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//         icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
//         items: items.map((String item) {
//           return DropdownMenuItem<String>(value: item, child: Text(item));
//         }).toList(),
//         onChanged: onChanged,
//         dropdownColor: Colors.white,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BlueAppBar(showBackArrow: false, height: 100, title: 'Athletes'),
//       body: BlocBuilder<HomeBloc, HomeState>(
//         builder: (context, state) {
//           if (state.status == HomeStateStatus.loading) {
//             return athleteShimmerEffect(10);
//           }
//           final athletes = state.scannedAthletes;
//           if (athletes.isEmpty) {
//             return buildEmptyWidget();
//           }
//           final filteredAthletes = _getFilteredAthletes(athletes);
//           return Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey[300]!),
//                         ),
//                         child: TextField(
//                           controller: searchController,
//                           onChanged: (value) => setState(() {}),
//                           decoration: InputDecoration(
//                             hintText: 'Search here',
//                             hintStyle: TextStyle(color: Colors.grey[400]),
//                             prefixIcon: Icon(
//                               Icons.search,
//                               color: Colors.grey[400],
//                             ),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     12.widthBox,
//                     GestureDetector(
//                       onTap: () => _showFilterBottomSheet(athletes),
//                       child: Container(
//                         padding: EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey[300]!),
//                         ),
//                         child: SvgPicture.asset(Assets.svg.filterIcon.path),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: CustomScrollView(
//                   slivers: [
//                     SliverPadding(
//                       padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
//                       sliver: SliverToBoxAdapter(
//                         child: Text(
//                           'Scanned Athletes',
//                           style: AppStyles.titleSemibold.copyWith(
//                             color: kBlackColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SliverPadding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: Dim.PADDING_SIZE_DEFAULT,
//                       ),
//                       sliver: filteredAthletes.isEmpty
//                           ? SliverToBoxAdapter(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(32.0),
//                                   child: Column(
//                                     children: [
//                                       Icon(
//                                         Icons.search_off,
//                                         size: 64,
//                                         color: Colors.grey[400],
//                                       ),
//                                       SizedBox(height: 16),
//                                       Text(
//                                         'No athletes found',
//                                         style: AppStyles.bodyRegular.copyWith(
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : SliverList(
//                               delegate: SliverChildBuilderDelegate((
//                                 context,
//                                 index,
//                               ) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 12),
//                                   child: ScannedAthleteCardWidget(
//                                     athlete: filteredAthletes[index],
//                                     onTap: () {
//                                       debugPrint(
//                                         'Tapped on ${filteredAthletes[index].scannedUserProfile?.fullName}',
//                                       );
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               AthleteProfileScreen(
//                                                 athleteId:
//                                                     filteredAthletes[index]
//                                                         .scannedUserProfile
//                                                         ?.id ??
//                                                     -1,
//                                               ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 );
//                               }, childCount: filteredAthletes.length),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
