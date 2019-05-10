import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:latlong/latlong.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

String getTimeUntilEvent(DateTime eventDate) {
  int differenceInDay = eventDate.difference(DateTime.now()).inDays;
  int differenceInHours = eventDate.difference(DateTime.now()).inHours;
  int differenceInMinutes = eventDate.difference(DateTime.now()).inMinutes;
  int differenceToPrint;
  String unit;
  if (differenceInDay > 0) {
    differenceToPrint = differenceInDay;
    unit = "day";
  } else if (differenceInHours > 0) {
    differenceToPrint = differenceInHours;
    unit = "hour";
  } else {
    differenceToPrint = differenceInMinutes;
    unit = "minute";
  }
  if (differenceToPrint > 1) unit = "${unit}s";
  return "$differenceToPrint $unit";
}

ImageProvider eventImageProvider(String imagePath) {
  File imageFile = File(imagePath);
  if (imageFile.existsSync()) return FileImage(imageFile);
  return AssetImage('images/image-not-found.jpg');
}

Future<String> saveImage(String initialImagePath) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  File file = File(initialImagePath);
  Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
  Im.Image imageCompressed = Im.copyResize(imageFile, 1000);
  String resultPath = join(documentsDirectory.path, "img-${Uuid().v1()}");
  File(resultPath).writeAsBytesSync(Im.encodePng(imageCompressed));
  return resultPath;
}

deleteImage(String pathToDelete) async {
  Directory appDirectory = await getApplicationDocumentsDirectory();
  File imageFile = File(join(appDirectory.path, pathToDelete));
  imageFile.deleteSync();
}

Container buildEventLocation() {
  return Container(
      height: 150,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: FlutterMap(
            options: MapOptions(
              interactive: false,
              center: LatLng(48.8534, 2.3488),
              minZoom: 13.0,
              maxZoom: 13.0,
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(markers: <Marker>[
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: LatLng(48.8534, 2.3488),
                  builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 50.0,
                        ),
                      ),
                )
              ])
            ],
          )));
}
