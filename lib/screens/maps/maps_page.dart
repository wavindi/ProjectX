import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'find_ride_page.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  LatLng? _origin;
  LatLng? _destination;
  List<LatLng> _routePoints = [];

  // Germany coordinates
  static const LatLng _germanyLocation = LatLng(51.1657, 10.4515);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _origin = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    _mapController.move(
      LatLng(position.latitude, position.longitude),
      13,
    );
  }

  void _drawRoute() {
    if (_origin == null || _destination == null) return;

    setState(() {
      _routePoints = [_origin!, _destination!];
    });

    // Calculate bounds to show both points
    final bounds = LatLngBounds.fromPoints(_routePoints);
    _mapController.fitBounds(
      bounds,
      options: const FitBoundsOptions(padding: EdgeInsets.all(50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _germanyLocation,
            initialZoom: 6,
            onTap: (tapPosition, point) {
              if (_origin == null) {
                setState(() {
                  _origin = point;
                });
              } else if (_destination == null) {
                setState(() {
                  _destination = point;
                });
                _drawRoute();
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.luxpool',
            ),
            MarkerLayer(
              markers: [
                if (_origin != null)
                  Marker(
                    point: _origin!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.green),
                  ),
                if (_destination != null)
                  Marker(
                    point: _destination!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red),
                  ),
              ],
            ),
            PolylineLayer(
              polylines: [
                if (_routePoints.isNotEmpty)
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4,
                  ),
              ],
            ),
          ],
        ),
        // Search boxes
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Current Location',
                    prefixIcon: Icon(Icons.location_on, color: Colors.green),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  readOnly: true,
                  onTap: _getCurrentLocation,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Where to?',
                    prefixIcon: Icon(Icons.location_on, color: Colors.red),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Find Ride button
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FindRidePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Find a Ride',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 