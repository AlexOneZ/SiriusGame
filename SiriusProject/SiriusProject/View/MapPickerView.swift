//
//  MapPickerView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 03.04.2025.
//

import MapKit
import SwiftUI

struct MapAnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

import MapKit
import SwiftUI

struct MapPickerView: View {
    @State private var isSelected: Bool = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.4024966, longitude: 39.951579), // Адлер
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var onLocationSelected: (CLLocationCoordinate2D) -> Void

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: isSelected ? .pitch : .all)
                .edgesIgnoringSafeArea(.all)

            Text("📍")
                .font(.largeTitle)
                .foregroundColor(.red)
                .offset(y: -15)

            VStack {
                Spacer()
                HStack {
                    Button(isSelected ? "Изменить" : "Подтвердить") {
                        if isSelected {
                            isSelected.toggle()
                        } else {
                            onLocationSelected(region.center)
                            isSelected.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }
    }
}
