import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daedalus/models/facility_model.dart';

class FacilityPage extends StatelessWidget {

  const FacilityPage({Key? key, required this.facility}) : super(key: key);

  final Facility facility;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 24.0,
          icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
        title: Text(
            facility.siteName,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.black87,
            )
        ),
      ),
      body: const Center(child: Text("Information about facility")),
    );
  }
}