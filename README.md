# google_map_custom_info_window

A Flutter package to show fully customizable info windows for markers on **Google Maps**.  
This works with `google_maps_flutter` on mobile and web, allowing you to replace the default info window with any Flutter widget.

## ✨ Features

- 📌 Display custom widgets as Google Maps info windows
- 🎨 Fully customizable UI (colors, text, icons, etc.)
- 🔄 Works with both **Android/iOS** and **Web**
- 🔒 Handles close button and dynamic resizing
- 🚀 Easy integration with existing Google Maps code

## 📦 Installation

---

## 📷 Demo
## Example Screenshot

![Custom Info Window Example](https://raw.githubusercontent.com/Ngetsophun/google_map_custom_info_widow/main/example/assets/img_demo.png)

---

Add to your `pubspec.yaml`:

```yaml
dependencies:
  google_map_custom_info_window: ^0.0.6



## Usage

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_custom_info_widow/google_map_custom_info_widow.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: DemoMap());
}

class DemoMap extends StatefulWidget {
  const DemoMap({super.key});
  @override
  State<DemoMap> createState() => _DemoMapState();
}

class _DemoMapState extends State<DemoMap> {
  final CustomInfoWindowController _infoWindowController =
  CustomInfoWindowController();
  final Set<Marker> _markers = {};

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(11.574223, 104.9244571),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('m1'),
        position: const LatLng(11.574223, 104.9244571),
        onTap: () => _onMarkerTap(const LatLng(11.574223, 104.9244571)),
      ),
    );
  }

  void _onMarkerTap(LatLng pos) {
    _infoWindowController.showInfoWindow(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),

        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Marker title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text('Some extra details here.'),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _infoWindowController.hideInfoWindow(),
                    child: const Text('CLOSE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      pos,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            markers: _markers,
            onMapCreated: (controller) => {
              _infoWindowController.googleMapController = controller,
            },
            onTap: (_) => _infoWindowController.hideInfoWindow(),
            onCameraMove: (_) =>
                _infoWindowController.update(), // update while moving
            onCameraIdle: () =>
                _infoWindowController.update(), // ensure final position
          ),
          // Put this last in Stack so it sits above the map
          GoogleMapCustomInfoWindow(
            controller: _infoWindowController,
            verticalOffset: 50,
            showArrow: true,
          ),
        ],
      ),
    );
  }
}
