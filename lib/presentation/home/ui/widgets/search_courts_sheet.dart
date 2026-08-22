import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/models/court_model.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/mock_keyboard.dart';

class SearchCourtsSheet extends StatefulWidget {
  final List<Court> courts;
  final Function(Court) onCourtSelected;

  const SearchCourtsSheet({
    super.key,
    required this.courts,
    required this.onCourtSelected,
  });

  static Future<void> show(BuildContext context, {
    required List<Court> courts,
    required Function(Court) onCourtSelected,
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
  List<Court> _searchResults = [];

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
      setState(() => _searchResults = []);
    } else {
      setState(() {
        _searchResults = widget.courts.where((court) {
          final name = (court.courtName ?? '').toLowerCase();
          final location = (court.location ?? '').toLowerCase();
          return name.contains(query) || location.contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Courts',
                  style: AppStyles.w600f18inter.copyWith(
                      color: kDarkTextColor, fontSize: 20),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                      Icons.close, color: kDarkTextColor, size: 24),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: kBorderColor),
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
                      readOnly: true,
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
                    court.courtName ?? '',
                    style: AppStyles.w600f14inter.copyWith(
                        color: kDarkTextColor),
                  ),
                  subtitle: Text(
                    [court.location, court.courtOwner]
                        .where((s) => s != null && s.isNotEmpty)
                        .join(' • '),
                    style: AppStyles.w400f12inter.copyWith(color: kTextColor),
                  ),
                  onTap: () {
                    widget.onCourtSelected(court);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          MockKeyboard(
            controller: _controller,
            onSend: () => Navigator.pop(context),
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
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16)),
          ),
          const SizedBox(height: 12),
          Container(
            height: 16,
            width: 140,
            decoration: BoxDecoration(color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4)),
          ),
        ],
      ),
    );
  }
}