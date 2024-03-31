//
//  LocationListView.swift
//  Bucketlist
//
//  Created by jht2 on 4/5/23.
//

import SwiftUI

struct LocationListView: View {
    @Binding var selection: Location?

    @EnvironmentObject private var appModel: AppModel
    
    @Environment(\.editMode) private var editMode

    var body: some View {
        List {
            ForEach(appModel.locations) { location in
                Text(location.name)
                    .onTapGesture {
                        selection = location
                    }
            }
            .onDelete { (indices) in
                print("onDelete", indices)
                appModel.removeLocation(at: indices)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selection:Location? = Location.example
        LocationListView(selection: $selection)
            .environmentObject( AppModel() )
    }
}
