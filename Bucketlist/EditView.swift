//
//  EditView.swift
//  Bucketlist
//
//  Created by Paul Hudson on 09/12/2021.
//

import SwiftUI

struct EditView: View {
    
//    @StateObject private var locationModel: LocationModel
    @ObservedObject var locationModel: LocationModel
    var onSave: (Location) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $locationModel.name)
                    TextField("Description", text: $locationModel.description)
                }
                
                Section("Nearby…") {
                    switch locationModel.loadingState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                        NearbyView(locationModel: locationModel)
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = locationModel.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await locationModel.fetchNearbyPlaces()
            }
        }
    }
    
//    init(location: Location, onSave: @escaping (Location) -> Void) {
//        self.onSave = onSave
//        _locationModel = StateObject(wrappedValue: LocationModel(location: location))
//    }
}

struct NearbyView: View {
    var locationModel: LocationModel
    var body: some View {
        ForEach(locationModel.pages, id: \.pageid) { page in
            Group {
                Text(page.title)
                    .font(.headline)
                + Text(": ")
                + Text(page.description)
                    .italic()
            }
            .onTapGesture {
                locationModel.name = page.title
                locationModel.description = page.description
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        // EditView(location: Location.example) { _ in }
        EditView(locationModel: LocationModel(location: Location.example)) { _ in }
    }
}
