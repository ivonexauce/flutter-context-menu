import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui'; // For PointerDeviceKind

// Only import dart:html on web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

// Bonus: Custom Interceptor widget to disable browser context menu
class Interceptor extends StatelessWidget {
  final Widget child;

  const Interceptor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Disable browser context menu
      html.document.onContextMenu.listen((event) => event.preventDefault());
    }
    return child;
  }
}

// Custom ContextMenu widget
class ContextMenu extends StatefulWidget {
  final Widget child;

  const ContextMenu({super.key, required this.child});

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Use 2 for right mouse button (secondary)
  static const int secondaryMouseButton = 2;

  void _showMenu(BuildContext context, Offset offset) {
    _removeMenu();

    final RenderBox overlayBox = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Size screenSize = overlayBox.size;

    const menuSize = Size(150, 120);

    double left = offset.dx;
    double top = offset.dy;

    if (left + menuSize.width > screenSize.width) {
      left = screenSize.width - menuSize.width;
    }
    if (top + menuSize.height > screenSize.height) {
      top = screenSize.height - menuSize.height;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: left,
          top: top,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset.zero,
            showWhenUnlinked: false,
            child: _buildMenu(),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildMenu() {
    return Material(
      elevation: 8,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 4),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem("Create"),
            _menuItem("Edit"),
            _menuItem("Remove"),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String label) {
    return InkWell(
      onTap: () {
        _removeMenu();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(label),
      ),
    );
  }

  void _removeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Interceptor(
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            if (event.kind == PointerDeviceKind.mouse &&
                event.buttons == secondaryMouseButton) {
              _showMenu(context, event.position);
            } else {
              _removeMenu();
            }
          },
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeMenu();
    super.dispose();
  }
}

// Main app with a sample usage
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Context Menu Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Context Menu')),
        body: Center(
          child: ContextMenu(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              child: const Text(
                'Right-click me!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}