import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/speech_service.dart';
import '../chat/chat_screen.dart';
import 'widgets/glow_orb.dart';
import 'widgets/waveform_bar.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final SpeechService _speechService = SpeechService.instance;
  String _recognizedText = 'Go ahead, I\'m listening';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Auto-start listening on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _toggleListening();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speechService.stopListening();
    super.dispose();
  }

  void _toggleListening() async {
    if (_speechService.isListening) {
      await _speechService.stopListening();
    } else {
      await _speechService.startListening((text) {
        setState(() {
          _recognizedText = text.isEmpty ? "Go ahead, I'm listening" : text;
        });
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _speechService,
      builder: (context, _) {
        final isListening = _speechService.isListening;
        final soundLevel = _speechService.soundLevel;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ── Header ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(children: [
                        const Text(
                          'Speaking to AI',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (_, __) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isListening
                                      ? Color.lerp(AppColors.green, AppColors.cyan,
                                          _pulseController.value)!
                                      : AppColors.textDisabled,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isListening ? 'Listening…' : 'Paused',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isListening
                                      ? AppColors.green
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  // ── Subtitle / Visual Cue ──
                  Text(
                    isListening ? "Go ahead, I'm listening" : "Tap microphone to talk",
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 14),
                  ),

                  // ── Animated Orb ──
                  GlowOrb(
                    isListening: isListening,
                    soundLevel: soundLevel,
                  ),

                  // ── Recognized Text ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _recognizedText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // ── Waveform visual ──
                  WaveformBar(isListening: isListening),

                  // ── Controls ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Keyboard / manual chat button
                      _VoiceCircleBtn(
                        icon: Icons.keyboard_alt_outlined,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChatScreen(),
                            ),
                          );
                        },
                      ),
                      // Mic toggle button
                      GestureDetector(
                        onTap: _toggleListening,
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isListening
                                ? AppColors.primaryGradient
                                : const LinearGradient(
                                    colors: [
                                      AppColors.surface2,
                                      AppColors.surface
                                    ],
                                  ),
                            boxShadow: isListening
                                ? [
                                    BoxShadow(
                                      color: AppColors.purple.withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            isListening
                                ? Icons.mic_rounded
                                : Icons.mic_off_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Close button
                      _VoiceCircleBtn(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VoiceCircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _VoiceCircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
          color: AppColors.surface,
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}
