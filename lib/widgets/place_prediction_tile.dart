import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/app_info/app_info.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/api_key.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/models/predicted_places.dart';

class PlacePredictionTile extends StatelessWidget {
  final PredictedPlace? predictedPlace;
  PlacePredictionTile({this.predictedPlace});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.white24),
      onPressed: () async {
        String fetchAddressUrl =
            "https://us1.locationiq.com/v1/reverse?key=${mapRequestKey}&lat=${predictedPlace!.latitude}&lon=${predictedPlace!.latitude}&format=json";
        final predictedPlaceAddress =
            await RequestAssistant.recieveRequest(fetchAddressUrl);
        Provider.of<AppInfo>(context, listen: false).updateDropOffAddress(
          Address(
            humanReadableAddress: predictedPlaceAddress['display_name'],
            locationId: predictedPlaceAddress['place_id'],
            locationLatitude: predictedPlace!.latitude,
            locationLongitude: predictedPlace!.longitude,
            locationName: predictedPlaceAddress['display_name'],
          ),
        );
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.add_location),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      predictedPlace!.display_place.toString(),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    predictedPlace!.display_address.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
