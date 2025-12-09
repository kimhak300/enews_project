import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:newshub/app/config/api_constants.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final double? height;
  final double? width;
  final bool autoPlay;
  final bool showControls;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.height,
    this.width,
    this.autoPlay = false,
    this.showControls = true,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      debugPrint('🎬 Original video URL: ${widget.videoUrl}');
      debugPrint('🔍 URL type: ${widget.videoUrl.runtimeType}');
      debugPrint('🔍 URL length: ${widget.videoUrl.length}');
      
      // Check for null or empty URL
      if (widget.videoUrl.isEmpty || widget.videoUrl == 'null') {
        throw Exception('Invalid video URL: URL is null or empty');
      }
      
      final videoUrl = _getFullVideoUrl(widget.videoUrl);
      debugPrint('🎬 Converted video URL: $videoUrl');
      
      // Validate the URL before parsing
      if (!videoUrl.startsWith('http://') && !videoUrl.startsWith('https://')) {
        throw Exception('Invalid video URL: must start with http:// or https://, got: $videoUrl');
      }
      
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      
      await _controller.initialize();
      
      setState(() {
        _isInitialized = true;
      });

      if (widget.autoPlay) {
        _controller.play();
      }

      // Loop video
      _controller.setLooping(true);
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
      debugPrint('❌ Error initializing video: $e');
      debugPrint('❌ Original URL was: ${widget.videoUrl}');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
    }
  }

  String _getFullVideoUrl(String url) {
    print('🔍 _getFullVideoUrl input: "$url"');
    print('🔍 URL length: ${url.length}');
    print('🔍 URL bytes: ${url.codeUnits.take(20).toList()}');
    
    final trimmedUrl = url.trim();
    
    // Check for null or 'null' string
    if (trimmedUrl.isEmpty || trimmedUrl == 'null') {
      print('❌ URL is null or empty');
      throw Exception('Video URL is null or empty');
    }
    
    final lower = trimmedUrl.toLowerCase();
    
    // Already a full URL
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      print('✅ Already full URL');
      return url.trim();
    }
    
    // File URI - convert to full URL (handles file:///storage/... or file://storage/...)
    if (lower.startsWith('file://')) {
      print('⚠️ File URI detected, converting...');
      // Remove file:// or file:/// prefix
      String path = trimmedUrl.replaceFirst(RegExp(r'^file:\/\/\/?'), '');
      // Check if path is valid after extraction
      if (path.isEmpty || path == 'null') {
        print('❌ Path is null or empty after extraction');
        throw Exception('Invalid file path: path is null or empty');
      }
      // Ensure path starts with /
      if (!path.startsWith('/')) {
        path = '/$path';
      }
      final result = '${ApiConstants.mediaBaseUrl}$path';
      print('✅ File URI converted to: $result');
      return result;
    }
    
    // Relative path - convert to full URL
    if (lower.startsWith('/storage/') || lower.startsWith('storage/') || 
        lower.startsWith('/media_assets/') || lower.startsWith('media_assets/')) {
      final result = '${ApiConstants.mediaBaseUrl}${url.startsWith('/') ? url : '/$url'}';
      print('✅ Relative path converted to: $result');
      return result;
    }
    
    // If all else fails, assume it's a relative path and prepend base URL
    final result = '${ApiConstants.mediaBaseUrl}${url.startsWith('/') ? url : '/$url'}';
    print('⚠️ Fallback conversion to: $result');
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: widget.height ?? 200,
        width: widget.width ?? double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            const Text(
              'Failed to load video',
              style: TextStyle(color: Colors.white),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: widget.height ?? 200,
        width: widget.width ?? double.infinity,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (widget.showControls) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: AnimatedOpacity(
            opacity: _controller.value.isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
