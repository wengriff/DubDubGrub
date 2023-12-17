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
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)) {
                        LocationCell(location: location,
                                     profiles: viewModel.checkedInProfiles[location.id, default: []])
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
                    }
                }
            }
            .navigationTitle("Grub Spots")
            .listStyle(.plain)
            .onAppear {
                viewModel.getCheckedInProfilesDictionary()
            }
            .alert(item: $viewModel.alertItem, content: { $0.alert })
        }
    }
}


#Preview {
    LocationListView()
}


