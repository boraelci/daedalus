import 'package:flutter/material.dart';
import 'package:daedalus/models/facility_model.dart';

String safeText =
    "Lead presence is below the 2020 EPA limit for housing and child occupied facilities.\n\nVery low risk of transferring lead contamination away from the workplace.";
String lowText =
    "Lead presence is below the 2001 EPA limit for housing and child occupied facilities.\n\nWash hands and follow good personal hygiene habits following onsite activities. Low risk of transferring lead contamination away from the workplace.";
String mediumText =
    "Lead presence is below the OSHA limit for contaminated workplaces.\n\nWash hands and follow good personal hygiene habits following onsite activities. Follow all required housekeeping procedures and ensure break areas are clean and sanitary. Medium risk of transferring lead contamination away from the workplace.";
String highText =
    "Lead presence is above OSHA limit for maintaining a clean and sanitary break areas away from ongoing onsite activities.\n\nInquire with facility coordinator on measures to lower the risk of lead contamination. Follow all required housekeeping procedures. High risk of transferring lead contamination away from the workplace.";

List<String> facilityTexts = [safeText, lowText, mediumText, highText];
List<Color> facilityColors = [Colors.green, Colors.green, Colors.green, Colors.orange];