import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daedalus/models/facility_model.dart';
import 'package:daedalus/data/facility_data.dart';
import 'package:daedalus/pages/safety_links.dart';
import 'package:intl/intl.dart';

class FacilityPage extends StatelessWidget {

  const FacilityPage({Key? key, required this.facility}) : super(key: key);

  final Facility facility;

  @override
  Widget build(BuildContext context) {    
    final now = DateTime.now();
    String formatter = DateFormat('yMd').format(now); //Change to Last Date Tested
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
      body: ListView(
        children: <Widget>[
          Container(
            // height: 50,
            margin: new EdgeInsets.only(top: 20.0),
            child:  Center(child: Text(
               'Facility ID: ${facility.facid}'
              )
            )
          ),
          Container(
            margin: new EdgeInsets.only(left: 30.0, right: 30.0,),
            child:  Center(child: Text(
               '${facility.street}, ${facility.city}, ${facility.state}, ${facility.zip}'
              )
            )
          ),
          Container(
            // margin: new EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
            child:  Center(child: IconButton(
                iconSize: 45,
                icon: facility.leadSeverity < 3
                    ? const FaIcon(FontAwesomeIcons.circleCheck,
                    color: Colors.green)
                    : const FaIcon(FontAwesomeIcons.circleExclamation,
                    color: Colors.amber),
                onPressed: null
              ),
            )
          ),
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30.0),
            child:  Center(child: Text(
              '${facility.siteName} is ${facility.leadSeverity < 3 ? "within" : "above"} permissible limits. ${facilityTexts[facility.leadSeverity]}')
            )
          ),
          Container(
            margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child:  Center(child: Text(
              'Last tested on: ${formatter}', //<- current date atm, add proper last date
              //style: TextStyle(color: facility.leadSeverity < 3 ? Colors.black : Colors.red)
              ),
            )
          ),
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 30.0),
            child:  Center(child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
            ),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SafetyLinks()),
              );
            },
            child: const Text('View Additional Safety Resources'),
          ),
            )
          )
        ],
      ),
    );
  }
}