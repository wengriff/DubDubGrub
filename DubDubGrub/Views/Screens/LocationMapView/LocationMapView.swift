//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 23/09/2023.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack(alignment: .top) {
            //            Map(coordinateRegion: $viewModel.region)
            //                .ignoresSafeArea()
            Map(coordinateRegion: $viewModel.region, 
                showsUserLocation: true,
                annotationItems: locationManager.locations) { location in
                //                MapMarker(coordinate: location.location.coordinate, tint: .brandPrimary)
                MapAnnotation(coordinate: location.location.coordinate, 
                              anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    DDGAnnotation(location: location,
                                  number: viewModel.checkedInProfiles[location.id, default: 0])
                    .onTapGesture {
                        locationManager.selectedLocation = location
                        viewModel.isShowingDetailView = true
                    }
                }
            }
            .accentColor(.grubRed)
            .ignoresSafeArea()
            
            
            LogoView(frameWidth: 125).shadow(radius: 10)
            
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationView {
                viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: sizeCategory)
                    .toolbar {
                        Button("Dismiss", action: {
                            viewModel.isShowingDetailView = false
                        })
                    }
            }
            .accentColor(.brandPrimary)
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .onAppear {
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }
            viewModel.getCheckedInCount()
        }
    }
}

#Preview {
    LocationMapView()
        .environmentObject(LocationManager())
}
