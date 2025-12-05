// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../bookmark_controller.dart';
// import '../../p5_profile/controller/profile_controller.dart';
// import '../../../app/models/post_model.dart';
// import 'post_detail_view.dart';
//
// class BookmarkView extends GetView<BookmarkController> {
//   const BookmarkView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Use Get.put to ensure controller exists when accessed from bottom nav
//     final ctrl = Get.put(BookmarkController());
//     final profileCtrl = Get.put(ProfileController());
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                   onPressed: () => Get.back(),
//                   splashRadius: 20,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       'bookmarks'.tr,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 48),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//         if (ctrl.savedPosts.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.bookmark_border,
//                   size: 80,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'no_bookmarks_yet'.tr,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Save posts to view them here',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: ctrl.savedPosts.length,
//           itemBuilder: (context, index) {
//             final post = ctrl.savedPosts[index];
//             final isVideo = post.id.startsWith('video_');
//
//             return _buildSavedPostCard(post, isVideo, profileCtrl, ctrl);
//           },
//         );
//       }),
//           ),
//         ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSavedPostCard(Post post, bool isVideo, ProfileController profileCtrl, BookmarkController ctrl) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: () {
//           Get.to(
//             () => PostDetailView(
//               post: post,
//               isVideo: isVideo,
//             ),
//             transition: Transition.rightToLeft,
//           );
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Post thumbnail
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: post.coverImage != null && File(post.coverImage!).existsSync()
//                       ? Image.file(
//                           File(post.coverImage!),
//                           fit: BoxFit.cover,
//                         )
//                       : Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     Colors.blue[300]!,
//                                     Colors.blue[600]!,
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Icon(
//                               isVideo ? Icons.play_circle_outline : Icons.image,
//                               color: Colors.white,
//                               size: 40,
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Post details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title
//                     Text(
//                       post.title,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     // Author info with profile picture
//                     Row(
//                       children: [
//                         Obx(() => CircleAvatar(
//                               radius: 10,
//                               backgroundColor: Colors.blue,
//                               backgroundImage: profileCtrl.profileImage.value != null
//                                   ? FileImage(profileCtrl.profileImage.value!)
//                                   : null,
//                               child: profileCtrl.profileImage.value == null
//                                   ? const Icon(Icons.person, size: 12, color: Colors.white)
//                                   : null,
//                             )),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Obx(() => Text(
//                                 profileCtrl.userName.value,
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.grey[700],
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               )),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     // Time and views
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
//                         const SizedBox(width: 4),
//                         Text(
//                           _getTimeAgo(post.createdAt),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Icon(Icons.remove_red_eye_outlined, size: 12, color: Colors.grey[600]),
//                         const SizedBox(width: 4),
//                         Text(
//                           _formatViews(post.likeCount + post.commentCount + post.shareCount),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     // Topic tag
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 3,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         post.topic,
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Remove bookmark button
//               IconButton(
//                 icon: const Icon(Icons.bookmark),
//                 color: Colors.blue,
//                 iconSize: 20,
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//                 onPressed: () => ctrl.removeSavedPost(post),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showPostDetailBottomSheet(Post post, ProfileController profileCtrl, BookmarkController ctrl) {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Handle bar
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Author info
//             Row(
//               children: [
//                 Obx(() => CircleAvatar(
//                       radius: 24,
//                       backgroundColor: Colors.blue,
//                       backgroundImage: profileCtrl.profileImage.value != null
//                           ? FileImage(profileCtrl.profileImage.value!)
//                           : null,
//                       child: profileCtrl.profileImage.value == null
//                           ? const Icon(Icons.person, color: Colors.white)
//                           : null,
//                     )),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Obx(() => Text(
//                             profileCtrl.userName.value,
//
//                             // style: const TextStyle(
//                             //   fontSize: 16,
//                             //   fontWeight: FontWeight.bold,
//                             // ),
//                           )),
//                       Text(
//                         _getTimeAgo(post.createdAt),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.bookmark),
//                   color: Colors.blue,
//                   onPressed: () {
//                     Get.back();
//                     ctrl.removeSavedPost(post);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Post title
//             Text(
//               post.title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 12),
//             // Topic tag
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 6,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.blue[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 post.topic,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Stats
//             Row(
//               children: [
//                 _buildStatItem(Icons.thumb_up_outlined, post.likeCount.toString()),
//                 const SizedBox(width: 20),
//                 _buildStatItem(Icons.comment_outlined, post.commentCount.toString()),
//                 const SizedBox(width: 20),
//                 _buildStatItem(Icons.share_outlined, post.shareCount.toString()),
//                 const Spacer(),
//                 Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text(
//                   _formatViews(post.likeCount + post.commentCount + post.shareCount),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }
//
//   Widget _buildStatItem(IconData icon, String count) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[700]),
//         const SizedBox(width: 4),
//         Text(
//           count,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[700],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatViews(int count) {
//     if (count >= 1000) {
//       return '${(count / 1000).toStringAsFixed(1)}K';
//     }
//     return count.toString();
//   }
//
//   String _getTimeAgo(DateTime date) {
//     final now = DateTime.now();
//     final diff = now.difference(date);
//
//     if (diff.inDays > 0) {
//       return '${diff.inDays}d ago';
//     } else if (diff.inHours > 0) {
//       return '${diff.inHours}h ago';
//     } else if (diff.inMinutes > 0) {
//       return '${diff.inMinutes}m ago';
//     } else {
//       return 'just now';
//     }
//   }
// }
