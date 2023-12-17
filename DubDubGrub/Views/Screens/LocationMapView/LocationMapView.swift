//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Adrian Somor on 23/09/2023.
//

import CoreLocationUI
import SwiftUI
import MapKit

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var viewModel = LocationMapViewModel()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
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
            .tint(.grubRed)
            .ignoresSafeArea()
            
            LogoView(frameWidth: 125).shadow(radius: 10)

        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationStack {
                viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: dynamicTypeSize)
                    .toolbar {
                        Button("Dismiss", action: {
                            viewModel.isShowingDetailView = false
                        })
                    }
            }
        }
        .overlay(alignment: .bottomLeading, content: {
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.grubRed)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        })
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .task {
            if locationManager.locations.isEmpty { viewModel.getLocations(for: locationManager) }
            viewModel.getCheckedInCount()
        }
    }
}

#Preview {
    LocationMapView()
        .environmentObject(LocationManager())
}
