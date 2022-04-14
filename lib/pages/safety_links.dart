import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SafetyLinks extends StatelessWidget {

  const SafetyLinks({Key? key, }) : super(key: key);

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
        title: const Text(
            'USARC Safety Links',
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
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
            child:  const Center(child: Text(
               'To be implemented...'
              )
            )
          ),
          // Container(
          //   margin: new EdgeInsets.only(bottom: 20.0),
          //   child:  Center(child: Text(
          //      '${facility.city}, ${facility.state}'
          //     )
          //   )
          // ),
          // Container(
          //   margin: new EdgeInsets.symmetric(horizontal: 30.0),
          //   child:  Center(child: Text(
          //     '${facility.siteName} is ${facility.leadSeverity < 3 ? "within" : "above"} permissible limits. ${facilityTexts[facility.leadSeverity]}')
          //   )
          // ),
          // Container(
          //   margin: new EdgeInsets.symmetric(horizontal: 30.0),
          //   child:  Center(child: TextButton(
          //   style: ButtonStyle(
          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
          //   ),
          //   onPressed: () {
          //      Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => AboutPage()),
          //     );
          //   },
          //   child: const Text('View Facility Safety Links'),
          // ),
          //   )
          // )
        ],
      ),
    );
  }
}


