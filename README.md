# USARC Safety Project Daedalus README

App Name: USARC Safety <br />
Tagline: Industrial Hygiene & Safety Info <br />

Frontend app: https://github.com/boraelci/daedalus <br />
Backend api: https://github.com/boraelci/daedalus-api

## Flutter Installation and Package Dependencies
Follow the link to install flutter: https://docs.flutter.dev/get-started/install

To confirm that installation is correct, run “flutter doctor” on the command line. To confirm that package dependencies are correct, run “flutter pub get” on the command line in the project’s directory. The current version of flutter in our project is 1.0.0+1 .

## Running the App
To run the app, run main.dart located in daedalus/lib/

The purpose of main.dart is to set up the permissions and skeleton of the app. It initializes three pages: the map page which it defaults to when opening the app, the search page, and the about page. These pages are navigable through the bottom navigation bar.

First, the app queries the database for facility information. This requires the user to have internet access, which it uses to send an API request to the backend that returns the list of facilities and their current status as a JSON object. This JSON object is then decoded, and returned to main. If there is no internet connection available, then the app responds with an error code informing the user internet access is required for the app to function.

The app requests for location and notification permissions. If permissions are allowed, they persist through time and stay on. If location permissions are not granted, the map will not focus on the user’s location. If notification permissions are not granted, geolocation notifications will not work.

After all this, the application generates the HTML structure of the homepage, and stores the facility data for the current session temporarily until the app is terminated. The data is stored in a variable and you do not need an internet connection to view the data. But if your current session is terminated by closing the application you must connect to the internet to fetch the data. As an aside, if the app is never terminated, the app will be able to function without the internet.



## Facility Model
All facility data follows a model located in daedalus/lib/models/facility_model.dart; each facility contains the following information in order:

- Facility ID: Number, unseen to the user
- Site Name: String
- Latitude Coordinates: String
- Longitude Coordinates: String
- Street Name: String
- City Name: String
- State Name: String
- Zip Code: String
- Full Address: String
- Installation Name: String
- Lead Severity Level: Number

Each facility needs to have this information to be stored on the database; the application will never be given a facility with no zip code, for instance.

## App Pages
The app’s pages are all located within daedalus/lib/pages, and they are what the user sees on their phone while using the app. There are five main pages:



- Accessible from menu at the bottom of the main page
  * **Map Page** is the page that concerns the openstreetmaps API, and generates the touchscreen map users interact with to find particular sites. Openstreetmaps is used because it is a free, open-source API which minimizes cost. Users begin on this page, and can choose to navigate to other pages. If geolocation permissions are not granted, the map does not automatically center on the user.
  * **Search Page** is the page that allows users to search for a specific facility through the initialized facility data either with its site name or address. This is done using flutter’s search widget.
  * **About Page** contains the setting for the users to control notifications, information, additional USARC Safety Resources, the project’s story, and the MIT License.
- **Facility Page** is the page that is pulled from either a searched for facility or one that was selected from the map page. Data from the facility is pulled from the initialized facility data and displayed to the user. The facility page displays information in line with the different severity levels a facility may have.
- **Safety Links Page** features the same safety resource links present in one of the About Page tiles. It is accessible through any Facility Page.

## Notifications
Inside the utils/location_utils.dart file we ask users to enable location permissions and in main.dart enable push notifications. Once the user enables location settings to ‘while using the app’, the application asks the user to enable it to ‘always’ so that it can alert the user in the background while the application is terminated. We want to be able to alert the user if the user is in the vicinity of a facility and continue to push notifications if the user is moving. If the user does not select ‘always’, the app will still function, but notification alerts will not run in the background. At main.dart the initState( ) function calls the setupGeolocationAlerts( ) which utilizes the geofence library. We add a geolocation to the closest 10 facilities to the user by sorting them and specify a radius for the geofence (500 meters). This means that if the user is inside this circle he will be notified that he is close to a facility.

## Credits
Project Daedalus was developed by Team Daedalus, the members are: Bora Elci, David Cendejas, Jorge Mederos, and Kerim Kurttepeli. Special thanks to Wonny Kim, John Waldie and Khalil Jackson.

## License
MIT © 2022 Bora Elci, David Cendejas, Jorge Mederos, and Kerim Kurttepeli
