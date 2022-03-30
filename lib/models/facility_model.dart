class Facility {

  Facility({
    required this.facid,
    required this.siteName,
    required this.lat,
    required this.long,
    required this.city,
    required this.state,
    required this.leadSeverity,
  });

  final String facid;
  final String siteName;
  final double lat;
  final double long;
  final String city;
  final String state;
  final int leadSeverity;

  Facility.fromJson(Map<String, dynamic> json)
      : facid = json['facid'],
        siteName = json['siteName'],
        lat = double.parse(json["lat"]!),
        long = double.parse(json["long"]!),
        city = json["city"],
        state = json["state"],
        leadSeverity = int.parse(json["leadSeverity"]!);
}