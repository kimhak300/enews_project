import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:newshub/app/config/app_config.dart';

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
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    final raw = widget.url.trim();
    debugPrint('🎥 SmallVideoPlayer: Initializing video from URL: $raw');

    if (raw.isEmpty) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    try {
      // Determine source type and normalize
      if (raw.startsWith('file://')) {
        final path = raw.replaceFirst(RegExp(r'^file:\/\/\/?'), '');
        final file = File(path);
        if (!file.existsSync()) throw Exception('File not found: $path');
        _controller = VideoPlayerController.file(file);
      } else if (raw.startsWith('http://') || raw.startsWith('https://')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(raw));
      } else if (raw.startsWith('/storage/') || raw.startsWith('storage/')) {
        // likely a relative storage path from the backend; convert to full URL
        final full = AppConfig.getImageUrl(raw);
        _controller = VideoPlayerController.networkUrl(Uri.parse(full));
      } else if (!raw.contains('://')) {
        // treat as relative path (no scheme) and construct full URL
        final full = AppConfig.getImageUrl(raw);
        _controller = VideoPlayerController.networkUrl(Uri.parse(full));
      } else {
        // fallback to treating as network URL
        _controller = VideoPlayerController.networkUrl(Uri.parse(raw));
      }

      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.setVolume(0);

      if (mounted) setState(() => _initialized = true);
      debugPrint('✅ SmallVideoPlayer: Video initialized successfully');
    } on PlatformException catch (e) {
      debugPrint('❌ SmallVideoPlayer: PlatformException initializing video: $e');
      if (mounted) setState(() => _hasError = true);
    } catch (e) {
      debugPrint('❌ SmallVideoPlayer: Error initializing video: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    try {
      _controller?.dispose();
    } catch (_) {}
    super.dispose();
  }

  void _onTap() {
    if (!_initialized || _hasError) return;

    final c = _controller;
    if (c == null) return;

    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.setVolume(1); // Unmute when playing
      c.play();
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
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
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
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
