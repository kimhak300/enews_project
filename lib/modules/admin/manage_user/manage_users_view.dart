import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_user/widgets/add_user_bottom_sheet.dart';
import 'package:newshub/modules/admin/manage_user/widgets/user_card_widget.dart';
import '../../../api/controller/user_controller.dart';

class ManageUsersView extends StatelessWidget {
  ManageUsersView({super.key});

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Users'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "All"),
              Tab(text: "User"),
              Tab(text: "Organizer"),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("Add User"),
          onPressed: () => _openBottomSheet(context),
        ),

        body: Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              _buildList(userController.users),
              _buildList(
                userController.users
                    .where((u) => u.role.toLowerCase() == "user")
                    .toList(),
              ),
              _buildList(
                userController.users
                    .where((u) => u.role.toLowerCase() == "organizer")
                    .toList(),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// USER LIST WITH REFRESH
  Widget _buildList(List users) {
    return RefreshIndicator(
      onRefresh: () async {
        await userController.fetchUsers();
      },
      child: users.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          Center(child: Text("No users found.")),
        ],
      ) : ListView.separated(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 0),
        itemBuilder: (_, i) {
          final user = users[i];
          return UserCardWidget(
            userId: user.id,
            displayName: user.displayName,
            email: user.email,
            role: user.role,
            avatarUrl: user.avatar ?? "",
            onDelete: () => userController.deleteUser(user.id),
          );
        },
      ),
    );
  }

  /// BOTTOM SHEET
  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
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
              child: const AddUserBottomSheet(),
            ),
          );
        },
      ),
    );
  }
}