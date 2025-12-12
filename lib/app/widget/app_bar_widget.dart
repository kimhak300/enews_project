// import 'package:flutter/material.dart';
// import 'package:newshub/app/constants/app_spacing.dart';

// class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
//   final Widget? left;
//   final String title;
//   final Widget? right;
//   final double height;

//   const AppBarWidget({
//     super.key,
//     this.left,
//     required this.title,
//     this.right,
//     this.height = 60,
//   });

//   @override
//   Size get preferredSize => Size.fromHeight(height);

//   /// Ghost placeholder to center the title
//   Widget _ghost() => const SizedBox(width: 50, height: 50);

//   @override
//   Widget build(BuildContext context) {
//     final hasLeft = left != null;
//     final hasRight = right != null;

//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           SizedBox(width: AppSpacing.paddingS),

//           /// LEFT WIDGET -------------------------------------------------
//           Expanded(
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: hasLeft
//                   ? left!
//                   : _ghost(),
//             ),
//           ),

//           /// CENTER TITLE -----------------------------------------------
//           Expanded(
//             child: Align(
//               alignment: Alignment.center,
//               child: Text(
//                 title,
//                 style: Theme.of(context).textTheme.titleLarge,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),

//           /// RIGHT WIDGET ------------------------------------------------
//           Expanded(
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: hasRight ? right! : _ghost(),
//             ),
//           ),

//           SizedBox(width: AppSpacing.paddingS),
//         ],
//       ),
//     );
//   }
// }