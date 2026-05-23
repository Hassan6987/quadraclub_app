// ============ VIDEO LIST WIDGET ============

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../app_exports.dart';

class VideoListWidget extends StatelessWidget {
  final List<String> videoUrls;
  final double itemHeight;
  final double spacing;
  final Function(String videoUrl)? onVideoTap;
  final bool isFromHome;

  const VideoListWidget({
    super.key,
    required this.videoUrls,
    this.itemHeight = 200,
    this.spacing = 16,
    this.onVideoTap,
    required this.isFromHome,
  });

  @override
  Widget build(BuildContext context) {
    if (videoUrls.isEmpty) {
      return _buildEmptyState();
    }
    if (isFromHome) {
      return Column(
        children: List.generate(
          videoUrls.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index < videoUrls.length - 1 ? spacing : 0,
            ),
            child: VideoThumbnailCard(
              videoUrl: videoUrls[index],
              height: itemHeight,
              onTap: () => onVideoTap?.call(videoUrls[index]),
              isFromHome: isFromHome,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: videoUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 80,
            child: VideoThumbnailCard(
              videoUrl: videoUrls[index],
              height: 80,
              onTap: () => onVideoTap?.call(videoUrls[index]),
              isFromHome: isFromHome,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No videos available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ VIDEO THUMBNAIL CARD ============

class VideoThumbnailCard extends StatefulWidget {
  final String videoUrl;
  final double height;
  final VoidCallback? onTap;
  final bool isFromHome;

  const VideoThumbnailCard({
    super.key,
    required this.videoUrl,
    this.height = 200,
    this.onTap,
    required this.isFromHome,
  });

  @override
  State<VideoThumbnailCard> createState() => _VideoThumbnailCardState();
}

class _VideoThumbnailCardState extends State<VideoThumbnailCard> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final uri = Uri.parse(widget.videoUrl);
      final tempDir = await getTemporaryDirectory();
      final tempVideo = File('${tempDir.path}/${uri.pathSegments.last}');
      if (!await tempVideo.exists()) {
        final response = await http.get(uri);
        await tempVideo.writeAsBytes(response.bodyBytes);
      }
      final thumb = await VideoThumbnail.thumbnailData(
        video: tempVideo.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 75,
      );
      if (mounted) {
        setState(() => _thumbnail = thumb);
      }
    } catch (e) {
      debugPrint("Thumbnail error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(widget.isFromHome ? 16 : 8),
          boxShadow: widget.isFromHome
              ? [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.isFromHome ? 16 : 8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ✅ Show generated thumbnail
              if (_thumbnail != null)
                Image.memory(_thumbnail!, fit: BoxFit.cover)
              else
                _buildPlaceholder(),

              // Overlay (only on home big cards)
              if (widget.isFromHome)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),

              // Play button (only on home big cards)
              if (widget.isFromHome)
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 40,
                      color: kPrimaryColor,
                    ),
                  ),
                ),

              if (!widget.isFromHome)
                Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 20,
                      color: kWhiteColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[400],
      child: const Center(
        child: Icon(Icons.videocam_outlined, size: 32, color: Colors.white),
      ),
    );
  }
}
