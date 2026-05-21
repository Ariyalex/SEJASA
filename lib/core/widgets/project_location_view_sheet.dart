import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/widgets/my_filled_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/widgets/my_outline_button.dart';
import 'package:geolocator/geolocator.dart';

/// Shows a bottom sheet utilizing Wolt Modal Sheet to display the project location.
/// It also enables comparing the project location with the user's current location,
/// showing a straight-line Polyline, calculating distance, and auto-framing both points.
void showProjectLocationView({
  required BuildContext context,
  required LatLng projectLocation,
  required String projectAddress,
  required String projectName,
}) {
  WoltModalSheet.show<void>(
    context: context,
    useSafeArea: true,
    pageListBuilder: (modalSheetContext) {
      return [
        WoltModalSheetPage(
          enableDrag: true,
          hasTopBarLayer: false,
          pageTitle: const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Text(
              'Lokasi Proyek',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          child: ProjectLocationViewContent(
            projectLocation: projectLocation,
            projectAddress: projectAddress,
            projectName: projectName,
          ),
        ),
      ];
    },
  );
}

class ProjectLocationViewContent extends HookWidget {
  final LatLng projectLocation;
  final String projectAddress;
  final String projectName;

  const ProjectLocationViewContent({
    super.key,
    required this.projectLocation,
    required this.projectAddress,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationService = getIt<LocationService>();
    final mapController = useMemoized(() => MapController());

    final userLocation = useState<LatLng?>(null);
    final showComparison = useState<bool>(false);
    final distanceText = useState<String?>(null);
    final isLoadingUserLocation = useState<bool>(false);

    final resolvedProjectAddress = useState<String>("");

    useEffect(() {
      locationService
          .getAddressFromLatLng(projectLocation)
          .then((value) {
            resolvedProjectAddress.value = value;
          })
          .catchError((e) {
            resolvedProjectAddress.value = "Gagal memuat alamat";
          });
      return null;
    }, [projectLocation]);

    Future<void> handleCompareLocation() async {
      isLoadingUserLocation.value = true;
      try {
        final pos = await locationService.getCurrentLocation(context);
        if (pos != null) {
          final uLoc = LatLng(pos.latitude, pos.longitude);
          userLocation.value = uLoc;
          showComparison.value = true;

          // Calculate geodesic distance using Geolocator
          final distanceInMeters = Geolocator.distanceBetween(
            uLoc.latitude,
            uLoc.longitude,
            projectLocation.latitude,
            projectLocation.longitude,
          );

          if (distanceInMeters >= 1000) {
            final km = distanceInMeters / 1000;
            distanceText.value = "${km.toStringAsFixed(2)} KM";
          } else {
            distanceText.value = "${distanceInMeters.toStringAsFixed(0)} M";
          }

          // Auto-frame map camera to fit both points perfectly with padding
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final bounds = LatLngBounds.fromPoints([projectLocation, uLoc]);
            mapController.fitCamera(
              CameraFit.bounds(
                bounds: bounds,
                padding: const EdgeInsets.all(60),
              ),
            );
          });
        }
      } catch (e) {
        debugPrint("Error comparing location: $e");
      } finally {
        isLoadingUserLocation.value = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Basic details
          Text(
            projectName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Skeletonizer(
            enabled: resolvedProjectAddress.value.isEmpty,
            child: Text(
              resolvedProjectAddress.value.isEmpty
                  ? 'random teks aja buat isi dari skeletonizer, ahhhhh sani sahhhh, ooofosoafodsafdsfgsdfsdf askf jadshf sabfkasdbf'
                  : resolvedProjectAddress.value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            projectAddress,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Map Component
          Stack(
            children: [
              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: projectLocation,
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.sejasa',
                      ),
                      // Polyline showing connection line
                      if (showComparison.value && userLocation.value != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [projectLocation, userLocation.value!],
                              strokeWidth: 4.0,
                              color: theme.colorScheme.primary,
                              pattern: const StrokePattern.dotted(),
                            ),
                          ],
                        ),
                      // Markers
                      MarkerLayer(
                        markers: [
                          // Project Pin
                          Marker(
                            point: projectLocation,
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.location_on,
                              color: theme.colorScheme.error,
                              size: 40,
                            ),
                          ),
                          // User Pin
                          if (showComparison.value &&
                              userLocation.value != null)
                            Marker(
                              point: userLocation.value!,
                              width: 60,
                              height: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Distance Card
              if (showComparison.value && distanceText.value != null)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.route,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Jarak ke Proyek: ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          distanceText.value!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: MyOutlineButton(
                  onPressed: isLoadingUserLocation.value
                      ? null
                      : handleCompareLocation,
                  child: isLoadingUserLocation.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(LucideIcons.compass, size: 18),
                            SizedBox(width: 8),
                            Text("Bandingkan Lokasi"),
                          ],
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MyFilledButton(
                  onPressed: () => Navigator.pop(context),

                  child: const Text("Selesai"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
