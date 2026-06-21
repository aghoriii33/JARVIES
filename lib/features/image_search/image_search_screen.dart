import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/services/ai_service.dart';

class ImageSearchScreen extends StatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanCtrl;
  final ImagePicker _picker = ImagePicker();
  
  XFile? _selectedImage;
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  String? _analysisResult;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _error = null;
        _analysisResult = null;
        _isAnalyzing = false;
      });

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();
      
      setState(() {
        _selectedImage = image;
        _imageBytes = bytes;
        _isAnalyzing = true;
      });

      _scanCtrl.repeat();

      // Trigger actual AI Service vision analysis
      final result = await AiService.instance.analyzeImage(bytes);

      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
      _scanCtrl.stop();
    } catch (e) {
      debugPrint('Error analyzing image: $e');
      setState(() {
        _error = 'Failed to analyze image: $e';
        _isAnalyzing = false;
      });
      _scanCtrl.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text('Search by Image',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 48),
              ]),
            ),

            // Viewfinder
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Stack(alignment: Alignment.center, children: [
                        // Viewfinder card
                        Container(
                          width: double.infinity,
                          height: 320,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(27),
                            child: _imageBytes != null
                                ? (kIsWeb
                                    ? Image.network(
                                        _selectedImage!.path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_selectedImage!.path),
                                        fit: BoxFit.cover,
                                      ))
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_outlined,
                                          size: 60,
                                          color: AppColors.textDisabled),
                                      const SizedBox(height: 12),
                                      const Text(
                                          'Tap to upload or take a photo',
                                          style: TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 13)),
                                    ],
                                  ),
                          ),
                        ),
                        // Corner markers
                        ..._buildCorners(),
                        // Scanning line overlay
                        if (_isAnalyzing)
                          AnimatedBuilder(
                            animation: _scanCtrl,
                            builder: (_, __) {
                              return Positioned(
                                top: _scanCtrl.value * 300,
                                child: Container(
                                  width: 280,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.transparent,
                                      AppColors.cyan.withOpacity(0.8),
                                      Colors.transparent,
                                    ]),
                                  ),
                                ),
                              );
                            },
                          ),
                      ]),
                      const SizedBox(height: 30),

                      // Action buttons
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _ImgBtn(
                              icon: Icons.photo_library_rounded,
                              label: 'Gallery',
                              onTap: () => _pickImage(ImageSource.gallery),
                            ),
                            const SizedBox(width: 16),
                            _ImgBtn(
                              icon: Icons.camera_alt_rounded,
                              label: 'Camera',
                              onTap: () => _pickImage(ImageSource.camera),
                              isPrimary: true,
                            ),
                            const SizedBox(width: 16),
                            _ImgBtn(
                              icon: Icons.link_rounded,
                              label: 'URL',
                              onTap: () {
                                // Can add URL paste popup here
                              },
                            ),
                          ]),
                      const SizedBox(height: 30),

                      // Error message if any
                      if (_error != null) ...[
                        Text(
                          _error!,
                          style: const TextStyle(color: AppColors.pink, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Loading vision analysis state
                      if (_isAnalyzing) ...[
                        const CircularProgressIndicator(color: AppColors.cyan),
                        const SizedBox(height: 10),
                        const Text(
                          'AI Wave is examining image details...',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Result preview
                      if (_analysisResult != null) ...[
                        GlassCard(
                          padding: const EdgeInsets.all(16),
                          radius: 20,
                          borderColor: AppColors.purple.withOpacity(0.3),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const Icon(Icons.auto_awesome,
                                      color: AppColors.purple, size: 16),
                                  const SizedBox(width: 8),
                                  const Text('AI Analysis',
                                      style: TextStyle(
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: AppColors.green.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Analysis complete',
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 11)),
                                  ),
                                ]),
                                const SizedBox(height: 12),
                                Text(
                                  _analysisResult!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      height: 1.5),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const s = 24.0;
    const t = 3.0;
    return [
      Positioned(top: 0, left: 0, child: _Corner(s, t)),
      Positioned(
          top: 0,
          right: 0,
          child: Transform.scale(scaleX: -1, child: _Corner(s, t))),
      Positioned(
          bottom: 0,
          left: 0,
          child: Transform.scale(scaleY: -1, child: _Corner(s, t))),
      Positioned(
          bottom: 0,
          right: 0,
          child:
              Transform.scale(scaleX: -1, scaleY: -1, child: _Corner(s, t))),
    ];
  }
}

class _Corner extends StatelessWidget {
  final double s, t;
  const _Corner(this.s, this.t);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: s,
      height: s,
      child: CustomPaint(painter: _CornerPainter(t)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final double t;
  _CornerPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.cyan
      ..strokeWidth = t
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), p);
    canvas.drawLine(Offset.zero, Offset(0, size.height), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ImgBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ImgBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.primaryGradient : null,
            color: isPrimary ? null : AppColors.surface,
            shape: BoxShape.circle,
            border: isPrimary ? null : Border.all(color: AppColors.border),
          ),
          child: Icon(icon,
              color: isPrimary ? Colors.white : AppColors.textSecondary,
              size: 22),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ]),
    );
  }
}
