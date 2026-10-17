import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/animations.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class ScanUploadScreen extends StatefulWidget {
  const ScanUploadScreen({super.key});

  @override
  State<ScanUploadScreen> createState() => _ScanUploadScreenState();
}

class _ScanUploadScreenState extends State<ScanUploadScreen> {
  final Map<String, bool> _uploaded = {};
  final Map<String, String?> _fileNames = {};

  static const _scans = [
    _ScanItem(
        key: 'Iris (Eyes)',
        icon: Icons.visibility_rounded,
        description: 'Clear photo of your iris'),
    _ScanItem(
        key: 'Tongue',
        icon: Icons.face_rounded,
        description: 'Stick out tongue, natural light'),
    _ScanItem(
        key: 'Nails',
        icon: Icons.back_hand_rounded,
        description: 'All fingernails, flat surface'),
    _ScanItem(
        key: 'Skin',
        icon: Icons.face_retouching_natural_rounded,
        description: 'Close-up of affected area'),
    _ScanItem(
        key: 'Blood Report',
        icon: Icons.bloodtype_rounded,
        description: 'PDF or photo of latest report'),
  ];

  int get _uploadedCount => _uploaded.values.where((v) => v).length;

  Future<void> _pickFile(String key, {bool isImage = true}) async {
    final result = await FilePicker.platform.pickFiles(
      type: isImage ? FileType.image : FileType.custom,
      allowedExtensions: isImage ? null : ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _uploaded[key] = true;
        _fileNames[key] = result.files.first.name;
      });
    }
  }

  void _continue() {
    Navigator.pushReplacementNamed(context, '/analyzing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AnimateIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.document_scanner_rounded,
                          color: AppColors.accent, size: 24),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Upload Your Scans',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: context.txt,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Our AI analyses iris, tongue, nails & skin patterns to assess your Ayurvedic constitution.',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: context.txtSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text(
                    '$_uploadedCount/${_scans.length} uploaded',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _uploadedCount > 0
                          ? AppColors.primary
                          : context.txtLight,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _continue,
                    child: Text(
                      'Skip for now',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.txtLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scan tiles
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: _scans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final scan = _scans[i];
                  final done = _uploaded[scan.key] ?? false;
                  final isBlood = scan.key == 'Blood Report';
                  return AnimateIn(
                    delay: Duration(milliseconds: 50 + i * 40),
                    child: _ScanTile(
                      scan: scan,
                      done: done,
                      fileName: _fileNames[scan.key],
                      onTap: () => _pickFile(scan.key, isImage: !isBlood),
                    ),
                  );
                },
              ),
            ),

            // Bottom CTA
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 8, 20, MediaQuery.of(context).padding.bottom + 12),
              child: Column(
                children: [
                  // Security note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_rounded,
                          size: 13, color: context.txtLight),
                      const SizedBox(width: 4),
                      Text(
                        'All uploads are encrypted & processed locally',
                        style: GoogleFonts.nunito(
                            fontSize: 12, color: context.txtLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _uploadedCount > 0
                            ? 'Analyse My Health'
                            : 'Continue Without Scans',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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

class _ScanItem {
  final String key;
  final IconData icon;
  final String description;
  const _ScanItem(
      {required this.key, required this.icon, required this.description});
}

class _ScanTile extends StatelessWidget {
  final _ScanItem scan;
  final bool done;
  final String? fileName;
  final VoidCallback onTap;

  const _ScanTile({
    required this.scan,
    required this.done,
    this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: done ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: done
              ? AppColors.primary.withValues(alpha: 0.04)
              : context.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: done
                ? AppColors.primary.withValues(alpha: 0.3)
                : context.border,
            width: done ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: done
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : context.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                scan.icon,
                size: 22,
                color: done ? AppColors.primary : context.txtLight,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.key,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.txt,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    done ? (fileName ?? 'Uploaded') : scan.description,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: done ? AppColors.success : context.txtSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            done
                ? Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 16, color: Colors.white),
                  )
                : Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded,
                        size: 16, color: AppColors.primary),
                  ),
          ],
        ),
      ),
    );
  }
}
