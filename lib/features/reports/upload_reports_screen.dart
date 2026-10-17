import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/patient_provider.dart';
import '../../core/utils/animations.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class UploadReportsScreen extends StatefulWidget {
  const UploadReportsScreen({super.key});

  @override
  State<UploadReportsScreen> createState() => _UploadReportsScreenState();
}

class _UploadReportsScreenState extends State<UploadReportsScreen> {
  final Map<String, bool> _uploaded = {
    'Iris (Left)': false,
    'Iris (Right)': false,
    'Tongue': false,
    'Nails': false,
    'Hair': false,
    'Blood Report': false,
  };
  final Map<String, IconData> _icons = {
    'Iris (Left)': Icons.visibility_rounded,
    'Iris (Right)': Icons.visibility_rounded,
    'Tongue': Icons.face_rounded,
    'Nails': Icons.back_hand_rounded,
    'Hair': Icons.face_retouching_natural_rounded,
    'Blood Report': Icons.bloodtype_rounded,
  };
  bool _isProcessing = false;
  final Map<String, String?> _fileNames = {};

  int get _uploadedCount => _uploaded.values.where((v) => v).length;

  Future<void> _pickFile(String key, {bool isImage = true}) async {
    final result = await FilePicker.platform.pickFiles(
      type: isImage ? FileType.image : FileType.custom,
      allowedExtensions: isImage ? null : ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _uploaded[key] = true;
        _fileNames[key] = file.name;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${file.name} uploaded successfully!',
                style: GoogleFonts.nunito()),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _processReports() async {
    if (_uploadedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload at least one file.',
              style: GoogleFonts.nunito()),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    setState(() => _isProcessing = true);
    final uploadedSections =
        _uploaded.entries.where((e) => e.value).map((e) => e.key).toSet();
    await context
        .read<PatientProvider>()
        .processReport(uploadedSections: uploadedSections);
    if (mounted) {
      setState(() => _isProcessing = false);
      Navigator.pushNamed(context, '/ai-report');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Reports',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: _isProcessing
          ? _buildProcessingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  AnimateIn(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.biotech_rounded,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Health Analysis',
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Upload your reports & images for a comprehensive Ayurvedic AI diagnosis.',
                                  style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Upload progress
                  AnimateIn(
                    delay: const Duration(milliseconds: 100),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Files Uploaded: $_uploadedCount/${_uploaded.length}',
                              style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: context.txt),
                            ),
                            Text(
                              '$_uploadedCount uploaded',
                              style: GoogleFonts.nunito(
                                  fontSize: 13, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _uploadedCount / _uploaded.length,
                            minHeight: 6,
                            backgroundColor: context.surfaceVariant,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  AnimateIn(
                    delay: const Duration(milliseconds: 150),
                    child: const SectionHeader(title: 'Diagnostic Images'),
                  ),
                  const SizedBox(height: 14),
                  _buildImageUploads(),
                  const SizedBox(height: 24),

                  AnimateIn(
                    delay: const Duration(milliseconds: 250),
                    child: const SectionHeader(title: 'Medical Reports'),
                  ),
                  const SizedBox(height: 14),
                  AnimateIn(
                    delay: const Duration(milliseconds: 300),
                    child: _buildReportUpload(),
                  ),
                  const SizedBox(height: 24),

                  // Info
                  AnimateIn(
                    delay: const Duration(milliseconds: 350),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardGold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.lock_rounded,
                                color: AppColors.accent, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your data is secure',
                                  style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark),
                                ),
                                Text(
                                  'All uploads are encrypted and processed locally. We never share your health data.',
                                  style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: context.txtSecondary,
                                      height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(
                    label: 'Analyse with AI',
                    onTap: _processReports,
                    icon: Icons.auto_awesome_rounded,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildImageUploads() {
    final imageKeys = [
      'Iris (Left)',
      'Iris (Right)',
      'Tongue',
      'Nails',
      'Hair'
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.3,
      ),
      itemCount: imageKeys.length,
      itemBuilder: (_, i) => AnimateIn(
        delay: Duration(milliseconds: 200 + i * 60),
        child: _UploadTile(
          label: imageKeys[i],
          icon: _icons[imageKeys[i]]!,
          uploaded: _uploaded[imageKeys[i]]!,
          fileName: _fileNames[imageKeys[i]],
          onTap: () => _pickFile(imageKeys[i]),
        ),
      ),
    );
  }

  Widget _buildReportUpload() {
    return _UploadTile(
      label: 'Blood Report (PDF/Image)',
      icon: Icons.bloodtype_rounded,
      uploaded: _uploaded['Blood Report']!,
      fileName: _fileNames['Blood Report'],
      onTap: () => _pickFile('Blood Report', isImage: false),
      wide: true,
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimateIn(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.psychology_rounded,
                    size: 56, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            AnimateIn(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'AI is Analysing\nYour Health Data',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: context.txt,
                    height: 1.3),
              ),
            ),
            const SizedBox(height: 16),
            AnimateIn(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Cross-referencing your reports with 1000+ Ayurvedic principles...',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: 14, color: context.txtSecondary, height: 1.5),
              ),
            ),
            const SizedBox(height: 36),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'This may take a moment...',
              style: GoogleFonts.nunito(fontSize: 13, color: context.txtLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool uploaded;
  final VoidCallback onTap;
  final bool wide;
  final String? fileName;

  const _UploadTile({
    required this.label,
    required this.icon,
    required this.uploaded,
    required this.onTap,
    this.wide = false,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uploaded ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: uploaded ? AppColors.cardGreen : context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: uploaded ? AppColors.primary : context.border,
            width: uploaded ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: uploaded
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : context.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon,
                      size: 22,
                      color: uploaded ? AppColors.primary : context.txtLight),
                ),
                if (uploaded)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: uploaded ? AppColors.primaryDark : context.txt,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              uploaded ? (fileName ?? 'Uploaded') : 'Tap to upload',
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: uploaded ? AppColors.success : context.txtLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
