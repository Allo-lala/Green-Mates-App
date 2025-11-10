// ignore_for_file: deprecated_member_use, unused_local_variable, unused_import, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/kyc_service.dart';
import '../../widgets/app_button.dart';
import 'home_screen.dart';

class KYCScreen extends ConsumerStatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends ConsumerState<KYCScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController dateOfBirthController;
  late TextEditingController nationalityController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController postalCodeController;
  late TextEditingController countryController;

  String? identityDocPath;
  String? proofOfAddressPath;
  String? selfieWithIdPath;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    dateOfBirthController = TextEditingController();
    nationalityController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    postalCodeController = TextEditingController();
    countryController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    nationalityController.dispose();
    addressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        if (type == 'identity') {
          identityDocPath = pickedFile.path;
        } else if (type == 'proof') {
          proofOfAddressPath = pickedFile.path;
        } else if (type == 'selfie') {
          selfieWithIdPath = pickedFile.path;
        }
      });
    }
  }

  Future<void> _submitKYC() async {
    setState(() => _isLoading = true);

    try {
      final kycData = KYCData(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        dateOfBirth: dateOfBirthController.text,
        nationality: nationalityController.text,
        address: addressController.text,
        city: cityController.text,
        postalCode: postalCodeController.text,
        country: countryController.text,
        identityDocumentPath: identityDocPath,
        proofOfAddressPath: proofOfAddressPath,
        selfieWithIdPath: selfieWithIdPath,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      // Save KYC data
      // In production: Upload documents to backend/storage service
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KYC Submitted'),
        content: const Text(
          'Your KYC documents have been submitted successfully. Our team will verify them within 24-48 hours.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Know Your Customer (KYC)'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            const SizedBox(height: 24),

            // Current step content
            _buildStepContent(),
            const SizedBox(height: 32),

            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step ${_currentStep + 1} of 3',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAddressStep();
      case 2:
        return _buildDocumentsStep();
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please provide your personal details',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: firstNameController,
          label: 'First Name',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: lastNameController,
          label: 'Last Name',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: emailController,
          label: 'Email Address',
          icon: Icons.email,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: dateOfBirthController,
          label: 'Date of Birth (YYYY-MM-DD)',
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: nationalityController,
          label: 'Nationality',
          icon: Icons.public,
        ),
      ],
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Information',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please provide your residential address',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: addressController,
          label: 'Street Address',
          icon: Icons.location_on,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: cityController,
          label: 'City',
          icon: Icons.location_city,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: postalCodeController,
          label: 'Postal Code',
          icon: Icons.mail,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: countryController,
          label: 'Country',
          icon: Icons.flag,
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Verification',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload required documents to complete verification',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildDocumentUploadCard(
          'Identity Document',
          'Passport or National ID',
          identityDocPath,
          () => _pickImage('identity'),
        ),
        const SizedBox(height: 16),
        _buildDocumentUploadCard(
          'Proof of Address',
          'Utility bill or Bank statement',
          proofOfAddressPath,
          () => _pickImage('proof'),
        ),
        const SizedBox(height: 16),
        _buildDocumentUploadCard(
          'Selfie with ID',
          'Photo holding your ID document',
          selfieWithIdPath,
          () => _pickImage('selfie'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard(
    String title,
    String description,
    String? filePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: filePath != null ? AppColors.primary : AppColors.divider,
            width: filePath != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: filePath != null
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              filePath != null ? Icons.check_circle : Icons.cloud_upload,
              color: filePath != null
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    filePath != null ? 'Uploaded' : description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_currentStep == 2) {
                          _submitKYC();
                        } else {
                          setState(() => _currentStep++);
                          // Scroll to top when moving to next step
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _currentStep == 2 ? 'Submit KYC' : 'Next',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
