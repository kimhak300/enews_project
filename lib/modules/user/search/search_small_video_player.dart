import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

/// Small inline video player for search result article cards
/// Displays a small video thumbnail (default 96x96) that plays/pauses on tap
class SearchSmallVideoPlayer extends StatefulWidget {
  final String url;
  final String? poster;
  final double width;
  final double height;

  const SearchSmallVideoPlayer({
    super.key,
    required this.url,
    this.poster,
    this.width = 96,
    this.height = 96,
  });

  @override
  State<SearchSmallVideoPlayer> createState() => _SearchSmallVideoPlayerState();
}

class _SearchSmallVideoPlayerState extends State<SearchSmallVideoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    final url = widget.url.trim();
    if (url.isEmpty) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.setVolume(0);
      if (mounted) setState(() => _initialized = true);
    } catch (e) {
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
      c.setVolume(1);
      c.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final w = widget.width.w;
    final h = widget.height.h;

    if (_hasError) {
      // If there's a poster fallback, show it instead of a generic error icon
      if (widget.poster != null && widget.poster!.trim().isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            widget.poster!,
            width: w,
            height: h,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.error_outline, color: theme.colorScheme.error, size: 24.sp),
            ),
          ),
        );
      }

      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.error_outline, color: theme.colorScheme.error, size: 24.sp),
      );
    }

    if (!_initialized) {
      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(child: SizedBox(width: 20.w, height: 20.h, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: w,
        height: h,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_initialized && !_hasError && _controller != null)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width > 0 ? _controller!.value.size.width : w,
                    height: _controller!.value.size.height > 0 ? _controller!.value.size.height : h,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),

            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                (_controller != null && _controller!.value.isPlaying) ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
