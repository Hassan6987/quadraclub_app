import 'dart:math' as math;

import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';

import '/app_exports.dart';

class ParticipantsRow extends StatelessWidget {
  final Class classModel;

  const ParticipantsRow({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final maxStudents = classModel.maxStudents ?? 0;
    final current =
        classModel.currentParticipants ?? classModel.participants.length;
    final slotsLeft =
        classModel.slotsLeft ?? math.max(0, maxStudents - current);
    final isFull =
        classModel.isFull == true || (maxStudents > 0 && slotsLeft <= 0);

    return Row(
      children: [
        _ParticipantsAvatars(
          imageUrls: classModel.participants
              .map((c) => c.profilePhoto ?? '')
              .where((u) => u.isNotEmpty)
              .toList(),
          filledCount: current,
          emptyCount: isFull ? 0 : slotsLeft,
        ),
        14.widthBox,
        Text(
          '$current/$maxStudents',
          style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
        const Spacer(),
        Text(
          isFull ? l10n.full : l10n.slotsLeftCount(slotsLeft),
          style: AppStyles.w500f12inter.copyWith(
            color: isFull ? kGreyTextColor : kBlueColor,
          ),
        ),
      ],
    );
  }
}

/// Filled photos (max 3) + either a "+N" overflow or empty dashed "+" slots.
class _ParticipantsAvatars extends StatelessWidget {
  const _ParticipantsAvatars({
    required this.imageUrls,
    required this.filledCount,
    required this.emptyCount,
  });

  final List<String> imageUrls;
  final int filledCount;
  final int emptyCount;

  static const _maxVisible = 3;
  static const _avatarSize = 32.0;
  static const _overlap = 20.0;

  @override
  Widget build(BuildContext context) {
    final photos = imageUrls.take(_maxVisible).toList();
    // When photos are missing, still reserve slots for the filled count.
    final photoSlots = math.max(
      photos.length,
      math.min(filledCount, _maxVisible),
    );
    final overflow = filledCount - photoSlots;
    final showOverflow = overflow > 0;
    final emptyToShow = showOverflow
        ? 0
        : math.min(emptyCount, math.max(0, _maxVisible - photoSlots));

    final circleCount = photoSlots + (showOverflow ? 1 : emptyToShow);
    if (circleCount <= 0) {
      return const CommonPlusAvatar(size: _avatarSize);
    }

    final width = ((circleCount - 1) * _overlap) + _avatarSize;

    return SizedBox(
      height: _avatarSize + 6,
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < photoSlots; i++)
            Positioned(
              left: i * _overlap,
              child: AppCachedImage(
                borderRadius: BorderRadius.circular(200),
                height: _avatarSize,
                width: _avatarSize,
                imageUrl: i < photos.length ? photos[i] : '',
                border: Border.all(color: kWhiteColor, width: 2),
              ),
            ),
          if (showOverflow)
            Positioned(
              left: photoSlots * _overlap,
              child: Container(
                height: _avatarSize,
                width: _avatarSize,
                decoration: BoxDecoration(
                  color: kGreyColor,
                  borderRadius: BorderRadius.circular(200),
                  border: Border.all(color: kWhiteColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$overflow',
                    style: AppStyles.w500f12inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ),
              ),
            )
          else
            for (var i = 0; i < emptyToShow; i++)
              Positioned(
                left: (photoSlots + i) * _overlap,
                child: const CommonPlusAvatar(size: _avatarSize),
              ),
        ],
      ),
    );
  }
}
