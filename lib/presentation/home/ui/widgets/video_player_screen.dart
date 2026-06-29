import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Check if widgets is still mounted
      if (_isDisposed) return;

      // Get cached file
      final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);

      // Check again before initializing
      if (_isDisposed) return;

      // Initialize video player with cached file
      _videoPlayerController = VideoPlayerController.file(file);

      await _videoPlayerController!.initialize();

      // Check if disposed during initialization
      if (_isDisposed) {
        _videoPlayerController?.dispose();
        return;
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blueAccent,
          handleColor: Colors.blue,
          bufferedColor: Colors.grey,
          backgroundColor: Colors.black54,
        ),
      );

      // Final check before updating state
      if (_isDisposed) {
        _chewieController?.dispose();
        _videoPlayerController?.dispose();
        return;
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
      if (mounted && !_isDisposed) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _chewieController?.pause();
    _chewieController?.dispose();
    _videoPlayerController?.pause();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Ensure controllers are stopped before popping
        _chewieController?.pause();
        _videoPlayerController?.pause();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: BlueAppBar(title: 'Video Player', showBackArrow: true),
        body: Center(
          child: _isLoading
              ? const CustomLoadingView()
              : _chewieController != null
              ? Chewie(controller: _chewieController!)
              : const Text(
                  'Failed to load video',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
