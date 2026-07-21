import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/mock_keyboard.dart';

class ChangeLocationSheet extends StatefulWidget {
  final Function(String) onLocationSelected;

  const ChangeLocationSheet({
    super.key,
    required this.onLocationSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(String) onLocationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChangeLocationSheet(
        onLocationSelected: onLocationSelected,
      ),
    );
  }

  @override
  State<ChangeLocationSheet> createState() => _ChangeLocationSheetState();
}

class _ChangeLocationSheetState extends State<ChangeLocationSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _locations = [
    'London, UK',
    'New York, USA',
    'Los Angeles, USA',
    'Chicago, USA',
  ];
  List<String> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredLocations = [];
      });
    } else {
      setState(() {
        _filteredLocations = _locations
            .where((loc) => loc.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change Location',
                  style: AppStyles.w600f18inter.copyWith(
                    color: kDarkTextColor,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: kDarkTextColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: kBorderColor),
          // Search Location field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBlackColor, width: 1.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on_outlined, color: kTextColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      readOnly: true, // we use mock keyboard
                      decoration: const InputDecoration(
                        hintText: 'Search location',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppStyles.w400f14inter,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Skeletons or list results
          Expanded(
            child: _controller.text.isEmpty
                ? _buildSkeletonRows()
                : _filteredLocations.isEmpty
                    ? Center(
                        child: Text(
                          'No locations found',
                          style: AppStyles.w400f14inter.copyWith(color: kTextColor),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredLocations.length,
                        separatorBuilder: (_, __) => const Divider(color: kBorderColor),
                        itemBuilder: (context, index) {
                          final loc = _filteredLocations[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.location_on, color: kTextColor),
                            title: Text(
                              loc,
                              style: AppStyles.w500f14inter.copyWith(
                                color: kDarkTextColor,
                              ),
                            ),
                            onTap: () {
                              widget.onLocationSelected(loc);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
          ),
          // Mock Keyboard
          MockKeyboard(
            controller: _controller,
            onSend: () {
              if (_controller.text.isNotEmpty) {
                widget.onLocationSelected(_controller.text);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonRows() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSkeletonLine(width: double.infinity),
          const SizedBox(height: 12),
          _buildSkeletonLine(width: 240),
          const SizedBox(height: 24),
          _buildSkeletonLine(width: double.infinity),
          const SizedBox(height: 12),
          _buildSkeletonLine(width: 200),
        ],
      ),
    );
  }

  Widget _buildSkeletonLine({required double width}) {
    return Container(
      height: 16,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
