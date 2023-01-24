class LocationModel {
  double latitude;
  double longitude;
  String nomeMarcador;

  LocationModel({
    required this.nomeMarcador,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> newLocation = {};
    newLocation["nomeMarcador"] = nomeMarcador;
    newLocation["latitude"] = latitude;
    newLocation["longitude"] = longitude;
    return newLocation;
  }

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        nomeMarcador: json["nomeMarcador"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}
