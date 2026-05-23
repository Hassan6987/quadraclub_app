// ─────────────────────────────────────────────
//  METRICS OVERVIEW WIDGET
// ─────────────────────────────────────────────

import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_timeline.dart';

import '../../../app_exports.dart';

class MetricsOverviewWidget extends StatelessWidget {
  final List<AthleteTimeline> timelineMetrics;

  const MetricsOverviewWidget({super.key, required this.timelineMetrics});

  static const _navyColor = kPrimaryColor;
  static const _goldColor = kSecondaryColor;

  @override
  Widget build(BuildContext context) {
    final active = timelineMetrics
        .where((m) => m.timelineData.isNotEmpty)
        .toList();

    if (active.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No metrics recorded yet.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: active.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        // Even index → line chart (navy), Odd index → bar chart (gold)
        final isBar = index.isOdd;
        final color = isBar ? _goldColor : _navyColor;

        return _MetricCard(
          timeline: active[index],
          isBar: isBar,
          chartColor: color,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  SINGLE METRIC CARD
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
//  SINGLE METRIC CARD
// ─────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final AthleteTimeline timeline;
  final bool isBar;
  final Color chartColor;

  static const _gridColor = Color(0xFFE8E8E8);
  static const _labelColor = Color(0xFF9E9E9E);
  static const _accentColor = Color(0xFFBFA14A);

  // Units where LOWER value = better performance
  static const _lowerIsBetterUnits = ['sec', 's', 'seconds'];

  const _MetricCard({
    required this.timeline,
    required this.isBar,
    required this.chartColor,
  });

  bool get _lowerIsBetter =>
      _lowerIsBetterUnits.contains(timeline.unit.toLowerCase().trim());

  double? _bestValue(List<double> vals) {
    if (vals.isEmpty) return null;
    return _lowerIsBetter
        ? vals.reduce((a, b) => a < b ? a : b) // lowest = best for time units
        : vals.reduce(
            (a, b) => a > b ? a : b,
          ); // highest = best for speed units
  }

  List<String> _yLabels(double min, double max, {int steps = 4}) {
    return List.generate(steps + 1, (i) {
      final v = max - (max - min) * i / steps;
      return v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ── Limit to last 6 events ──
    final recentData = timeline.timelineData.length > 6
        ? timeline.timelineData.sublist(timeline.timelineData.length - 6)
        : timeline.timelineData;

    final values = recentData.map((d) => d.value).toList();
    final xLabels = List.generate(values.length, (i) => 'Event ${i + 1}');

    final maxVal = values.isNotEmpty
        ? values.reduce((a, b) => a > b ? a : b) * 1.15
        : 1.0;
    final minVal = values.isNotEmpty
        ? values.reduce((a, b) => a < b ? a : b) * 0.85
        : 0.0;

    final best = _bestValue(values);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(12, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${timeline.displayName} (${timeline.unit})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B2A4A),
                  ),
                ),
              ),
              if (best != null)
                Text(
                  'Best: ${best % 1 == 0 ? best.toInt() : best.toStringAsFixed(2)}'
                  ' ${timeline.unit} ${_lowerIsBetter ? '↓' : '↑'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _accentColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Chart ──
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _YAxisLabels(
                  labels: _yLabels(minVal, maxVal),
                  color: _labelColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _ChartPainter(
                            values: values,
                            maxValue: maxVal,
                            minValue: minVal,
                            isBar: isBar,
                            chartColor: chartColor,
                            gridColor: _gridColor,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _XAxisLabels(labels: xLabels, color: _labelColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Y-AXIS LABELS
// ─────────────────────────────────────────────

class _YAxisLabels extends StatelessWidget {
  final List<String> labels;
  final Color color;

  const _YAxisLabels({required this.labels, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: labels
            .map((l) => Text(l, style: TextStyle(fontSize: 10, color: color)))
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  X-AXIS LABELS
// ─────────────────────────────────────────────

class _XAxisLabels extends StatelessWidget {
  final List<String> labels;
  final Color color;

  const _XAxisLabels({required this.labels, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: labels
          .map(
            (l) => Expanded(
              child: Text(
                l,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, color: color),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  CHART PAINTER
// ─────────────────────────────────────────────

class _ChartPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;
  final double minValue;
  final bool isBar;
  final Color chartColor;
  final Color gridColor;

  const _ChartPainter({
    required this.values,
    required this.maxValue,
    required this.minValue,
    required this.isBar,
    required this.chartColor,
    required this.gridColor,
  });

  double _toY(double value, double height) {
    final range = (maxValue - minValue).clamp(0.001, double.infinity);
    return height - ((value - minValue) / range) * height;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Grid lines
    const steps = 4;
    for (int i = 0; i <= steps; i++) {
      final dy = size.height * i / steps;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    final paint = Paint()
      ..color = chartColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = chartColor
      ..style = PaintingStyle.fill;

    final n = values.length;
    // Space points evenly; single point gets centered
    final xStep = n > 1 ? size.width / (n - 1) : size.width / 2;

    double xOf(int i) => n > 1 ? i * xStep : size.width / 2;
    double yOf(int i) => _toY(values[i], size.height);

    if (isBar) {
      // ── Bar chart ──
      final barWidth = (size.width / n) * 0.55;
      final spacing = size.width / n;
      for (int i = 0; i < n; i++) {
        final cx = spacing * i + spacing / 2;
        final top = yOf(i);
        final rect = Rect.fromLTWH(
          cx - barWidth / 2,
          top,
          barWidth,
          size.height - top,
        );
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            rect,
            topLeft: const Radius.circular(3),
            topRight: const Radius.circular(3),
          ),
          fillPaint,
        );
      }
    } else {
      // ── Line chart ──
      final path = Path()..moveTo(xOf(0), yOf(0));
      for (int i = 1; i < n; i++) {
        path.lineTo(xOf(i), yOf(i));
      }
      canvas.drawPath(path, paint);

      // Dots
      final dotPaint = Paint()
        ..color = chartColor
        ..style = PaintingStyle.fill;
      for (int i = 0; i < n; i++) {
        canvas.drawCircle(Offset(xOf(i), yOf(i)), 5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.values != values || old.isBar != isBar;
}
