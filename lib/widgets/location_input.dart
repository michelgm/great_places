import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPosition;

  const LocationInput(this.onSelectPosition, {Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();

      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPosition(LatLng(
        locData.latitude!,
        locData.longitude!,
      ));
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(),
      ),
    );

    if (selectedPosition == null) return;

    _showPreview(selectedPosition.latitude, selectedPosition.longitude);
    widget.onSelectPosition(selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text('Localização não informada')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Localização atual'),
              //textColor: Theme.of(context).primaryColor,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                //onPrimary: Colors.red,
                onPrimary: Theme.of(context).colorScheme.primary,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _getCurrentUserLocation,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Selecione no Mapa'),
              //textColor: Theme.of(context).primaryColor,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                //onPrimary: Colors.red,
                onPrimary: Theme.of(context).colorScheme.primary,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
