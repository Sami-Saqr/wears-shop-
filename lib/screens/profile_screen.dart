import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final user = auth.user;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Profile Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryLight,
                          image: user?.avatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(user!.avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: user?.avatarUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4392F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // User Name
                Text(
                  user?.fullName ?? 'User full Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                ),
                
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () {
                    Navigator.pushNamed(context, '/my-orders');
                  },
                ),
                
                _buildMenuItem(
                  context,
                  icon: Icons.favorite_border,
                  title: 'My Favorites',
                  onTap: () {
                    Navigator.pushNamed(context, '/favorites');
                  },
                ),
                
                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                
                const Divider(height: 40),
                
                // Logout
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Log Out'),
                        content: const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              auth.logout();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/welcome',
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Log Out',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  showArrow: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
