//
//  ApexPredator.swift
//  JPApexPredators
//
//  Created by G'aniyev Muhammad on 04/04/26.
//

import Foundation
import SwiftUI
import MapKit

struct ApexPredator: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: APType
    let latitude: Double
    let longitude: Double
    let movies: [String]
    let movieScenes: [MovieScence]
    let link: String
    
    var image: String {
        name.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    struct MovieScence: Decodable, Identifiable {
        let id: Int
        let movie: String
        let sceneDescription: String
    }
}

extension ApexPredator: Equatable {
    static func == (lhs: ApexPredator, rhs: ApexPredator) -> Bool {
        // Return true if you consider these two instances "equal"
        return lhs.id == rhs.id
    }
}


enum APType : String, Decodable, CaseIterable, Identifiable  {
    case all
    case land
    case air
    case sea
    
    var id: APType {
        self
    }
    
    var background: Color {
        switch self {
        case .land:
                .brown
        case .air:
                .teal
        case .sea:
                .blue
        case .all:
                .black
        }
    }
    
    var icon: String {
        switch self {
            case .all:
                "square.stack.3d.up.fill"
            case .land:
                "leaf.fill"
            case .air:
                "wind"
            case .sea:
                "drop.fill"
        }
    }
}
