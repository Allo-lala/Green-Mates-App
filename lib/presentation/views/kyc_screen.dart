// ignore_for_file: use_super_parameters, unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/kyc_service.dart';
import '../../widgets/app_button.dart';

import 'home_screen.dart';

class KYCScreen extends ConsumerStatefulWidget {
  final String userId;

  const KYCScreen({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends ConsumerState<KYCScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) {
                if (step < _currentStep) {
                  setState(() => _currentStep = step);
                }
              },
              steps: [
                Step(
                  title: const Text('Personal Info'),
                  content: _buildPersonalInfoStep(),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text('Address'),
                  content: _buildAddressStep(),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: const Text('Documents'),
                  content: _buildDocumentsStep(),
                  isActive: _currentStep >= 2,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: AppButton(
                      label: 'Back',
                      isOutlined: true,
                      onPressed: () =>
                          setState(() => _currentStep = _currentStep - 1),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    label: _currentStep == 2 ? 'Submit KYC' : 'Next',
                    isLoading: _isLoading,
                    onPressed: () {
                      if (_currentStep == 2) {
                        _submitKYC();
                      } else {
                        setState(() => _currentStep = _currentStep + 1);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(
            hintText: 'First Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(
            hintText: 'Last Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            hintText: 'Email Address',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: dateOfBirthController,
          decoration: const InputDecoration(
            hintText: 'Date of Birth (YYYY-MM-DD)',
            prefixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: nationalityController,
          decoration: const InputDecoration(
            hintText: 'Nationality',
            prefixIcon: Icon(Icons.public),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressStep() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: addressController,
          decoration: const InputDecoration(
            hintText: 'Street Address',
            prefixIcon: Icon(Icons.location_on),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: cityController,
          decoration: const InputDecoration(
            hintText: 'City',
            prefixIcon: Icon(Icons.location_city),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: postalCodeController,
          decoration: const InputDecoration(
            hintText: 'Postal Code',
            prefixIcon: Icon(Icons.mail),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: countryController,
          decoration: const InputDecoration(
            hintText: 'Country',
            prefixIcon: Icon(Icons.flag),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Upload Required Documents',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
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
}
