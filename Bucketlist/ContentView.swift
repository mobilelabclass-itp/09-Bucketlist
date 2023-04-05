//
//  ContentView.swift
//  Bucketlist
//
//  Created by Paul Hudson on 08/12/2021.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var appModel: AppModel
    
//    @State private var selection: Location?

    var body: some View {
        
        let _ = Self._printChanges()
        
        // if viewModel.isUnlocked {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $appModel.mapRegion, annotationItems: appModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            appModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            LocationListView(selection: $appModel.selectedPlace )
                        } label: {
                            Text("List")
                                .font(.title)
                        }
                        
                        Button {
                            appModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $appModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    appModel.update(location: newLocation)
                }
            }
        }
        //        } else {
        //            Button("Unlock Places") {
        //                appModel.authenticate()
        //            }
        //            .padding()
        //            .background(.blue)
        //            .foregroundColor(.white)
        //            .clipShape(Capsule())
        //            .alert("Authentication error", isPresented: $appModel.isShowingAuthenticationError) {
        //                Button("OK") { }
        //            } message: {
        //                Text(appModel.authenticationError)
        //            }
        //        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject( AppModel() )
    }
}
