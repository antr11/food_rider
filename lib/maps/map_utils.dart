import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static void launchMapFromSourceToDestination(double sourceLat,
      double sourceLng, destinationLat, destinationLng) async {
    String mapOptions = [
      '$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dir_action=navigate'
    ].join('&');

    final Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$mapOptions');

    // if (await canLaunch(mapUrl)) {
    //   await launch(mapUrl);
    // } else {
    //   throw "Could not launch $mapUrl";
    // }
    if (await launchUrl(mapUrl)) {
      await launchUrl(mapUrl);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $mapUrl');
      throw "Could not launch $mapUrl";
    }
  }

  // static void lauchMapFromSourceToDestination(
  //       sourceLat, sourceLng, destinationLat, destinationLng) async {
  //     sourceLat, sourceLng, destinationLat, destinationLng) async {
  //   String mapOptions = [
  //     'saddr=$sourceLat,$sourceLng',
  //     'daddr=$destinationLat,$destinationLng',
  //     'dir_action=navigate'
  //   ].join('&');}
  //    final Uri mapUrl = Uri.http(www.google.com/maps?$mapOptions)
  // )
  //Latitude and longitude position params
  static Future<void> openMapWithPosition(
      double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude, $longitude');

    if (!await launchUrl(googleMapUrl)) {
      Fluttertoast.showToast(msg: 'Could not launch $googleMapUrl');
    }
  }
}
