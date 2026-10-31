import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'desktop_prompt.dart';
import 'intro_overlay.dart';

/// Wraps the router's navigator: plays the intro once per launch, then on
/// the web explains once why the map is what you get (the router already
/// starts there; see `webRedirect`).
class IntroGate extends StatefulWidget {
  const IntroGate({super.key, required this.child, this.playIntro = true});

  final Widget child;
  final bool playIntro;

  @override
  State<IntroGate> createState() => _IntroGateState();
}

class _IntroGateState extends State<IntroGate> {
  late bool _intro = widget.playIntro;
  bool _prompt = false;

  void _introDone() {
    if (!mounted) return;
    setState(() {
      _intro = false;
      _prompt = kIsWeb;
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
