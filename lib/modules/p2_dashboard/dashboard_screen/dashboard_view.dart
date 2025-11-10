import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';
import '../../../app/models/comment_model.dart';
import '../../p5_profile/profile_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  DashboardController get ctrl => Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'home'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Overview Title
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'overview'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Metrics Cards
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // First Row - Views and Visits
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'views'.tr,
                            value: ctrl.views.value.toString(),
                            change: ctrl.viewsChange.value,
                            isHighlighted: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'visits'.tr,
                            value: ctrl.visits.value.toString(),
                            change: ctrl.visitsChange.value,
                            isHighlighted: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Second Row - New Users and Active Users
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'new_users'.tr,
                            value: ctrl.newUsers.value.toString(),
                            change: ctrl.newUsersChange.value,
                            isHighlighted: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'active_users'.tr,
                            value: ctrl.activeUsers.value.toStringAsFixed(0),
                            change: ctrl.activeUsersChange.value,
                            isHighlighted: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tabs Section
                    _buildTabSection(),
                    const SizedBox(height: 8),
                    _buildPostCard(),
                    const SizedBox(height: 24),
                    // Device Traffic
                    _buildDeviceTraffic(),
                    const SizedBox(height: 48),
                    // Chart
                  
                    const SizedBox(height: 24),  _buildChart(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required double change,
    required bool isHighlighted,
  }) {
    final isPositive = ctrl.isPositiveChange(change);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue : Colors.grey.shade500, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value.contains('.')
                ? double.parse(value).toStringAsFixed(0)
                : value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Row(
      children: [
        Text('create_post'.tr,
            style: const TextStyle(
               fontWeight: FontWeight.bold)),

      ],
    );
  }

  Widget _buildChart() {
    return SizedBox(
      
      height: 150,
      child: CustomPaint(
        painter: SimpleLineChartPainter(ctrl.chartData),
        child: Container(),
      ),
    );
  }

  Widget _buildDeviceTraffic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'device_traffic'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ctrl.deviceTraffic.entries.map((entry) {
              final isWindows = entry.key == 'Windows';
              return Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isWindows)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '243K',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 22),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: entry.value,
                      decoration: BoxDecoration(
                        color: isWindows ? Colors.blue : Colors.grey[300],
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // _buildCategoriesSection removed per request. Categories/CRUD moved to CategoryView.

  void _createNewPost() {
    Get.toNamed('/edit-post');
  }

  Widget _buildPostCard([dynamic post]) {
    // If no post provided, show an empty state with action to create a new post.
    if (post == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: Colors.white, 
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'post'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _createNewPost,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('create_post'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,  
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          if (post.coverImage != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.file(
                File(post.coverImage!),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.grey[200],
                  child:
                      const Center(child: Icon(Icons.broken_image, size: 40)),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  post.title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Topic
                if ((post.topic ?? '').isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.withOpacity(0.4)),
                    ),
                    child: Text(
                      post.topic ?? '',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 12),

                // Meta info
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(post.authorName ?? '',
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 16),
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      post.createdAt != null ? _formatDate(post.createdAt) : '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Like, Comment, Share buttons
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInteractionButton(
                        icon: post.isLiked ?? false ? Icons.thumb_up : Icons.thumb_up_outlined,
                        label: post.likeCount > 0 ? '${post.likeCount}' : 'like'.tr,
                        color: post.isLiked ?? false ? Colors.blue : Colors.grey[600]!,
                        onTap: () => _toggleLike(post),
                      ),
                      _buildInteractionButton(
                        icon: Icons.comment_outlined,
                        label: post.commentCount > 0 ? '${post.commentCount}' : 'comment'.tr,
                        color: Colors.grey[600]!,
                        onTap: () => _showComments(post),
                      ),
                      _buildInteractionButton(
                        icon: Icons.share_outlined,
                        label: post.shareCount > 0 ? '${post.shareCount}' : 'share'.tr,
                        color: Colors.grey[600]!,
                        onTap: () => _sharePost(post),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editPost(post),
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text('edit'.tr),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _deletePost(post),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.red),
                        icon: const Icon(Icons.delete, size: 18),
                        label: Text('delete'.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editPost(post) {
    Get.toNamed('/edit-post', arguments: post);
  }

  void _deletePost(post) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('delete_post'.tr),
        content: Text('are_you_sure_delete_post'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final dashboardCtrl = Get.find<DashboardController>();
      dashboardCtrl.posts.removeWhere((p) => p.id == post.id);
      Get.snackbar(
        'deleted'.tr,
        'post_deleted_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'just_now'.tr;
    }
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLike(post) {
    final dashboardCtrl = Get.find<DashboardController>();
    final index = dashboardCtrl.posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      if (post.isLiked ?? false) {
        post.isLiked = false;
        post.likeCount = (post.likeCount ?? 0) > 0 ? post.likeCount - 1 : 0;
      } else {
        post.isLiked = true;
        post.likeCount = (post.likeCount ?? 0) + 1;
      }
      dashboardCtrl.posts[index] = post;
      dashboardCtrl.posts.refresh();
    }
  }

  void _showComments(post) {
    final TextEditingController commentController = TextEditingController();
    final profileCtrl = Get.find<ProfileController>();
    final dashboardCtrl = Get.find<DashboardController>();
    
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final currentPost = dashboardCtrl.posts.firstWhere(
                (p) => p.id == post.id,
                orElse: () => post,
              );
              return Text(
                'Comments (${currentPost.comments.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Obx(() {
                final currentPost = dashboardCtrl.posts.firstWhere(
                  (p) => p.id == post.id,
                  orElse: () => post,
                );
                return currentPost.comments.isEmpty
                    ?  Center(
                        child: Text('comment'.tr,
                            style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        itemCount: currentPost.comments.length,
                        itemBuilder: (context, index) {
                          final comment = currentPost.comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: comment.authorImage != null
                                      ? FileImage(File(comment.authorImage!))
                                      : null,
                                  child: comment.authorImage == null
                                      ? const Icon(Icons.person, size: 16)
                                      : null,
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            comment.getTimeAgo(),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comment.text,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Obx(() => CircleAvatar(
                      radius: 16,
                      backgroundImage: profileCtrl.profileImage.value != null
                          ? FileImage(profileCtrl.profileImage.value!)
                          : null,
                      child: profileCtrl.profileImage.value == null
                          ? const Icon(Icons.person, size: 16)
                          : null,
                    )),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'write_a_comment'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (commentController.text.trim().isEmpty) return;
                          
                          final newComment = Comment(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            postId: post.id,
                            authorName: profileCtrl.userName.value,
                            authorImage: profileCtrl.profileImage.value?.path,
                            text: commentController.text.trim(),
                            createdAt: DateTime.now(),
                          );

                          final dashboardCtrl = Get.find<DashboardController>();
                          final index = dashboardCtrl.posts.indexWhere((p) => p.id == post.id);
                          if (index != -1) {
                            post.comments ??= [];
                            post.comments!.add(newComment);
                            post.commentCount = post.comments!.length;
                            dashboardCtrl.posts[index] = post;
                            dashboardCtrl.posts.refresh();
                          }
                          
                          commentController.clear();
                          Get.snackbar(
                            'success'.tr,
                            'comment_added'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 1),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _sharePost(post) {
    final dashboardCtrl = Get.find<DashboardController>();
    final index = dashboardCtrl.posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      post.shareCount = (post.shareCount ?? 0) + 1;
      dashboardCtrl.posts[index] = post;
      dashboardCtrl.posts.refresh();
    }
    
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'share_post'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text('copy_link'.tr),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'copied'.tr,
                  'link_copied_to_clipboard'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('share_to_other_apps'.tr),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'shared'.tr,
                  'post_shared_successfully'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('send_in_message'.tr),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'message'.tr,
                  'opening_messages'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// _CategoryViewHost removed — category UI deleted

// Simple line chart painter
class SimpleLineChartPainter extends CustomPainter {
  final List<double> data;

  SimpleLineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.width / (data.length - 1);
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw dots
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.purple);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
