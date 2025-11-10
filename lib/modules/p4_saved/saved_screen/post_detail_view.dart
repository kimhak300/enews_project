import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../app/models/post_model.dart';
import '../../../app/models/comment_model.dart';
import '../../p5_profile/profile_controller.dart';
import '../bookmark_controller.dart';

class PostDetailView extends StatefulWidget {
  final Post post;
  final bool isVideo;

  const PostDetailView({
    super.key,
    required this.post,
    required this.isVideo,
  });

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  VideoPlayerController? _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo && widget.post.coverImage != null) {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    if (widget.post.coverImage == null) return;

    final file = File(widget.post.coverImage!);
    if (!file.existsSync()) {
      print('Video file not found: ${widget.post.coverImage}');
      return;
    }

    print('Initializing video from: ${widget.post.coverImage}');
    _videoController = VideoPlayerController.file(file)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          // Auto-play the video
          _videoController?.play();
        }
      }).catchError((error) {
        print('Error initializing video: $error');
      })
      ..addListener(() {
        if (mounted) {
          final isPlaying = _videoController!.value.isPlaying;
          if (_isPlaying != isPlaying) {
            setState(() => _isPlaying = isPlaying);
          }
        }
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.put(ProfileController());
    
    return Scaffold(
      
      // backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen media
          Positioned.fill(
            child: widget.isVideo ? _buildVideoPlayer() : _buildImageViewer(),
          ),
          // Top app bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Colors.black.withOpacity(0.7),
                  //     Colors.transparent,
                  //   ],
                  // ),
                  ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              _showPostOptionsBottomSheet(context, widget.post);
                            },
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom content overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.bottomCenter,
              //     end: Alignment.topCenter,
              //     colors: [
              //       Colors.black.withOpacity(0.8),
              //       Colors.black.withOpacity(0.6),
              //       Colors.transparent,
              //     ],
              //   ),
              // ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Author info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Row(
                        children: [
                          Obx(() => CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue,
                                backgroundImage: profileCtrl
                                            .profileImage.value !=
                                        null
                                    ? FileImage(profileCtrl.profileImage.value!)
                                    : null,
                                child: profileCtrl.profileImage.value == null
                                    ? const Icon(Icons.person,
                                        color: Colors.white)
                                    : null,
                              )),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Obx(() => Text(
                                          profileCtrl.userName.value,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified,
                                        color: Colors.blue, size: 16),
                                  ],
                                ),
                                const SizedBox(width: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.post.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // color: Colors.white,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Topic tag
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.post.topic,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Views
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.play_arrow,
                              size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            _formatViews(widget.post.likeCount +
                                widget.post.commentCount +
                                widget.post.shareCount),
                            style: const TextStyle(
                              fontSize: 13,
                              // color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Action buttons
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            icon: widget.post.isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            count: widget.post.likeCount,
                            isActive: widget.post.isLiked,
                            onTap: () {
                              setState(() {
                                widget.post.isLiked = !widget.post.isLiked;
                                widget.post.likeCount +=
                                    widget.post.isLiked ? 1 : -1;
                              });
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.chat_bubble_outline,
                            count: widget.post.commentCount,
                            onTap: () => _showCommentsSheet(),
                          ),
                          _buildActionButton(
                            icon: Icons.remove_red_eye_outlined,
                            count: widget.post.likeCount +
                                widget.post.commentCount +
                                widget.post.shareCount,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        // color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            ),
          ),
          if (!_isPlaying)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(20),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 60,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    return widget.post.coverImage != null &&
            File(widget.post.coverImage!).existsSync()
        ? Image.file(
            File(widget.post.coverImage!),
            fit: BoxFit.contain,
            width: double.infinity,
          )
        : Container(
            color: Colors.grey[900],
            child: Center(
              child: Icon(
                Icons.image,
                color: Colors.white.withOpacity(0.5),
                size: 80,
              ),
            ),
          );
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.blue : Colors.grey[700],
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet() {
    final TextEditingController commentController = TextEditingController();
    final profileCtrl = Get.find<ProfileController>();

    Get.bottomSheet(
      StatefulBuilder(builder: (context, setModalState) {
        void addCommentToList(String text, String authorName) {
          final newComment = Comment(
            id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
            postId: widget.post.id,
            authorName: authorName,
            text: text,
            createdAt: DateTime.now(),
          );

          // Update the widget state
          setState(() {
            widget.post.comments.add(newComment);
            widget.post.commentCount = widget.post.comments.length;
          });

          // Update the modal state
          setModalState(() {});

          // Save the updated post to bookmark controller if it's saved
          try {
            final bookmarkCtrl = Get.find<BookmarkController>();
            if (bookmarkCtrl.isPostSaved(widget.post.id)) {
              bookmarkCtrl.savePost(widget.post);
            }
          } catch (e) {
            // BookmarkController not found, skip saving
          }

          Get.snackbar(
            'Comment',
            'Comment added successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }

        return Container(
          height: Get.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              // Comments header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'comments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.post.commentCount}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              // Comments list
              Expanded(
                child: widget.post.comments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No comments yet',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to comment',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: widget.post.comments.length,
                        itemBuilder: (context, index) {
                          return _buildCommentItem(widget.post.comments[index]);
                        },
                      ),
              ),
              // Comment input
              Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 18,
                            // backgroundColor: Colors.blue,
                            backgroundImage:
                                profileCtrl.profileImage.value != null
                                    ? FileImage(profileCtrl.profileImage.value!)
                                    : null,
                            child: profileCtrl.profileImage.value == null
                                ? const Icon(Icons.person,
                                    size: 18, color: Colors.white)
                                : null,
                          )),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'Write a comment...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                addCommentToList(
                                    value, profileCtrl.userName.value);
                                commentController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            addCommentToList(commentController.text,
                                profileCtrl.userName.value);
                            commentController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  Widget _buildStatItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue,
            child: Text(
              comment.authorName[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTimeAgo(comment.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _showOptionsMenu() {
  //   Get.bottomSheet(
  //     Container(
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: SafeArea(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 12),
  //             Container(
  //               width: 40,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.share),
  //               title: const Text('Share'),
  //               onTap: () {
  //                 Get.back();
  //                 Get.snackbar('Share', 'Share functionality');
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.report_outlined),
  //               title: const Text('Report'),
  //               onTap: () {
  //                 Get.back();
  //                 Get.snackbar('Report', 'Report functionality');
  //               },
  //             ),
  //             const SizedBox(height: 8),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

    void _showPostOptionsBottomSheet(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'edit post',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post edited')),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border, color: Colors.black),
                ),
                title: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Add to Favorite List',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  try {
                    final bookmarkCtrl = Get.put(BookmarkController());
                    bookmarkCtrl.savePost(post);
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to save video',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'are you sure to delete this content?',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Content deleted')),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.report_outlined, color: Colors.black),
                ),
                title: const Text(
                  'Report',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Feedback Bad Content',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report submitted')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatViews(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
