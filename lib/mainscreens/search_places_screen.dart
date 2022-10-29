import 'package:flutter/material.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/api_key.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/place_prediction_tile.dart';

class SearchPagesScreen extends StatefulWidget {
  const SearchPagesScreen({super.key});

  @override
  State<SearchPagesScreen> createState() => _SearchPagesScreenState();
}

class _SearchPagesScreenState extends State<SearchPagesScreen> {
  List<PredictedPlace> placePredictedList = [];
  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String autoCompleteUrl =
          "https://api.locationiq.com/v1/autocomplete?key=$mapRequestKey&q=$inputText";

      final response = await RequestAssistant.recieveRequest(autoCompleteUrl);
      if (response == "Failed") {
        print("Failed");
      } else {
        var placePredictionList =
            (response as List).map((e) => PredictedPlace.fromJson(e)).toList();
        setState(() {
          placePredictedList = placePredictionList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            color: Colors.black54,
            boxShadow: [
              BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Set dropoff location.",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          findPlaceAutoCompleteSearch(value);
                        },
                        decoration: const InputDecoration(
                            hintText: "Search for location"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        placePredictedList.length > 0
            ? Expanded(
                child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlacePredictionTile(
                        predictedPlace: placePredictedList[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                      );
                    },
                    itemCount: placePredictedList.length),
              )
            : Container(),
      ]),
    );
  }
}
