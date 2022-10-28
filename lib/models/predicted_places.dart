class PredictedPlace {
  String? place_id;
  String? display_place;
  String? display_address;

  PredictedPlace({this.place_id, this.display_place, this.display_address});

  PredictedPlace.fromJson(Map<String, dynamic> jsonData) {
    place_id = jsonData['place_id'];
    display_place = jsonData['display/-place'];
    display_address = jsonData['display_address'];
  }
}
