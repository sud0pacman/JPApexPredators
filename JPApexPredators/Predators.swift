//
//  Predators.swift
//  JPApexPredators
//

import Foundation
import SwiftUI
import Combine 

class Predators: ObservableObject {
    var allApexPredators: [ApexPredator] = []
    @Published var apexPredators: [ApexPredator] = []

    init() {
        decodeApexPredatorData()
    }

    func decodeApexPredatorData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                allApexPredators = try decoder.decode([ApexPredator].self, from: data)
                apexPredators = allApexPredators
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }

    func applyFilters(type: APType, alphabetical: Bool, searchText: String) {
        var result = type == .all ? allApexPredators : allApexPredators.filter { $0.type == type }

        result.sort { alphabetical ? $0.name < $1.name : $0.id < $1.id }

        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        apexPredators = result
    }

    func delete(at offsets: IndexSet, type: APType, alphabetical: Bool, searchText: String) {
        let toDelete = offsets.map { apexPredators[$0] }
        for predator in toDelete {
            allApexPredators.removeAll { $0.id == predator.id }
        }
        apexPredators.remove(atOffsets: offsets)
    }
}
