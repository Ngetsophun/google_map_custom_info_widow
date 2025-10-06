// lib/src/controller.dart
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Controller for showing/hiding/updating a custom info window above a marker.
class CustomInfoWindowController {
  GoogleMapController? googleMapController;

  Widget? _child;
  LatLng? _position;
  Offset? _screenOffset;
  VoidCallback? _onChange;

  /// Internal: called by the widget to register for updates
  void setOnChange(VoidCallback? fn) => _onChange = fn;

  void _notify() => _onChange?.call();

  /// Show an info window with [child] at [position].
  /// If the GoogleMapController isn't set yet, the widget will appear after
  /// the controller is assigned and [update] is called.
  Future<void> showInfoWindow(Widget child, LatLng position) async {
    _child = child;
    _position = position;
    await _updateScreenOffset();
    _notify();
  }

  /// Hide the info window
  void hideInfoWindow() {
    _child = null;
    _position = null;
    _screenOffset = null;
    _notify();
  }

  /// Recalculate screen coordinate from the saved LatLng (call on camera move/idle)
  Future<void> update() async {
    await _updateScreenOffset();
    _notify();
  }

  Future<void> _updateScreenOffset() async {
    if (_position == null || googleMapController == null) {
      _screenOffset = null;
      return;
    }
    try {
      final sc = await googleMapController!.getScreenCoordinate(_position!);
      _screenOffset = Offset(sc.x.toDouble(), sc.y.toDouble());
    } catch (_) {
      _screenOffset = null;
    }
  }

  // getters used by the widget
  Widget? get child => _child;
  Offset? get screenOffset => _screenOffset;
  LatLng? get position => _position;
}
