import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_user/widgets/add_user_bottom_sheet.dart';
import 'package:newshub/modules/admin/manage_user/widgets/user_card_widget.dart';

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView>
    with SingleTickerProviderStateMixin {


  final List<Map<String, dynamic>> users = const [
    {
      'id': 1,
      'display_name': 'John Doe',
      'email': 'john@example.com',
      'role': 'User',
      'avatar_url': '',
    },
    {
      'id': 2,
      'display_name': 'Jane Smith',
      'email': 'jane@example.com',
      'role': 'User',
      'avatar_url': '',
    },
    {
      'id': 3,
      'display_name': 'Alice Johnson',
      'email': 'alice@example.com',
      'role': 'Admin',
      'avatar_url': '',
    },
    {
      'id': 4,
      'display_name': 'Organizer One',
      'email': 'org1@example.com',
      'role': 'Organizer',
      'avatar_url': '',
    },
  ];

  late TabController _tabController;
  final List<String> tabs = ['All', 'User', 'Organizer'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  List<Map<String, dynamic>> _filterUsers(String tab) {
    if (tab == 'All') return users;
    return users.where((u) => u['role'] == tab).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add),
        label: const Text("Add User"),
        onPressed: () => _openUserForm(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        child: Column(
          children: [
            tabBarTitle(),
            SizedBox(height: AppSpacing.paddingM),
            tabBarList(),
          ],
        ),
      ),
    );
  }

  Widget tabBarTitle(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        dividerHeight: 0,
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        unselectedLabelColor: Colors.white,
        labelStyle:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle:
        const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
        tabs: tabs.map((tab) => Container(
            padding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 8
            ),
            child: Center(child: Text(tab)
            ),
          ),
        ).toList(),
        // isScrollable: true,
      ),
    );
  }

  Widget tabBarList(){
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: tabs.map((tab) {
          final filteredUsers = _filterUsers(tab);
          return ListView.separated(
            itemCount: filteredUsers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return UserCardWidget(
                displayName: user['display_name'],
                email: user['email'],
                role: user['role'],
                avatarUrl: user['avatar_url'],
                onDelete: () {
                  // Handle delete action
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }

  void _openUserForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // full height
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: AddUserBottomSheet(),
              ),
            );
          },
        );
      },
    );
  }
}
