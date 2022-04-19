import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart'
;
class SafetyLinks extends StatelessWidget {
  const SafetyLinks({
    Key? key,
  }) : super(key: key);

  void _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  /*
  Widget _buildPlaceholderTile() => const SizedBox(
      height: 50,
      child: ListTile(
          selectedColor: Colors.black,
          horizontalTitleGap: 12,
          contentPadding: EdgeInsets.symmetric(horizontal: 25),
          leading: Icon(Icons.photo_rounded, size: 50),
          title: PlaceholderLines(count: 1, animate: true),
          subtitle: PlaceholderLines(count: 1, animate: true),
          trailing: FaIcon(FontAwesomeIcons.chevronRight, color: Colors.grey, size: 20)));

  Widget _buildPlaceholderList() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            indent: 20,
            endIndent: 20,
            thickness: 1,
          );
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildPlaceholderTile();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      backgroundColor: Colors.white.withOpacity(0.5),
      body: _buildPlaceholderList(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                _launchURL('https://www.usar.army.mil/USARSafety/');
              },
              child: const Text('USARC Safety Public Site'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                _launchURL('https://xtranet/usarc/safety/default.aspx');
              },
              child: const Text('USARC Safety Xtranet Site'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                _launchURL('https://safety.army.mil/ON-DUTY/Workplace/OSHA-Corner');
              },
              child: const Text(
                  'USARC Workplace Safety Site'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                _launchURL('https://phc.amedd.army.mil/topics/workplacehealth/ih/Pages/default.aspx');
              },
              child: const Text(
                  'APHC Industrial Hygiene Site'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                _launchURL('https://www.osha.gov/toxic-metals');
              },
              child: const Text('OSHA Heavy Metals Site'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                _launchURL('https://www.cdc.gov/niosh/topics/default.html');
              },
              child:
                  const Text('NIOSH Workplace Topics Site'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                _launchURL('https://www.epa.gov/lead/learn-about-lead');
              },
              child: const Text('EPA Lead Site'),
            ),
          ),
        ],
      );
  }
}
