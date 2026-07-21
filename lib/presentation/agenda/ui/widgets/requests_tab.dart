import '../../../../app_exports.dart';

class RequestsTab extends StatelessWidget {
  final List<MatchRequest> _requests = [
    MatchRequest(
      name: 'Alex Rivers',
      imageUrl: playerOneImageUrl,
      message: 'Please Accept my request. I\'ll be there on time.',
    ),
    MatchRequest(
      name: 'John Doe',
      imageUrl: playerTwoImageUrl,
      message: null,
    ),
  ];

   RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
      itemCount: _requests.length,
      separatorBuilder: (_, _) => 12.heightBox,
      itemBuilder: (context, index) {
        final request = _requests[index];
        return _requestItem(request);
      },
    );
  }

  Widget _requestItem(MatchRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppCachedImage(
              imageUrl: request.imageUrl,
              height: 48,
              width: 48,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(999),
            ),
            10.widthBox,
            Expanded(
              child: Text(
                request.name,
                style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
              ),
            ),
            8.widthBox,
            _actionButton(Icons.close, kRedColor, () {}),
            8.widthBox,
            _actionButton(Icons.check, kGreenColor, () {}),
          ],
        ),
        if (request.message != null) ...[
          6.heightBox,
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              request.message!,
              style: AppStyles.w400f14inter.copyWith(
                color: kBlack12Color,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kBorderColor)
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}