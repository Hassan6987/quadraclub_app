import '/app_exports.dart';

class ClubFeedbackDialog extends StatefulWidget {
  final void Function(int rating, String feedback) onComplete;

  const ClubFeedbackDialog({super.key, required this.onComplete});

  static Future<void> show(
    BuildContext context, {
    required void Function(int rating, String feedback) onComplete,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ClubFeedbackDialog(onComplete: onComplete),
    );
  }

  @override
  State<ClubFeedbackDialog> createState() => _ClubFeedbackDialogState();
}

class _ClubFeedbackDialogState extends State<ClubFeedbackDialog> {
  int _rating = 0;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.clubsFeedback,
                  style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 22,
                    color: kDarkTextColor,
                  ),
                ),
              ],
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final star = index + 1;
                final selected = star <= _rating;
                return GestureDetector(
                  onTap: () => setState(() => _rating = star),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      selected
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 36,
                      color: selected ? kSecondaryColor : kGreyB8,
                    ),
                  ),
                );
              }),
            ),
            16.heightBox,
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.tellUsMoreOptional,
                hintStyle: AppStyles.w400f14inter.copyWith(
                  color: kGreyTextColor,
                ),
                filled: true,
                fillColor: kCardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            20.heightBox,
            CustomActionButton(
              buttonText: l10n.complete,
              backgroundColor: kPrimaryColor,
              height: 48,
              onTap: () {
                if (_rating < 1) {
                  context.showToast(l10n.pleaseRateClub, isError: true);
                  return;
                }
                Navigator.pop(context);
                widget.onComplete(_rating, _controller.text.trim());
              },
            ),
          ],
        ),
      ),
    );
  }
}
