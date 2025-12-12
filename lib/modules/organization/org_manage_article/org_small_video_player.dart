import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Small inline video player for organization article cards
/// Displays a 70x70 video thumbnail that plays on tap
class OrgSmallVideoPlayer extends StatefulWidget {
  final String url;
  final double width;
  final double height;

  const OrgSmallVideoPlayer({
    super.key,
    required this.url,
    this.width = 70,
    this.height = 70,
  });

  @override
  State<OrgSmallVideoPlayer> createState() => _OrgSmallVideoPlayerState();
}

class _OrgSmallVideoPlayerState extends State<OrgSmallVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    }).catchError((error) {
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
      _controller.setVolume(1);
      _controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_initialized && !_hasError)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width > 0
                        ? _controller.value.size.width
                        : widget.width,
                    height: _controller.value.size.height > 0
                        ? _controller.value.size.height
                        : widget.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),

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
