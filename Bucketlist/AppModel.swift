//
//  ContentView-ViewModel.swift
//  Bucketlist
//
//  Created by Paul Hudson on 10/12/2021.
//

import Foundation
import LocalAuthentication
import MapKit

var initFocus =  MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
//var initLoc = CLLocationCoordinate2D(latitude: 40.630, longitude: -73.921) // Flatland
var initLoc = CLLocationCoordinate2D(latitude: 40.693, longitude: -73.987) // Brooklyn ITP

//extension ContentView {
@MainActor
class AppModel: ObservableObject {
    
    @Published var mapRegion = MKCoordinateRegion(center: initLoc, span: initFocus)
    @Published private(set) var locations: [Location]
    @Published var selectedPlace: Location?
    
    @Published var isUnlocked = false
    @Published var authenticationError = "Unknown error"
    @Published var isShowingAuthenticationError = false
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces.json")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            locations = try JSONDecoder().decode([Location].self, from: data)
        } catch {
            locations = []
        }
        // locations = []
        if let last = locations.last {
            mapRegion = MKCoordinateRegion(center: last.coordinate,
                                           span: initFocus)
        }
        
        print("AppModel savePath", savePath)
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(locations)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func addLocation() {
        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
        locations.append(newLocation)
        save()
    }
    
    func update(location: Location) {
        guard let selectedPlace = selectedPlace else { return }
        
        if let index = locations.firstIndex(of: selectedPlace) {
            locations[index] = location
            save()
        }
    }
    
    func removeLocation(at offsets: IndexSet) {
        print("removeLocation at", offsets)
        locations.remove(atOffsets: offsets)
        save()
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                Task { @MainActor in
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.authenticationError = "There was a problem authenticating you; please try again."
                        self.isShowingAuthenticationError = true
                    }
                }
            }
        } else {
            authenticationError = "Sorry, your device does not support biometric authentication."
            isShowingAuthenticationError = true
        }
    }
}
//}
