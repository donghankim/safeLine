# SafeLine
Google Solutions Challenge 2023, Columbia Univeristy. <br>
SafeLine is a mobile application targetting <strong>UN Goal 11: Sustainable Cities and Communities</strong>

## Installation
You need to have firebase-cli, firebase-auth, and firebase-tools installed in order to build this application. Not sure if this works but try it out first:
```bash
# install all flutter dependencies
cd safeLine/
flutter pub get
```
If that doesnt work, refer to the official [firebase website](https://firebase.google.com/docs/cli#macos) for installation information.

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
The only folder you should be looking at is the <strong>lib/</strong> folder. All development code is organized inside lib. Within lib, there are three additional folders following the MVVC software design pattern. Moreover, please follow the following Flutter coding conventions:
* class names are <strong>UpperCamelCase</strong>
* file names are <strong>snake_case</strong>
* tabs are set to 2 spaces

It might be better to use VSCode with the flutter extension enabled (easier to code in my opinion).

## TODO:
* something



