import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:geolocator/geolocator.dart';

Future<Map<String, double>?> getCurrentLocation() async {
  try {
    // Check location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Location services are disabled. Please enable them.',
        isError: true,
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackbar.show(
          title: 'Error',
          message: 'Location permissions are denied.',
          isError: true,
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      CustomSnackbar.show(
        title: 'Error',
        message:
            'Location permissions are permanently denied. Please enable them in settings.',
        isError: true,
      );
      return null;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  } catch (e) {
    print(e);
    CustomSnackbar.show(
      title: 'Error',
      message: 'Failed to get location. Please try again.',
      isError: true,
    );
    return null;
  }
}
