class PredictedPlace {
  String? place_id;
  String? display_place;
  String? display_address;
  double? latitude;
  double? longitude;

  PredictedPlace(
      {this.place_id,
      this.display_place,
      this.display_address,
      this.latitude,
      this.longitude});

  PredictedPlace.fromJson(Map<String, dynamic> jsonData) {
    place_id = jsonData['place_id'];
    display_place = jsonData['display_place'];
    display_address = jsonData['display_address'];
    latitude = jsonData['lat'];
    longitude = jsonData['lon'];
  }
}
