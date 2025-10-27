import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable app logo widget.
///
/// Usage:
///   const WazeetLogo(size: 64)
///   const WazeetLogo.monochrome(size: 32, color: Colors.white)
class WazeetLogo extends StatelessWidget {
  final double size;
  final ColorFilter? _colorFilter;

  const WazeetLogo({super.key, this.size = 64}) : _colorFilter = null;

  WazeetLogo.monochrome({super.key, this.size = 64, required Color color})
      : _colorFilter = ColorFilter.mode(color, BlendMode.srcIn);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo/logo.svg',
      width: size,
      height: size,
      colorFilter: _colorFilter,
      semanticsLabel: 'Wazeet Logo',
    );
  }
}
