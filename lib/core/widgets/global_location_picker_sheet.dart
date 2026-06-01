import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:sejasa/core/widgets/project_location_picker.dart';

/// Shows the global location picker bottom sheet utilizing Wolt Modal Sheet.
/// It displays the map and allows selecting a point, resolving the address dynamically,
/// and returning it in [onLocationSelected].
void showGlobalLocationPicker({
  required BuildContext context,
  LatLng? initialLocation,
  String? initialAddress,
  required Function(LatLng location, String address) onLocationSelected,
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
            padding: EdgeInsets.fromLTRB(16.0, 20, 16, 0),
            child: Text(
              'Pilih Lokasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          child: GlobalLocationPickerContent(
            initialLocation: initialLocation,
            initialAddress: initialAddress,
            onLocationSelected: (location, address) {
              onLocationSelected(location, address);
              Navigator.pop(modalSheetContext);
            },
          ),
        ),
      ];
    },
  );
}

class GlobalLocationPickerContent extends HookWidget {
  final LatLng? initialLocation;
  final String? initialAddress;
  final Function(LatLng location, String address) onLocationSelected;

  const GlobalLocationPickerContent({
    super.key,
    this.initialLocation,
    this.initialAddress,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedLocation = useState<LatLng?>(initialLocation);
    final selectedAddress = useState<String>(
      initialAddress ?? "Lokasi belum ditentukan",
    );
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProjectLocationPicker(
            initialLocation: selectedLocation.value,
            initialAddress: selectedAddress.value,
            onLocationChanged: (location, address) {
              selectedLocation.value = location;
              selectedAddress.value = address;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Lokasi Terpilih:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.mapPin,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedAddress.value,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: selectedLocation.value == null
                ? null
                : () {
                    onLocationSelected(
                      selectedLocation.value!,
                      selectedAddress.value,
                    );
                  },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Selesai"),
          ),
        ],
      ),
    );
  }
}
