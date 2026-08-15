// import 'dart:developer';
//
// import 'package:quadraclub_app/presentation/authentication/ui/widgets/nfc_scan_dialog.dart';
// import 'package:quadraclub_app/presentation/home/ui/widgets/athlete_card_widget.dart';
// import 'package:quadraclub_app/presentation/home/ui/widgets/qr_code_scanner.dart';
// import 'package:quadraclub_app/presentation/home/ui/widgets/team_roster_screen.dart';
// import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
// import 'package:quadraclub_app/presentation/team_roster/data/team_roster_model.dart';
// import 'package:quadraclub_app/presentation/team_roster/ui/roster_athlete_detail_screen.dart';
// import 'package:quadraclub_app/presentation/teams/bloc/teams_bloc.dart';
// import 'package:quadraclub_app/utils/components/custom_dialogue.dart';
// import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
// import 'package:quadraclub_app/utils/extensions/padding_extension.dart';
//
// import '/app_exports.dart';
// import '../../../utils/components/blue_app_bar.dart';
//
// class MyTeamRosterScreen extends StatefulWidget {
//   const MyTeamRosterScreen({super.key});
//
//   @override
//   State<MyTeamRosterScreen> createState() => _MyTeamRosterScreenState();
// }
//
// class _MyTeamRosterScreenState extends State<MyTeamRosterScreen> {
//   TextEditingController searchController = TextEditingController();
//
//   String? selectedTeam;
//   String? selectedGraduationYear;
//   String? selectedPosition;
//   String? selectedSortBy;
//
//   List<String> getAvailableTeams(List<TeamRoster> athletes) {
//     return athletes
//         .where((a) => a.athleteProfile?.teamName != null)
//         .map((a) => a.athleteProfile!.teamName!)
//         .toSet()
//         .toList()
//       ..sort();
//   }
//
//   List<String> getAvailableYears(List<TeamRoster> athletes) {
//     return athletes
//         .where((a) => a.athleteProfile?.graduationYear != null)
//         .map((a) => a.athleteProfile!.graduationYear!.toString())
//         .toSet()
//         .toList()
//       ..sort((a, b) => b.compareTo(a));
//   }
//
//   List<String> getAvailablePositions(List<TeamRoster> athletes) {
//     return athletes
//         .where((a) => a.athleteProfile?.position != null)
//         .map((a) => a.athleteProfile!.position!)
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
//   List<TeamRoster> _getFilteredAthletes(List<TeamRoster> athletes) {
//     List<TeamRoster> filtered = athletes.where((athlete) {
//       final profile = athlete.athleteProfile;
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
//         final nameA = a.athleteProfile?.fullName ?? '';
//         final nameB = b.athleteProfile?.fullName ?? '';
//         return nameA.compareTo(nameB);
//       });
//     } else if (selectedSortBy == 'Name Z-A') {
//       filtered.sort((a, b) {
//         final nameA = a.athleteProfile?.fullName ?? '';
//         final nameB = b.athleteProfile?.fullName ?? '';
//         return nameB.compareTo(nameA);
//       });
//     } else if (selectedSortBy == 'Graduation Year') {
//       filtered.sort((a, b) {
//         final yearA = a.athleteProfile?.graduationYear ?? 0;
//         final yearB = b.athleteProfile?.graduationYear ?? 0;
//         return yearB.compareTo(yearA);
//       });
//     }
//     // If 'Recently Scanned' or null, sort by scannedAt date (most recent first)
//     else {
//       filtered.sort((a, b) {
//         final dateA = a.savedAt ?? DateTime(1970);
//         final dateB = b.savedAt ?? DateTime(1970);
//         return dateB.compareTo(dateA);
//       });
//     }
//
//     return filtered;
//   }
//
//   void _showFilterBottomSheet(List<TeamRoster> athletes) {
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
//       body: BlocListener<TeamsBloc, TeamsState>(
//         listener: (context, state) {
//           if (state.status == TeamStateStatus.scanned) {
//             context.showToast("Wristband scanned successfully!");
//             if (state.scannedTeam != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TeamRosterScreen()),
//               );
//             }
//           } else if (state.status == TeamStateStatus.received) {
//             context.showToast("QR code scanned successfully!");
//             if (state.scannedTeam != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TeamRosterScreen()),
//               );
//             }
//           } else if (state.status == TeamStateStatus.error) {
//             context.showToast(
//               state.error ?? "Error scanning wristband. Please try again.",
//               isError: true,
//             );
//           }
//         },
//         child: BlocBuilder<TeamRosterBloc, TeamRosterState>(
//           builder: (context, state) {
//             if (state.status == RosterStateStatus.loading) {
//               return athleteShimmerEffect(10);
//             }
//             final athletes = state.roster;
//             if (athletes.isEmpty) {
//               return Column(
//                 children: [
//                   buildEmptyWidget(
//                     message: "No athletes found. Start adding to your roster!",
//                   ),
//                   Spacer(),
//                   CustomActionButton(
//                     buttonText: 'Team NFC Scan',
//                     onTap: () => showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (_) => NfcScanDialog(onSuccess: () {}),
//                     ),
//                     backgroundColor: kSecondaryColor,
//                   ).withPaddingSymmetric(16, 0),
//                   16.heightBox,
//                   CustomActionButton(
//                     buttonText: 'Scan via QR Code',
//                     onTap: () => _navigateToQrScanner(context),
//                     borderColor: kSecondaryColor,
//                     backgroundColor: kWhiteColor,
//                   ).withPaddingSymmetric(16, 0),
//                 ],
//               );
//             }
//             final filteredAthletes = _getFilteredAthletes(athletes);
//             return Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey[300]!),
//                           ),
//                           child: TextField(
//                             controller: searchController,
//                             onChanged: (value) => setState(() {}),
//                             decoration: InputDecoration(
//                               hintText: 'Search here',
//                               hintStyle: TextStyle(color: Colors.grey[400]),
//                               prefixIcon: Icon(
//                                 Icons.search,
//                                 color: Colors.grey[400],
//                               ),
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       12.widthBox,
//                       GestureDetector(
//                         onTap: () => _showFilterBottomSheet(athletes),
//                         child: Container(
//                           padding: EdgeInsets.all(14),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey[300]!),
//                           ),
//                           child: SvgPicture.asset(Assets.svg.filterIcon.path),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: CustomScrollView(
//                     slivers: [
//                       SliverPadding(
//                         padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
//                         sliver: SliverToBoxAdapter(
//                           child: Text(
//                             'Saved Athletes',
//                             style: AppStyles.titleSemibold.copyWith(
//                               color: kBlackColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SliverPadding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: Dim.PADDING_SIZE_DEFAULT,
//                         ),
//                         sliver: filteredAthletes.isEmpty
//                             ? SliverToBoxAdapter(
//                                 child: Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(32.0),
//                                     child: Column(
//                                       children: [
//                                         Icon(
//                                           Icons.search_off,
//                                           size: 64,
//                                           color: Colors.grey[400],
//                                         ),
//                                         SizedBox(height: 16),
//                                         Text(
//                                           'No athletes found',
//                                           style: AppStyles.bodyRegular.copyWith(
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : SliverList(
//                                 delegate: SliverChildBuilderDelegate((
//                                   context,
//                                   index,
//                                 ) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(bottom: 12),
//                                     child: AthleteCardWidget(
//                                       athlete: filteredAthletes[index],
//                                       onTap: () {
//                                         context.read<TeamRosterBloc>().add(
//                                           FetchTeamRosterDetails(
//                                             playerId:
//                                                 filteredAthletes[index].id ??
//                                                 -1,
//                                           ),
//                                         );
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 RosterProfileScreen(
//                                                   athleteId:
//                                                       filteredAthletes[index]
//                                                           .id ??
//                                                       -1,
//                                                 ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   );
//                                 }, childCount: filteredAthletes.length),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 CustomActionButton(
//                   buttonText: 'Team NFC Scan',
//                   onTap: () => showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (_) => NfcScanDialog(onSuccess: () {}),
//                   ),
//                   backgroundColor: kSecondaryColor,
//                 ).withPaddingSymmetric(16, 0),
//                 16.heightBox,
//                 CustomActionButton(
//                   buttonText: 'Scan via QR Code',
//                   onTap: () => _navigateToQrScanner(context),
//                   borderColor: kSecondaryColor,
//                   backgroundColor: kWhiteColor,
//                 ).withPaddingSymmetric(16, 0),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<void> _navigateToQrScanner(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const QrScanScreen()),
//     );
//
//     // If a QR code was scanned
//     if (result != null && mounted) {
//       log('QR Code Data: $result && datatype is ${result.runtimeType}');
//       context.read<TeamsBloc>().add(ScanTeamQR(teamId: result));
//       _handleSuccess(context);
//     }
//   }
//
//   void _handleSuccess(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => CustomDialog(
//         title: 'Linked',
//         buttonText: 'Done',
//         onButtonTap: () {
//           Navigator.pop(context);
//         },
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(Assets.svg.nfcLinked.path, height: 50, width: 50),
//             Text(
//               'Wristband scanned successfully!',
//               style: AppStyles.titleMedium.copyWith(color: kBlackColor),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ).withPaddingSymmetric(16, 0),
//       ),
//     );
//   }
// }
