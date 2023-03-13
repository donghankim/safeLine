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
The only folder you should be looking at is the <strong>lib/</strong> folder. All development code is organized inside lib. Within lib, there are three additional folders following the MVVC software design pattern. Moreover, please follow the following Flutter coding conventions:
* class names are <strong>UpperCamelCase</strong>
* file names are <strong>snake_case</strong>
* tabs are set to 2 spaces

It might be better to use VSCode with the flutter extension enabled (easier to code in my opinion). The base.dart file contains the starter code provided by flutter if you need help. All front-end related code should go inside the views folder and business logic (backend)
code should go inside the viewModels folder (although currently empty). Don't worry too much about following convention, Ill try to edit your code when merging.

## TODO (for Sunday 19th):
* Alex: Subway maps + train tracking in real-time (UI included)
* Nathan: Leaderboard + UI 
* Donghan: Work on Incident reporting feature and merge any back-end code from Alex and Nathan
* Ellie: Basic UI design of the application, focusing more on a clean and user-friendly UI/UX (please keep the annimations to a low~)
* A-star search + Dijkstra's algorithm to find the best path avoiding stations with a lot of incidents (over-ambitious but doable)

