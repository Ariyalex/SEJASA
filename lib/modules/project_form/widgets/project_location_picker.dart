import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ProjectLocationPicker extends HookWidget {
  final LatLng? initialLocation;
  final String? initialAddress;
  final Function(LatLng location, String address) onLocationChanged;

  const ProjectLocationPicker({
    super.key,
    this.initialLocation,
    this.initialAddress,
    required this.onLocationChanged,
  });

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getAddressFromLatLng(LatLng point) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Use local variables to capture properties and avoid repeated getter calls
        // which helps with null safety and avoids the need for '!'
        final street = place.street;
        final subLocality = place.subLocality;
        final locality = place.locality;
        final subAdministrativeArea = place.subAdministrativeArea;
        final administrativeArea = place.administrativeArea;
        final postalCode = place.postalCode;

        // Construct a readable address
        final parts = [
          if (street != null && street.isNotEmpty) street,
          if (subLocality != null && subLocality.isNotEmpty) subLocality,
          if (locality != null && locality.isNotEmpty) locality,
          if (subAdministrativeArea != null && subAdministrativeArea.isNotEmpty)
            subAdministrativeArea,
          if (administrativeArea != null && administrativeArea.isNotEmpty)
            administrativeArea,
          if (postalCode != null && postalCode.isNotEmpty) postalCode,
        ];
        return parts.join(', ');
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
    return 'Alamat tidak ditemukan (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})';
  }

  @override
  Widget build(BuildContext context) {
    final selectedLocation = useState<LatLng?>(initialLocation);
    final mapController = useMemoized(() => MapController());
    final isLoading = useState(false);

    // Initial positioning
    useEffect(() {
      if (initialLocation == null) {
        isLoading.value = true;
        _getCurrentLocation().then((position) {
          if (position != null) {
            final userLoc = LatLng(position.latitude, position.longitude);
            mapController.move(userLoc, 15.0);
          }
          isLoading.value = false;
        });
      }
      return null;
    }, []);

    // Default to Jakarta if no location provided yet
    final center = initialLocation ?? const LatLng(-6.2088, 106.8456);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lokasi Project',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (isLoading.value)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                icon: const Icon(Icons.my_location, size: 20),
                onPressed: () async {
                  isLoading.value = true;
                  final pos = await _getCurrentLocation();
                  if (pos != null) {
                    final loc = LatLng(pos.latitude, pos.longitude);
                    mapController.move(loc, 15.0);

                    // Auto select current location and get address
                    selectedLocation.value = loc;
                    final address = await _getAddressFromLatLng(loc);
                    onLocationChanged(loc, address);
                  }
                  isLoading.value = false;
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15.0,
                onTap: (tapPosition, point) async {
                  selectedLocation.value = point;
                  isLoading.value = true;
                  final address = await _getAddressFromLatLng(point);
                  onLocationChanged(point, address);
                  isLoading.value = false;
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.sejasa',
                ),
                if (selectedLocation.value case final loc?)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: loc,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ketuk peta untuk memilih lokasi project secara presisi.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
