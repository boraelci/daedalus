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
            margin: new EdgeInsets.only(left: 30, right: 30),
            child:  TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                ),
            onPressed: () {},
            child: const Text('https://www.usar.army.mil/USARSafety/'),
              ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                ),
            onPressed: () {},
            child: const Text('https://xtranet/usarc/safety/default.aspx'),
            ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                ),
            onPressed: () {},
            child: const Text('https://safety.army.mil/ON-DUTY/Workplace/OSHA-Corner'),
              ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                ),
            onPressed: () {},
            child: const Text('https://phc.amedd.army.mil/topics/workplacehealth/ih/Pages/default.aspx'),
              ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                ),
            onPressed: () {},
            child: const Text('https://www.osha.gov/toxic-metals'),
              ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                ),
            onPressed: () {},
            child: const Text('https://www.cdc.gov/niosh/topics/default.html'),
              ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                ),
            onPressed: () {},
            child: const Text('https://www.epa.gov/lead/learn-about-lead'),
              ),
          ),
        ],
      ),
    );
  }
}


