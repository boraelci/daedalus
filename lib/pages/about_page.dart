import 'package:daedalus/pages/safety_links.dart';
import 'package:flutter/material.dart';
import 'package:daedalus/utils/view_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  List<bool> isExpanded = [false, false, false, false];
  final notificationsIndex = 0;
  final aboutIndex = 1;
  final resourcesIndex = 2;
  final licenseIndex = 3;

  var defaultColor = Colors.white;
  var expandedColor = Colors.white;
  var textColor = Colors.black;

  double selectedFrequency = 1;
  List<String> frequencies = ["Weekly", "Daily", "Anytime"];
  List<int> frequenciesInMinutes = [10080, 1440, 0];
  String aboutText = "This application was developed in the Hacking 4 Defense course at Columbia University, facilitated by the National Security Innovation Network, sponsored by the Office of the Chief of Army Reserve, the Safety Directorate for US Army Reserve Command, and with support from the 75th Innovation Command.";
  String licenseText = "This application is distributed under the terms of The MIT License (MIT).\n\nCopyright (c) 2022 Bora Elci, David Cendejas, Jorge Mederos, Kerim Kurttepeli\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";

  @override
  @override
  void initState() {
    super.initState();
  }

  void setNotificationFrequency (index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('notificationFrequency', frequenciesInMinutes[index]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: HexColor("#676d42"),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: ExpansionPanelList(
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15.0, right:0.0, top: 10.0,  bottom: 5.0),
                    child: ListTile(
                      leading: Icon(Icons.notifications_active_rounded, size:30, color: Colors.grey),
                      horizontalTitleGap: 12.0,
                      title: Text("Notification Settings", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                  );
                },
                body: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0, bottom: 25.0),
                    child:
                      Slider(
                      value: selectedFrequency,
                      min: 0,
                      max: 2,
                      divisions: 2,
                      label: frequencies[selectedFrequency.round()],
                      onChanged: (double value) {
                        setNotificationFrequency(value.toInt());
                        setState(() {
                          selectedFrequency = value;
                        });
                      },
                    ),
                ),
                isExpanded: isExpanded[notificationsIndex],
                backgroundColor: isExpanded[notificationsIndex] ? expandedColor : defaultColor,
              ),
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15.0, right:0.0, top: 10.0,  bottom: 5.0),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.mobileScreenButton, size:30, color: Colors.grey),
                      horizontalTitleGap: 12.0,
                      title: Text("About the app", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0, bottom: 25.0),
                    child:
                      Text(
                        aboutText,
                        style: const TextStyle(
                          fontSize: 16.0,
                        fontWeight: FontWeight.w500
                      ),
                )
                ),
                isExpanded: isExpanded[aboutIndex],
                backgroundColor: isExpanded[aboutIndex] ? expandedColor : defaultColor,
              ),
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15.0, right:0.0, top: 10.0,  bottom: 5.0),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.listCheck, size:30, color: Colors.grey),
                      horizontalTitleGap: 12.0,
                      title: Text("USARC Safety Resources", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                  );
                },
                body: const Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0, bottom: 25.0),
                  child:
                  SafetyLinks(),
                ),
                isExpanded: isExpanded[resourcesIndex],
                backgroundColor: isExpanded[resourcesIndex] ? expandedColor : defaultColor,
              ),
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15.0, right:0.0, top: 10.0,  bottom: 5.0),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.copyright, size:30, color: Colors.grey),
                      horizontalTitleGap: 12.0,
                      title: Text("License and Copyright", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
                body: Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0, bottom: 25.0),
                    child:
                    Text(
                      licenseText,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: textColor
                      ),
                    )
                ),
                isExpanded: isExpanded[licenseIndex],
                backgroundColor: isExpanded[licenseIndex] ? expandedColor : defaultColor,
              ),
            ],
            expansionCallback: (int i, bool expanded) {
              setState(() {
                isExpanded[i] = !expanded;
              });
            },
          ),
        ));
  }
}
