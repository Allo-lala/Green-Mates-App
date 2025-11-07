import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptics.dart';

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  final Widget? icon;

  const AppButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 56,
    this.icon,
    super.key,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  void _onPressed() async {
    await HapticService.mediumTap();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.isOutlined
        ? OutlinedButton.icon(
            onPressed: widget.isLoading ? null : _onPressed,
            icon: widget.icon ?? const SizedBox.shrink(),
            label: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.isOutlined ? AppColors.primary : Colors.white,
                      ),
                    ),
                  )
                : Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          )
        : ElevatedButton.icon(
            onPressed: widget.isLoading ? null : _onPressed,
            icon: widget.icon ?? const SizedBox.shrink(),
            label: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          );

    if (widget.width != null) {
      return SizedBox(
          width: widget.width, height: widget.height, child: button);
    }
    return SizedBox(height: widget.height, child: button);
  }
}
