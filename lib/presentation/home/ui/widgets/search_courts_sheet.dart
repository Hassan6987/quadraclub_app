import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/mock_keyboard.dart';

class SearchCourtsSheet extends StatefulWidget {
  final List<CourtModel> courts;
  final Function(CourtModel) onCourtSelected;

  const SearchCourtsSheet({
    super.key,
    required this.courts,
    required this.onCourtSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required List<CourtModel> courts,
    required Function(CourtModel) onCourtSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SearchCourtsSheet(
        courts: courts,
        onCourtSelected: onCourtSelected,
      ),
    );
  }

  @override
  State<SearchCourtsSheet> createState() => _SearchCourtsSheetState();
}

class _SearchCourtsSheetState extends State<SearchCourtsSheet> {
  final TextEditingController _controller = TextEditingController();
  List<CourtModel> _searchResults = [];

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
        _searchResults = [];
      });
    } else {
      setState(() {
        _searchResults = widget.courts
            .where((court) =>
                court.name.toLowerCase().contains(query) ||
                court.location.toLowerCase().contains(query))
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
                  'Search Courts',
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
          // Search Field
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
                  const Icon(Icons.search, color: kTextColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      readOnly: true, // we use mock keyboard
                      decoration: const InputDecoration(
                        hintText: 'Search courts',
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
          // Search Results / Skeleton Loader
          Expanded(
            child: _controller.text.isEmpty
                ? _buildSkeletonLoader()
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          'No courts found',
                          style: AppStyles.w400f14inter.copyWith(color: kTextColor),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => const Divider(color: kBorderColor),
                        itemBuilder: (context, index) {
                          final court = _searchResults[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AppCachedImage(
                                imageUrl: court.imageUrl,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            title: Text(
                              court.name,
                              style: AppStyles.w600f14inter.copyWith(
                                color: kDarkTextColor,
                              ),
                            ),
                            subtitle: Text(
                              '${court.location} • ${court.distanceMiles} miles',
                              style: AppStyles.w400f12inter.copyWith(
                                color: kTextColor,
                              ),
                            ),
                            onTap: () {
                              widget.onCourtSelected(court);
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large grey box
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 12),
          // Small text line 1
          Container(
            height: 16,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          // Small text line 2
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
