import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/exhibitor_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/forms/text_input.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';

/// Enhanced Exhibitor Profile Screen
/// الملف الشخصي المحسّن للعارض
class ExhibitorProfileEnhancedScreen extends StatefulWidget {
  const ExhibitorProfileEnhancedScreen({super.key});

  @override
  State<ExhibitorProfileEnhancedScreen> createState() => _ExhibitorProfileEnhancedScreenState();
}

class _ExhibitorProfileEnhancedScreenState extends State<ExhibitorProfileEnhancedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Company Info Controllers
  final _companyNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Brochure Controllers
  final _brochureTitleController = TextEditingController();
  final _brochureDescriptionController = TextEditingController();
  final _brochureFeaturesController = TextEditingController();
  final _brochureServicesController = TextEditingController();
  
  // Security Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _brochureTitleController.dispose();
    _brochureDescriptionController.dispose();
    _brochureFeaturesController.dispose();
    _brochureServicesController.dispose();
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
      _companyNameController.text = user.companyName ?? '';
      _categoryController.text = user.category ?? '';
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
        Helpers.showErrorSnackBar(context, error != null ? error : 'فشل الحفظ');
      }
    }
  }

  Future<void> _saveCompanyInfo() async {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final companyInfo = {
      'companyName': _companyNameController.text.trim(),
      'category': _categoryController.text.trim(),
      'description': _descriptionController.text.trim(),
      'website': _websiteController.text.trim(),
      'address': _addressController.text.trim(),
    };
    
    final success = await exhibitorProvider.updateCompanyInfo(companyInfo);
    if (!mounted) return;
    
    if (success) {
      // Update user
      final user = authProvider.currentUser;
      if (user != null) {
        await authProvider.updateUser(user.copyWith(
          companyName: _companyNameController.text.trim(),
          category: _categoryController.text.trim(),
        ));
      }
      if (mounted) {
        Helpers.showSuccessSnackBar(context, 'تم حفظ معلومات الشركة بنجاح!');
      }
    } else {
      if (mounted) {
        Helpers.showErrorSnackBar(context, exhibitorProvider.error ?? 'فشل الحفظ');
      }
    }
  }

  Future<void> _saveBrochure() async {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    
    final features = _brochureFeaturesController.text
        .split('\n')
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty)
        .toList();
    
    final services = _brochureServicesController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    
    final brochure = {
      'title': _brochureTitleController.text.trim(),
      'description': _brochureDescriptionController.text.trim(),
      'features': features,
      'services': services,
    };
    
    final companyInfo = {
      'brochure': brochure,
    };
    
    final success = await exhibitorProvider.updateCompanyInfo(companyInfo);
    if (!mounted) return;
    
    if (success) {
      Helpers.showSuccessSnackBar(context, 'تم حفظ البروشور بنجاح!');
    } else {
      Helpers.showErrorSnackBar(context, exhibitorProvider.error ?? 'فشل الحفظ');
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      Helpers.showErrorSnackBar(context, 'كلمة المرور الجديدة غير متطابقة');
      return;
    }
    
    if (_newPasswordController.text.length < 6) {
      Helpers.showErrorSnackBar(context, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }
    
    // In real app, verify current password with backend
    // For demo, just show success
    if (mounted) {
      Helpers.showSuccessSnackBar(context, 'تم تحديث كلمة المرور بنجاح!');
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
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
            Tab(text: 'معلومات الشركة', icon: Icon(Icons.business)),
            Tab(text: 'البروشور', icon: Icon(Icons.description)),
            Tab(text: 'الأمان', icon: Icon(Icons.lock)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Personal Info Tab
          _buildPersonalInfoTab(user),
          // Company Info Tab
          _buildCompanyInfoTab(user),
          // Brochure Tab
          _buildBrochureTab(),
          // Security Tab
          _buildSecurityTab(),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab(user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile Image
          Stack(
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
                  Icons.business,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Form
          CustomTextInput(
            label: 'الاسم الكامل',
            controller: _nameController,
            validator: (value) => Validators.validateRequired(value, 'الاسم'),
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'البريد الإلكتروني',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'رقم الجوال',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: Validators.validatePhone,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'حفظ المعلومات الشخصية',
            icon: Icons.save,
            onPressed: _savePersonalInfo,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoTab(user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CustomTextInput(
            label: 'اسم الشركة',
            controller: _companyNameController,
            validator: (value) => Validators.validateRequired(value, 'اسم الشركة'),
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'الفئة',
            controller: _categoryController,
            hint: 'مثال: نقل، تعليم، تقنية',
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'الوصف',
            controller: _descriptionController,
            maxLines: 5,
            hint: 'وصف الشركة والخدمات المقدمة',
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'الموقع الإلكتروني',
            controller: _websiteController,
            keyboardType: TextInputType.url,
            hint: 'www.example.com',
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!Validators.isValidUrl(value) && !value.startsWith('www.')) {
                  return 'صيغة الموقع غير صحيحة';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'العنوان',
            controller: _addressController,
            maxLines: 3,
            hint: 'عنوان الشركة',
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'حفظ معلومات الشركة',
            icon: Icons.save,
            onPressed: _saveCompanyInfo,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildBrochureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CustomTextInput(
            label: 'عنوان البروشور',
            controller: _brochureTitleController,
            hint: 'مثال: حلول النقل الذكي للمدارس',
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'وصف البروشور',
            controller: _brochureDescriptionController,
            maxLines: 5,
            hint: 'وصف تفصيلي للبروشور',
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'المميزات (سطر لكل ميزة)',
            controller: _brochureFeaturesController,
            maxLines: 6,
            hint: 'ميزة 1\nميزة 2\nميزة 3',
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'الخدمات (سطر لكل خدمة)',
            controller: _brochureServicesController,
            maxLines: 6,
            hint: 'خدمة 1\nخدمة 2\nخدمة 3',
          ),
          const SizedBox(height: 16),
          // File Upload Button
          SecondaryButton(
            text: 'رفع ملف البروشور (PDF/صورة)',
            icon: Icons.upload_file,
            onPressed: () {
              // TODO: Implement file picker
              Helpers.showSuccessSnackBar(context, 'سيتم إضافة رفع الملفات قريباً');
            },
            width: double.infinity,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'حفظ البروشور',
            icon: Icons.save,
            onPressed: _saveBrochure,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CustomTextInput(
            label: 'كلمة المرور الحالية',
            controller: _currentPasswordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'كلمة المرور الحالية مطلوبة';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'كلمة المرور الجديدة',
            controller: _newPasswordController,
            obscureText: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: 'تأكيد كلمة المرور',
            controller: _confirmPasswordController,
            obscureText: true,
            validator: (value) {
              if (value != _newPasswordController.text) {
                return 'كلمة المرور غير متطابقة';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'تحديث كلمة المرور',
            icon: Icons.lock,
            onPressed: _changePassword,
            width: double.infinity,
          ),
          const SizedBox(height: 24),
          // Logout Button
          PrimaryButton(
            text: 'تسجيل الخروج',
            icon: Icons.logout,
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
}

