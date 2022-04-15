class Facility {

  Facility({
    required this.facid,
    required this.siteName,
    required this.lat,
    required this.long,
    required this.address,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.leadSeverity,
  });

  final String facid;
  final String siteName;
  final double lat;
  final double long;
  final String address;
  final String street;
  final String city;
  final String state;
  final String zip;
  final int leadSeverity;

  Facility.fromJson(Map<String, dynamic> json)
      : facid = json['facid'],
        siteName = json['siteName'],
        lat = double.parse(json["lat"]!),
        long = double.parse(json["long"]!),
        address = json["address"],
        street = json["street"],
        city = json["city"],
        state = json["state"],
        zip = json["zip"],
        leadSeverity = int.parse(json["leadSeverity"]!);
}