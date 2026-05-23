import 'package:shimmer/shimmer.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '../../../app_exports.dart';

class AthleteProfileShimmer extends StatelessWidget {
  const AthleteProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [_profileCardShimmer(), 16.heightBox, _notesSectionShimmer()],
      ),
    );
  }

  Widget _profileCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(radius: 50, backgroundColor: Colors.white),
            12.heightBox,

            // Rating
            Container(height: 16, width: 80, color: Colors.white),
            20.heightBox,

            // Info rows
            ...List.generate(
              5,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 14, width: 100, color: Colors.white),
                    Container(height: 14, width: 120, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesSectionShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        3,
        (_) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dim.PADDING_SIZE_DEFAULT,
              vertical: 8,
            ),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date + Type row
                Row(
                  children: [
                    Container(
                      height: 18,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    8.widthBox,
                    Container(
                      height: 18,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
                12.heightBox,

                // Note lines
                Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.white,
                ),
                8.heightBox,
                Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.white,
                ),
                8.heightBox,
                Container(height: 12, width: 200, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
