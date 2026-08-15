import '../../../../app_exports.dart';

class DistanceSlider extends StatefulWidget {
final   double distance;
final  ValueChanged<double>? onChanged;

  const DistanceSlider({super.key, required this.distance, this.onChanged});

  @override
  State<DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: kPrimaryColor,
            thumbColor: kWhiteColor,
            inactiveTrackColor: kWhiteF9,

            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 8,
          ),
          child: Slider(
            value: widget.distance,
            padding: EdgeInsets.zero,
            min: 1,
            max: 50,
            onChanged: widget.onChanged,
          ),
        ),
        8.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 km',
              style: AppStyles.w500f12inter.copyWith(color: kGreyTextColor),
            ),
            Text(
              '${widget.distance.toStringAsFixed(0)} km',
              style: AppStyles.w500f12inter.copyWith(color: kGreyTextColor),
            ),
            Text(
              '50 km',
              style: AppStyles.w500f12inter.copyWith(color: kGreyTextColor),
            ),
          ],
        ),
      ],
    );
  }
}
