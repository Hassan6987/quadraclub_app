import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/agenda_chat_screen.dart';
import 'package:quadraclub_app/presentation/classes/data/classes_repo.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class AgendaClassCard extends StatefulWidget {
  final AgendaItem item;
  final String? actionLabel;

  const AgendaClassCard({super.key, required this.item, this.actionLabel});

  @override
  State<AgendaClassCard> createState() => _AgendaClassCardState();
}

class _AgendaClassCardState extends State<AgendaClassCard> {
  bool _openingDetails = false;

  Future<void> _openClassDetails() async {
    if (_openingDetails) return;
    if (widget.item.id.isEmpty) return;

    setState(() => _openingDetails = true);

    try {
      final classModel = await locator.get<ClassesRepo>().getClassById(
        widget.item.id,
      );
      if (!mounted) return;

      final distance = (classModel.distanceKm is num)
          ? (classModel.distanceKm as num).toDouble()
          : 0.0;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClassDetailsScreen(
            classModel: classModel,
            distanceKm: distance,
            isFromClass: false,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      context.showToast(
        AppLocalizations.of(context)!.somethingWentWrong,
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _openingDetails = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final actionLabel = widget.actionLabel;

    return GestureDetector(
      onTap: _openClassDetails,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderF0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SportBadge(
                      sport: SportTypeExtension.fromString(item.sport),
                    ),
                    if (item.classType != null) ...[
                      4.widthBox,
                      CommonBadge(
                        label: _localizedClassType(context, item.classType!),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      formatPriceWhole(item.price),
                      style: AppStyles.w600f14inter.copyWith(color: kBlueF1),
                    ),
                  ],
                ),
                8.heightBox,
                Text(
                  item.title,
                  style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
                ),
                3.heightBox,
                Text(
                  item.dateString,
                  style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                ),
                Divider(color: kDividerColor).withPaddingSymmetric(0, 8),
                Row(
                  children: [
                    AppCachedImage(
                      imageUrl: item.coachPhoto ?? '',
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    10.widthBox,
                    Text(
                      '${AppLocalizations.of(context)!.coach} ',
                      style: AppStyles.w400f14inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
                    Text(
                      item.coachName ?? '',
                      style: AppStyles.w500f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ],
                ),
                if (actionLabel != null)
                  CustomActionButton(
                    buttonText: actionLabel == 'Cancel request'
                        ? AppLocalizations.of(context)!.cancelRequest
                        : AppLocalizations.of(context)!.chat,
                    backgroundColor: actionLabel == 'Cancel request'
                        ? kLightPinkColor
                        : kPrimaryColor,
                    onTap: () {
                      if (actionLabel == 'Cancel request') {
                        context.read<AgendaBloc>().add(
                          CancelClassRequest(classId: item.id),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AgendaChatScreen(
                              chatId: item.chatId ?? '',
                              label: item.title,
                              userCount: item.players?.length ?? 1,
                              classId: item.id,
                            ),
                          ),
                        );
                      }
                    },
                  ).paddingOnly(top: 16),
              ],
            ),
          ),
          if (_openingDetails)
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0x33000000),
                child: const Center(child: CustomLoadingView()),
              ),
            ),
        ],
      ),
    );
  }

  String _localizedClassType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case 'group':
        return l10n.group;
      case 'individual':
        return l10n.individual;
      default:
        return type;
    }
  }
}
