// import 'package:flutter/material.dart';

// class SearchWidget extends StatefulWidget {
//   final String hintText;
//   final List<String> filterOptions;
//   final ValueChanged<String>? onSearch;
//   final ValueChanged<String>? onFilterSelected;

//   const SearchWidget({
//     super.key,
//     this.hintText = "Search...",
//     required this.filterOptions,
//     this.onSearch,
//     this.onFilterSelected,
//   });

//   @override
//   State<SearchWidget> createState() => _SearchWidgetState();
// }

// class _SearchWidgetState extends State<SearchWidget> {
//   final TextEditingController _controller = TextEditingController();
//   String selectedFilter = "";

//   @override
//   void initState() {
//     super.initState();
//     if (widget.filterOptions.isNotEmpty) {
//       selectedFilter = widget.filterOptions.first;
//     }
//   }

//   void _openFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Select Filter"),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: widget.filterOptions.length,
//               itemBuilder: (context, index) {
//                 String option = widget.filterOptions[index];
//                 return ListTile(
//                   title: Text(option),
//                   trailing: selectedFilter == option
//                       ? const Icon(Icons.check, color: Colors.blue)
//                       : null,
//                   onTap: () {
//                     setState(() {
//                       selectedFilter = option;
//                     });
//                     if (widget.onFilterSelected != null) {
//                       widget.onFilterSelected!(option);
//                     }
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Row(
//           children: [
//             /// Search TextField
//             Expanded(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   hintText: widget.hintText,
//                   border: InputBorder.none,
//                   prefixIcon: const Icon(Icons.search),
//                 ),
//                 onChanged: widget.onSearch,
//               ),
//             ),

//             /// Filter Button
//             GestureDetector(
//               onTap: _openFilterDialog,
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Text(
//                       selectedFilter,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     const Icon(
//                       Icons.arrow_drop_down,
//                       color: Colors.blue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }