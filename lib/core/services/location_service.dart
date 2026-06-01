import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Show explanation dialog first
        if (context.mounted) {
          final bool? shouldProceed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Izin Lokasi'),
              content: const Text(
                'Aplikasi membutuhkan izin lokasi untuk menentukan titik project Anda di peta dan mendapatkan alamat secara otomatis.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Beri Izin'),
                ),
              ],
            ),
          );

          if (shouldProceed != true) return null;

          // Berikan sedikit waktu agar animasi transisi dialog selesai
          await Future.delayed(const Duration(milliseconds: 200));
        }

        if (permission == LocationPermission.deniedForever) {
          await Geolocator.openAppSettings();
          return null;
        }

        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.deniedForever) {
          // Jika OS secara otomatis menolak permanen, arahkan ke pengaturan
          await Geolocator.openAppSettings();
          return null;
        }

        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  Future<String> getAddressFromLatLng(LatLng point) async {
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
}
