import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class NotifyingScreen extends StatelessWidget {
  const NotifyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          _buildBackgroundDecor(),
          _buildContent(context),
          _buildBrandFooter(),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        Positioned(
          top: -50, right: -30,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -60, left: -30,
          child: Container(
            width: 250, height: 250,
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withOpacity(0.85),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 40,
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageHeader(context),
                _buildTextContent(),
                _buildActionFooter(context),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.97, 0.97)),
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          color: AppColors.surfaceContainerHighest,
          child: const Icon(Icons.wb_twilight_rounded,
              size: 80, color: AppColors.outlineVariant),
        ),
        Positioned(
          top: 0, bottom: 0, left: 0, right: 0,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.surfaceContainerLowest],
              ),
            ),
          ),
        ),
        Positioned(
          top: 16, left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_left_rounded,
                  color: AppColors.onSurfaceVariant),
            ),
          ),
        ),
        Positioned(
          top: 16, right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text('Happening Now', style: GoogleFonts.manrope(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant, letterSpacing: 1.5,
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.push_pin_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text('DAILY CURATION', style: GoogleFonts.manrope(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: AppColors.primary, letterSpacing: 1.5,
              )),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Evening ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36, fontWeight: FontWeight.w800,
                    color: AppColors.onSurface, height: 1.1,
                  ),
                ),
                TextSpan(
                  text: 'Reflection',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36, fontWeight: FontWeight.w800,
                    color: AppColors.tertiary, height: 1.1,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: ' & Strategy Session',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36, fontWeight: FontWeight.w800,
                    color: AppColors.onSurface, height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Time to pause and curate your thoughts for tomorrow. Gather your notes and find a quiet space.',
            style: GoogleFonts.manrope(
              fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              _buildChip(Icons.schedule_rounded, '18:30 PM', AppColors.secondaryContainer),
              _buildChip(Icons.location_on_outlined, 'Home Office', AppColors.surfaceContainerHigh),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.manrope(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          )),
        ],
      ),
    );
  }

  Widget _buildActionFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.5),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: Text('OK', style: GoogleFonts.manrope(
                fontSize: 13, fontWeight: FontWeight.w800,
                color: AppColors.onSurfaceVariant,
              )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDim],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notifications_paused_outlined,
                    size: 18, color: AppColors.onPrimary),
                label: Text('REMIND ME', style: GoogleFonts.manrope(
                  fontSize: 12, fontWeight: FontWeight.w800,
                  color: AppColors.onPrimary, letterSpacing: 1,
                )),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandFooter() {
    return Positioned(
      bottom: 16,
      left: 0, right: 0,
      child: Center(
        child: Opacity(
          opacity: 0.3,
          child: Text('remindu', style: GoogleFonts.plusJakartaSans(
            fontSize: 18, fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: AppColors.onSurface,
          )),
        ),
      ),
    );
  }
}