import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/location_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final locationService = getIt<LocationService>();
    final isMounted = useIsMounted();
    final selectedLocation = useState<LatLng?>(initialLocation);
    final mapController = useMemoized(() => MapController());
    final isLoading = useState(false);

    // Initial positioning
    useEffect(() {
      if (initialLocation == null) {
        isLoading.value = true;
        locationService.getCurrentLocation(context).then((position) {
          if (!isMounted()) return;
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
                  final pos = await locationService.getCurrentLocation(context);
                  if (!isMounted()) return;
                  if (pos != null) {
                    final loc = LatLng(pos.latitude, pos.longitude);
                    mapController.move(loc, 15.0);

                    // Auto select current location and get address
                    selectedLocation.value = loc;
                    final address = await locationService.getAddressFromLatLng(
                      loc,
                    );
                    if (!isMounted()) return;
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
                  final address = await locationService.getAddressFromLatLng(
                    point,
                  );
                  if (!isMounted()) return;
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
