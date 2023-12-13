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
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: viewModel.createLocationDetailView(for: location, in: sizeCategory)) {
                        LocationCell(location: location,
                                     profiles: viewModel.checkedInProfiles[location.id, default: []])
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
                    }
                }
            }
            .onAppear {
                viewModel.getCheckedInProfilesDictionary()
            }
            .alert(item: $viewModel.alertItem, content: { $0.alert })
            .navigationTitle("Grub Spots")
        }
    }
}


#Preview {
    LocationListView()
}


