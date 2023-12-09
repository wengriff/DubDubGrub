//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 23/09/2023.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    
    @StateObject private var viewModel = LocationListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))) {
                        LocationCell(location: location, 
                                     profiles: viewModel.checkedInProfiles[location.id, default: []])
                    }
                }
            }
            .onAppear {
                viewModel.getCheckedInProfilesDictionary()
            }
            .navigationTitle("Grub Spots")
        }
    }
}


#Preview {
    LocationListView()
}


