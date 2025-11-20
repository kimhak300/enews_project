import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../search_controller.dart' as search;
// import './format_duration_helper.dart';

class SearchView extends GetView<search.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put to ensure controller exists when accessed from bottom nav
    final ctrl = Get.put(search.SearchController());

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: ctrl.searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'search_news'.tr,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: ctrl.search,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ctrl.recentSearches.isNotEmpty) ...[
                        Text(
                          'recent_searches'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...ctrl.recentSearches.map((term) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.history_outlined,
                                      color: Colors.grey, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      term,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () =>
                                          ctrl.removeRecentSearch(term),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons.close,
                                            size: 18, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 24),
                      ],
                      Text(
                        'trending_topics'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        children: [
                          _buildTrendingChip('Popular', ctrl),
                          _buildTrendingChip('Technology', ctrl),
                          _buildTrendingChip('Entertainment', ctrl),
                          _buildTrendingChip('Sports', ctrl),
                          _buildTrendingChip('News', ctrl),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'trending_videos'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Trending videos list
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: [
                          ctrl.trendingVideoUrls.length,
                          ctrl.videoControllers.length,
                          ctrl.isInitializedList.length
                        ].reduce((a, b) => a < b ? a : b),
                        itemBuilder: (context, index) {
                          final videoTitle = index == 0
                              ? "First lady Melania Trump accepts the 'Patriot of the Year' award at Fox Nation Patriot Awards"
                              : index == 1
                                  ? "Breaking News: World Event"
                                  : index == 2
                                      ? "News Anchor Talking on TV"
                                      : index == 3
                                          ? "Tech Innovations 2024"
                                          : index == 4
                                              ? "Sports Highlights"
                                              : "Trending Video";
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Obx(() {
                                    if (!ctrl.isInitializedList[index].value) {
                                      return Container(
                                        color: Colors.black,
                                        height: 220,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }
                                    
                                    // Check if video has error
                                    if (ctrl.videoControllers[index].value.hasError) {
                                      return Container(
                                        color: Colors.black,
                                        height: 220,
                                        child: const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.error_outline, color: Colors.white, size: 48),
                                              SizedBox(height: 8),
                                              Text(
                                                'Video unavailable',
                                                style: TextStyle(color: Colors.white70),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: ctrl.videoControllers[index].value.aspectRatio,
                                          child: VideoPlayer(ctrl.videoControllers[index]),
                                        ),
                                        // Play/Pause overlay
                                        Positioned.fill(
                                          child: GestureDetector(
                                            onTap: () => ctrl.playPause(index),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Obx(() => !ctrl.isPlayingList[index].value
                                                    ? Container(
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.6),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.play_arrow,
                                                          size: 50,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Fullscreen button
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => FullScreenVideoPage(
                                                    controller: ctrl.videoControllers[index],
                                                    title: videoTitle,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.6),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                Icons.fullscreen,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    videoTitle,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingChip(String tag, search.SearchController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ctrl.searchController.text = tag.substring(1);
            ctrl.search(tag.substring(1));
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Fullscreen video page widget
class FullScreenVideoPage extends StatelessWidget {
  final VideoPlayerController controller;
  final String title;
  const FullScreenVideoPage({required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            // Progress bar overlay (fullscreen only)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _FullScreenControls(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullScreenControls extends StatefulWidget {
  final VideoPlayerController controller;
  const _FullScreenControls({required this.controller});

  @override
  State<_FullScreenControls> createState() => _FullScreenControlsState();
}

class _FullScreenControlsState extends State<_FullScreenControls> {
  late VideoPlayerController controller;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.addListener(_update);
    _update();
  }

  void _update() {
    if (!mounted) return;
    setState(() {
      position = controller.value.position;
      duration = controller.value.duration;
      isPlaying = controller.value.isPlaying;
    });
  }

  @override
  void dispose() {
    controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Text(
          //   formatDuration(position),
          //   style: const TextStyle(color: Colors.white, fontSize: 12),
          // ),
          Expanded(
            child: Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: duration.inSeconds.toDouble().clamp(1, double.infinity),
              onChanged: (value) {
                controller.seekTo(Duration(seconds: value.toInt()));
              },
              activeColor: Colors.white,
              inactiveColor: Colors.white24,
            ),
          ),
          // Text(
          //   formatDuration(duration),
          //   style: const TextStyle(color: Colors.white, fontSize: 12),
          // ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isPlaying ? controller.pause() : controller.play();
              });
            },
          ),
        ],
      ),
    );
  }
}
