import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/text_input.dart';
import '../../utils/helpers.dart';

/// Enhanced Visitor Profile Screen
/// الملف الشخصي المحسّن للزائر
class VisitorProfileEnhancedScreen extends StatefulWidget {
  const VisitorProfileEnhancedScreen({super.key});

  @override
  State<VisitorProfileEnhancedScreen> createState() => _VisitorProfileEnhancedScreenState();
}

class _VisitorProfileEnhancedScreenState extends State<VisitorProfileEnhancedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Security Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }
  }

  Future<void> _savePersonalInfo() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      final updatedUser = user.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      
      final success = await authProvider.updateUser(updatedUser);
      if (!mounted) return;
      
      if (success) {
        Helpers.showSuccessSnackBar(context, 'تم حفظ المعلومات الشخصية بنجاح!');
      } else {
        final error = authProvider.error;
        Helpers.showErrorSnackBar(context, error ?? 'فشل الحفظ');
      }
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      Helpers.showErrorSnackBar(context, 'كلمات المرور غير متطابقة');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      Helpers.showErrorSnackBar(context, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    // TODO: Implement password change API
    Helpers.showSuccessSnackBar(context, 'تم تغيير كلمة المرور بنجاح!');
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'معلومات شخصية', icon: Icon(Icons.person)),
            Tab(text: 'الأمان', icon: Icon(Icons.lock)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Personal Info Tab
          _buildPersonalInfoTab(user),
          // Security Tab
          _buildSecurityTab(),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab(user) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Profile Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'زائر',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.expoId ?? 'SmartCard#1200',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Registration Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'بيانات التسجيل',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.badge, 'SmartCard ID', user?.expoId ?? 'SmartCard#1200'),
                  _buildInfoRow(Icons.email, 'البريد الإلكتروني', user?.email ?? ''),
                  if (user?.phone != null)
                    _buildInfoRow(Icons.phone, 'رقم الجوال', user!.phone!),
                  _buildInfoRow(Icons.person, 'الاسم', user?.name ?? ''),
                  _buildInfoRow(Icons.calendar_today, 'تاريخ التسجيل', user?.createdAt != null 
                    ? '${user!.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                    : 'غير متوفر'),
                  _buildInfoRow(Icons.verified, 'حالة الحساب', user?.isVerified == true ? 'متحقق' : 'غير متحقق'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Editable Personal Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تعديل المعلومات الشخصية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'الاسم',
                    controller: _nameController,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'البريد الإلكتروني',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    enabled: false, // Email cannot be changed
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'رقم الجوال',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'حفظ التغييرات',
                    icon: Icons.save,
                    onPressed: _savePersonalInfo,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
          if (user?.interests != null && user!.interests!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الاهتمامات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.interests!.map<Widget>(
                        (interest) => Chip(
                          label: Text(interest.toString()),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.1),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          // Logout Button
          PrimaryButton(
            text: 'تسجيل الخروج',
            icon: Icons.logout,
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
            width: double.infinity,
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تغيير كلمة المرور',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'كلمة المرور الحالية',
                    controller: _currentPasswordController,
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'كلمة المرور الجديدة',
                    controller: _newPasswordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(
                    label: 'تأكيد كلمة المرور الجديدة',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'تغيير كلمة المرور',
                    icon: Icons.lock_reset,
                    onPressed: _changePassword,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

