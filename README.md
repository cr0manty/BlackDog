# Black Dog

## Setup
 * install flutter SDK
 * run `flutter pub get` to get dependencies
 * iOS
    * add `GoogleService-Info.plist` file from Firebase to `ios/Runner` dir
    * add Google Maps API Key to `ios/Runner/Config.swift` file with name `GoogleMapsApiVariable`
 * Android
    * add `google-services.json` file from Firebase to `android/app/` dir
    * add Google Maps API Key to `android/local.properties` file with name `api.googleMapsApiKey`
    * add signing info to to `android/local.properties` file
    
 * run `flutter run` to start app
