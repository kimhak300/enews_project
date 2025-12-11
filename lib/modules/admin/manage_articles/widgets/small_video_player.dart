import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Small inline video player for article cards
/// Displays a 70x70 video thumbnail that plays on tap
class SmallVideoPlayer extends StatefulWidget {
  final String url;
  final double width;
  final double height;

  const SmallVideoPlayer({
    super.key,
    required this.url,
    this.width = 70,
    this.height = 70,
  });

  @override
  State<SmallVideoPlayer> createState() => _SmallVideoPlayerState();
}

class _SmallVideoPlayerState extends State<SmallVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    print('🎥 SmallVideoPlayer: Initializing video from URL: ${widget.url}');
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.initialize().then((_) {
      print('✅ SmallVideoPlayer: Video initialized successfully');
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    }).catchError((error) {
      print('❌ SmallVideoPlayer: Error initializing video: $error');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    });
    _controller.setLooping(true);
    _controller.setVolume(0); // Muted by default
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!_initialized || _hasError) return;
    
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.setVolume(1); // Unmute when playing
      _controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show error fallback
    if (_hasError) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.error_outline,
          color: theme.colorScheme.error,
          size: 30,
        ),
      );
    }

    // Show loading indicator
    if (!_initialized) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    // Show video player
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            // Play/Pause overlay
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
