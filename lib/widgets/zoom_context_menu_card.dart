import 'dart:ui';

import 'package:flutter/material.dart';

class ZoomContextMenuCard extends StatefulWidget {
  final Widget child;
  final List<MenuOption> menuOptions;

  const ZoomContextMenuCard({
    super.key,
    required this.child,
    required this.menuOptions,
  });

  @override
  State<ZoomContextMenuCard> createState() =>
      _ZoomContextMenuCardState();
}

class _ZoomContextMenuCardState extends State<ZoomContextMenuCard>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _menuOffsetAnimation;

  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _menuOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _removeOverlay,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.black,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: widget.child,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _menuOffsetAnimation,
                    child: _buildContextMenu(widget.menuOptions),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _removeOverlay() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  Widget _buildContextMenu(List<MenuOption> menuOptions) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...menuOptions.map(
                (e) => _menuItem(e.label, e.icon, e.callback),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    String title,
    IconData icon,
    VoidCallback callback,
  ) {
    return InkWell(
      onTap: () {
        _removeOverlay();
        callback.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _cardKey,
      onLongPress: _showOverlay,
      child: widget.child,
    );
  }
}

class MenuOption {
  final String label;
  final IconData icon;
  final VoidCallback callback;

  MenuOption(this.label, this.icon, this.callback);
}
