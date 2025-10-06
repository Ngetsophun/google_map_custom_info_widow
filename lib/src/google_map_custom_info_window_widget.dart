// import 'package:flutter/material.dart';
// import 'controller.dart';
//
// class GoogleMapCustomInfoWindow extends StatefulWidget {
//   final CustomInfoWindowController controller;
//   final double? width;
//   final double? height; // optional
//   final double verticalOffset; // extra pixels above marker
//   final bool showArrow;
//   final void Function(double)? onHeightChanged; // optional callback
//
//   const GoogleMapCustomInfoWindow({
//     super.key,
//     required this.controller,
//     this.width = 260,
//     this.height,
//     this.verticalOffset = 8,
//     this.showArrow = true,
//     this.onHeightChanged,
//   });
//
//   @override
//   State<GoogleMapCustomInfoWindow> createState() =>
//       _GoogleMapCustomInfoWindowState();
// }
//
// class _GoogleMapCustomInfoWindowState extends State<GoogleMapCustomInfoWindow> {
//   final GlobalKey _key = GlobalKey();
//   double _windowHeight = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.setOnChange(_onControllerChange);
//     WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());
//   }
//
//   @override
//   void didUpdateWidget(covariant GoogleMapCustomInfoWindow oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.controller != widget.controller) {
//       oldWidget.controller.setOnChange(null);
//       widget.controller.setOnChange(_onControllerChange);
//     }
//   }
//
//   @override
//   void dispose() {
//     widget.controller.setOnChange(null);
//     super.dispose();
//   }
//
//   void _onControllerChange() {
//     if (mounted) setState(() {});
//   }
//
//   void _updateHeight() {
//     if (_key.currentContext != null) {
//       final renderBox = _key.currentContext!.findRenderObject() as RenderBox?;
//       if (renderBox != null) {
//         final newHeight = renderBox.size.height;
//         if (_windowHeight != newHeight) {
//           setState(() => _windowHeight = newHeight);
//           if (widget.onHeightChanged != null) {
//             widget.onHeightChanged!(newHeight);
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final child = widget.controller.child;
//     final offset = widget.controller.screenOffset;
//
//     if (child == null || offset == null) return const SizedBox.shrink();
//
//     return Positioned(
//       left: offset.dx - (widget.width! / 2),
//       top: offset.dy - _windowHeight - widget.verticalOffset,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Material(
//             key: _key,
//             elevation: 8,
//             borderRadius: BorderRadius.circular(10),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minWidth: widget.width!,
//                 maxWidth: widget.width!,
//               ),
//               child: IntrinsicHeight(
//                 child: child,
//               ),
//             ),
//           ),
//           if (widget.showArrow)
//             CustomPaint(
//               size: const Size(20, 10),
//               painter: _ArrowPainter(),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());
//   }
// }
//
// class _ArrowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.white;
//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width / 2, size.height)
//       ..lineTo(size.width, 0)
//       ..close();
//     canvas.drawShadow(path, Colors.black26, 3, true);
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'controller.dart';

class GoogleMapCustomInfoWindow extends StatefulWidget {
  final CustomInfoWindowController controller;
  final double? width;
  final double? height; // optional
  final double verticalOffset; // extra pixels above marker
  final bool showArrow;

  const GoogleMapCustomInfoWindow({
    super.key,
    required this.controller,
    this.width = 260,
    this.height,
    this.verticalOffset = 8,
    this.showArrow = true,
  });

  @override
  State<GoogleMapCustomInfoWindow> createState() =>
      _GoogleMapCustomInfoWindowState();
}

class _GoogleMapCustomInfoWindowState
    extends State<GoogleMapCustomInfoWindow> {
  final GlobalKey _key = GlobalKey();
  double _windowHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.setOnChange(_onControllerChange);
  }

  @override
  void didUpdateWidget(covariant GoogleMapCustomInfoWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.setOnChange(null);
      widget.controller.setOnChange(_onControllerChange);
    }
  }

  @override
  void dispose() {
    widget.controller.setOnChange(null);
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  void _updateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_key.currentContext != null) {
        final renderBox =
        _key.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          setState(() {
            _windowHeight = renderBox.size.height;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.controller.child;
    final offset = widget.controller.screenOffset;

    if (child == null || offset == null) return const SizedBox.shrink();

    return Positioned(
      left: offset.dx - (widget.width! / 2),
      top: offset.dy - _windowHeight - widget.verticalOffset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            key: _key,
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: widget.width!,
                maxWidth: widget.width!,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // After layout, update window height
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateHeight();
                  });

                  return IntrinsicHeight(
                    child: child,
                  );
                },
              ),
            ),
          ),
          if (widget.showArrow)
            CustomPaint(
              size: const Size(20, 10),
              painter: _ArrowPainter(),
            ),
        ],
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawShadow(path, Colors.black26, 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
