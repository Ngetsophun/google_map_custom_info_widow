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
            verticalOffset: 15, // marker offset
            showArrow: true,
          )
        ],
      ),
    );
  }
}
