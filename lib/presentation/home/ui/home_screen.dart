import 'dart:developer';

import 'package:shimmer/shimmer.dart';
import 'package:quadraclub_app/presentation/athletes/ui/widgets/scanned_athlete_card_widget.dart';
import 'package:quadraclub_app/presentation/authentication/ui/widgets/nfc_scan_dialog.dart';
import 'package:quadraclub_app/presentation/home/bloc/home_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/athlete_model.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/notification_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/qr_code_scanner.dart';
import 'package:quadraclub_app/utils/components/custom_dialogue.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

import '/app_exports.dart';
import '../../../utils/components/blue_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueAppBar(
        showBackArrow: false,
        titleWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi', style: AppStyles.subHeadingSemibold),
            Text('Welcome Back!', style: AppStyles.bodyRegular),
          ],
        ),
        actionButton: IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          },
        ),
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStateStatus.scanned) {
            context.showToast("Wristband scanned successfully!");
          } else if (state.status == HomeStateStatus.received) {
            context.showToast("QR code scanned successfully!");
          } else if (state.status == HomeStateStatus.error) {
            context.showToast(
              state.error ?? "Error scanning wristband. Please try again.",
              isError: true,
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Last Scanned',
                        style: AppStyles.titleSemibold.copyWith(
                          color: kBlackColor,
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state.status == HomeStateStatus.loading) {
                        return athleteShimmerEffect(5);
                      }

                      final athletes = List<AthleteModel>.from(
                        state.scannedAthletes,
                      );
                      athletes.sort((a, b) {
                        final scanA = a.scannedAt ?? DateTime(1970);
                        final scanB = b.scannedAt ?? DateTime(1970);
                        return scanB.compareTo(scanA);
                      });

                      if (athletes.isEmpty) {
                        return SliverToBoxAdapter(child: buildEmptyWidget());
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dim.PADDING_SIZE_DEFAULT,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ScannedAthleteCardWidget(
                                athlete: athletes[index],
                                onTap: () {
                                  debugPrint(
                                    'Tapped on ${athletes[index].scannedUserProfile?.fullName}',
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         AthleteProfileScreen(
                                  //           athleteId:
                                  //               athletes[index]
                                  //                   .scannedUserProfile
                                  //                   ?.id ??
                                  //               -1,
                                  //         ),
                                  //   ),
                                  // );
                                },
                              ),
                            );
                          }, childCount: athletes.length),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomActionButton(
                      buttonText: 'Athlete NFC Scan',
                      onTap: () => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => NfcScanDialog(
                          onSuccess: () => _handleSuccess(context),
                          onScan: (nfcId) => context.read<HomeBloc>().add(
                            ScanNFCTag(nfcId: nfcId),
                          ),
                        ),
                      ),
                      backgroundColor: kSecondaryColor,
                    ),
                    16.heightBox,
                    CustomActionButton(
                      buttonText: 'Scan via QR Code',
                      onTap: () => _navigateToQrScanner(context),
                      borderColor: kSecondaryColor,
                      backgroundColor: kWhiteColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToQrScanner(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrScanScreen()),
    );

    // If a QR code was scanned
    if (result != null && mounted) {
      // Print the scanned data
      log('QR Code Data: $result && datatype is ${result.runtimeType}');
      context.read<HomeBloc>().add(ScanQRCode(userId: result));
      _handleSuccess(context);
    }
  }

  void _handleSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Linked',
        buttonText: 'Done',
        onButtonTap: () {
          Navigator.pop(context);
        },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(Assets.svg.nfcLinked.path, height: 50, width: 50),
            Text(
              'Wristband scanned successfully!',
              style: AppStyles.titleMedium.copyWith(color: kBlackColor),
              textAlign: TextAlign.center,
            ),
          ],
        ).withPaddingSymmetric(16, 0),
      ),
    );
  }
}

Widget athleteShimmerEffect(int count) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_DEFAULT),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                padding: const EdgeInsets.all(Dim.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(Dim.RADIUS_SMALL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar shimmer
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    8.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name shimmer
                          Container(
                            width: double.infinity,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          8.heightBox,
                          // Position shimmer
                          Container(
                            width: 100,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Year shimmer
                    Container(
                      width: 50,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: count, // Show 5 shimmer cards
      ),
    ),
  );
}

Widget buildEmptyWidget({String? message}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            message ?? 'No athletes scanned yet',
            style: AppStyles.bodyRegular.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}
