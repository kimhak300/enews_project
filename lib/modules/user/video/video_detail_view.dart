import 'package:flutter/material.dart';
import 'package:newshub/core/widgets/video_player_widget.dart';

class UserVideoDetailView extends StatelessWidget {
  final String videoUrl;
  final String? title;

  const UserVideoDetailView({super.key, required this.videoUrl, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Video')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                child: VideoPlayerWidget(
                  videoUrl: videoUrl,
                  autoPlay: true,
                  showControls: true,
                  height: MediaQuery.of(context).size.width * (9 / 16),
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 12),
              if (title != null)
                Text(title!, style: theme.textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
