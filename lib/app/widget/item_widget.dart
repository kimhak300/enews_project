// import 'package:flutter/material.dart';
// import 'package:newshub/app/constants/app_spacing.dart';
// import 'package:newshub/app/constants/app_widget_size.dart';

// class ItemWidget extends StatelessWidget {
//   /// Left icon
//   final IconData icon;

//   /// Item title
//   final String title;

//   /// Optional description
//   final String? description;

//   /// Optional right icon. Default arrow_forward
//   final IconData? rightIcon;

//   /// Tap callback for the whole item
//   final VoidCallback? onTap;

//   /// Tap callback for right icon
//   final VoidCallback? onRightTap;

//   /// Left icon color. Background color will use this color with opacity
//   final Color iconColor;

//   /// Background opacity of left icon container
//   final double iconOpacity;

//   /// Constructor
//   const ItemWidget({
//     super.key,
//     required this.icon,
//     required this.title,
//     this.description,
//     this.rightIcon,
//     this.onTap,
//     this.onRightTap,
//     this.iconColor = Colors.blue,
//     this.iconOpacity = 0.15,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Card(
//         elevation: 1,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: AppSpacing.paddingSM,
//             horizontal: AppSpacing.paddingSM,
//           ),
//           child: Row(
//             children: [
//               /// LEFT ICON with background using iconColor.opacity
//               Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   color: iconColor.withOpacity(iconOpacity),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: iconColor,
//                   size: AppWidgetSize.iconSM,
//                 ),
//               ),

//               SizedBox(width: AppSpacing.paddingSM),

//               /// TITLE + DESCRIPTION
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     if (description != null)
//                       Text(
//                         description!,
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),

//               /// RIGHT ICON (optional, default arrow_forward)
//               if (rightIcon != null || onRightTap != null)
//                 GestureDetector(
//                   onTap: onRightTap,
//                   behavior: HitTestBehavior.opaque,
//                   child: Icon(
//                     rightIcon ?? Icons.arrow_forward_ios,
//                     size: AppWidgetSize.iconXS,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }