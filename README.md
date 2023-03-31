# SafeLine
Google Solutions Challenge 2023, Columbia Univeristy. <br>
SafeLine is a mobile application targetting <strong>UN Goal 11: Sustainable Cities and Communities</strong>

## Local Installation
This application uses the Google Maps API. You must create your own Google Maps API Key, and pass it into a **.env** file.
```bash
cd safeLine/
touch .env

# inside .env
GMAP_API_KEY=YOUR_API_KEY
```
Please refer to this YouTube video for more details on how to set up your .env file: [video tutorial](https://www.youtube.com/watch?v=LnZyorDeLmQ) //
Might need to run the following commands for app icons initialization: [video tutorial](https://www.youtube.com/watch?v=eMHbgIgJyUQ)
```bash
cd safeLine/
flutter pub get
flutter pub run flutter_launcher_icons:main
```

### Troubleshooting
Sometimes there might be issues with CococaPods that require you to reinstall the Pods inside the ***safeLine/ios*** directory.
In that case run following commands inside your command line prompt
```bash
cd safeLine/ios
rm -rf Pods
rm Podfile.lock
pod install --repo-update

cd ..
flutter clean
flutter pub get
flutter run
```

## Project Structure
```bash
.
├── LICENSE
├── README.md
├── analysis_options.yaml
├── android
├── build
├── ios
├── lib
│   ├── base.dart
│   ├── firebase_options.dart
│   ├── main.dart
│   ├── models
│   ├── viewModels
│   └── views
├── linux
├── macos
├── media
├── pubspec.lock
├── pubspec.yaml
├── safe_line.iml
├── test
├── web
└── windows
```

## Potentials
* https://pub.dev/packages/google_static_maps_controller
