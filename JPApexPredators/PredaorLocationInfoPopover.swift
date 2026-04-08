//
//  PopOverExampleView.swift
//  JPApexPredators
//
//  Created by G'aniyev Muhammad on 07/04/26.
//

import SwiftUI
import Foundation
import CoreLocation
import MapKit

enum InfoDialogActions: Identifiable, CaseIterable {
    case safari
    case plus
    case sharing
    
    var id: InfoDialogActions {
        self
    }
    
    var imageName: String {
        switch self {
        case .safari: return "safari"
        case .plus: return "plus.app"
        case .sharing: return "square.and.arrow.up"
        }
    }
}

struct PopoverExampleView: View {
    let predator: ApexPredator
    
    @State private var mapImage: UIImage? = nil
    @State private var directionMinute: Int = 0
    @State private var rating: Int = 0
    @State private var distanceMI: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text(predator.name)
                .font(.title)
                .bold()
            
            // Location
            HStack {
                Text("Park •")
                    .font(.body)
                
                Link(destination: URL(string: "http://maps.apple.com/?ll=\(predator.latitude),\(predator.longitude)")!) {
                    Text(predator.movieScenes[0].movie)
                        .foregroundStyle(.blue)
                }
            }
            
            // Actions
            HStack {
                ForEach(InfoDialogActions.allCases) { action in
                    Button {} label: {
                        Image(systemName: action.imageName)
                            .padding(.trailing, 10)
                    }
                }
            }
            .padding(.top, 1)
            
            // Direction & Route
            HStack {
                // Direction
                Button {} label: {
                    VStack {
                        Text("Direction")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "car.fill")
                            
                            Text("\(directionMinute) min")
                                .font(.headline)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.all, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
                }
                
                
                // Route
                Button {} label: {
                    VStack(alignment: .leading) {
                        Text("Create Route")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("from here")
                            .font(.headline)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white)
                    .padding(.all, 8)
                    .background(.gray.opacity(0.9))
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(.top, 10)
            
            // Divider
            Divider()
                .padding(.vertical)
            
            // Rating & Distance
            HStack {
                // Rating
                VStack(alignment: .leading) {
                    Text("1 RATING")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                    
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.headline)
                        
                        Text("\(rating)%")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.blue)
                }
                
                // Divider
                Divider()
                
                // Distance
                VStack(alignment: .leading) {
                    Text("DISTANCE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "scribble")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("\(distanceMI) mi")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            
            // Image
            Group {
                if let image = mapImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    GeometryReader { geometry in
                        let mySize = geometry.size.width
                        ProgressView()
                            .frame(width: mySize, height: mySize)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            generateSnapshot()
            generateRandom()
        }
    }
    
    func generateSnapshot() {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(
            center: predator.location,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        options.size = CGSize(width: 300, height: 300)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, _ in
            self.mapImage = snapshot?.image
        }
    }
    
    func generateRandom() {
        directionMinute = .random(in: 2..<1440)
        rating = .random(in: 10...100)
        distanceMI = .random(in: 1...100)
    }
}

#Preview {
    
    
    PopoverExampleView(
        predator: Predators().apexPredators[0]
    )
}

func fetchMapSnapshot(for coordinate: CLLocationCoordinate2D, completion: @escaping (UIImage?) -> Void) {
    let options = MKMapSnapshotter.Options()
    
    // Rasmning o'lchami va qamrab oladigan hududi
    options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
    options.size = CGSize(width: 300, height: 300) // O'zingizga kerakli o'lcham
    options.scale = UIScreen.main.scale
    
    let snapshotter = MKMapSnapshotter(options: options)
    
    snapshotter.start { snapshot, error in
        if let error = error {
            print("Xatolik yuz berdi: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        // snapshot?.image - bu siz qidirayotgan UIImage
        completion(snapshot?.image)
    }
}
