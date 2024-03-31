# [Bucketlist](https://github.com/molab-itp/09-Bucketlist)

- Users can add places to the map that they want to visit

- Saves data to local Documents folder as SavedPlaces JSON file

- Example of getting JSON from web api

- to show app data: in Windows | Devices... | download app container, show package contents

[] TODO: use current location -- use class LocationManager from 09-Location example


https://www.hackingwithswift.com/books/ios-swiftui/bucket-list-introduction


## Changes

- Removed authentication
- Rename file to AppModel.swift
- Added NavigationView
- focus on last location added
- zoom in to span: latitudeDelta: 0.001, longitudeDelta: 0.001
- locations view with edit
- rename to SavedPlaces.json
- Added View updates debug code
```
    let _ = Self._printChanges()
```
- Show edit sheet after adding a location

## Issues

[] Warning: "Publishing changes from within view updates is not allowed"


