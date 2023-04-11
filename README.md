# Bucketlist

- Users can add places to the map that they want to visit

- Saves data to local Documents folder as SavedPlaces JSON file

[] TODO: use current location


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

## Issues

[] Warning: Publishing changes from within view updates is not allowed


