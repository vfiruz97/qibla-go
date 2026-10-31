import 'package:flutter/material.dart';

import '../../../core/platform/platform_info.dart';
import 'desktop_prompt.dart';
import 'intro_overlay.dart';

/// Wraps the router's navigator: plays the intro once per launch, then on
/// desktop browsers switches to the map and explains why, once.
class IntroGate extends StatefulWidget {
  const IntroGate({
    super.key,
    required this.child,
    required this.onShowMap,
    this.playIntro = true,
  });

  final Widget child;
  final VoidCallback onShowMap;
  final bool playIntro;

  @override
  State<IntroGate> createState() => _IntroGateState();
}

class _IntroGateState extends State<IntroGate> {
  late bool _intro = widget.playIntro;
  bool _prompt = false;

  void _introDone() {
    if (!mounted) return;
    // Desktop browsers have no compass: open the map first so it is already
    // visible behind the explanation card.
    if (isDesktopBrowser) widget.onShowMap();
    setState(() {
      _intro = false;
      _prompt = isDesktopBrowser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_prompt)
          DesktopPrompt(onContinue: () => setState(() => _prompt = false)),
        if (_intro) IntroOverlay(onDone: _introDone),
      ],
    );
  }
}
