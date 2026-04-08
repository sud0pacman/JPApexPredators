//
//  Predators.swift
//  JPApexPredators
//

import Foundation
import Combine
import SwiftUI

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
    
    func search(for searchTerm: String) -> [ApexPredator] {
        if searchTerm.isEmpty {
            return apexPredators
        } else {
            return apexPredators.filter { predator in
                predator.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func sort(by alphabetical: Bool) {
        apexPredators.sort { predator1, predator2 in
            if alphabetical {
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
    }
    
    func filter(by type: APType) {
        if type == .all {
            apexPredators = allApexPredators
        } else {
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        }
    }
    
    func delete(_ predator: ApexPredator) {
        allApexPredators.removeAll { $0.id == predator.id }
        apexPredators.removeAll { $0.id == predator.id }
    }

    func delete(at offsets: IndexSet, searchText: String, currentSelection: APType, alphabetical: Bool) {
        // filteredPredators bilan bir xil logika
        let filtered = currentSelection == .all
            ? apexPredators
            : apexPredators.filter { $0.type == currentSelection }
        
        let sorted = filtered.sorted { p1, p2 in
            alphabetical ? p1.name < p2.name : p1.id < p2.id
        }
        
        let currentList = searchText.isEmpty
            ? sorted
            : sorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        for index in offsets {
            delete(currentList[index])
        }
    }
    
    func sortAndFilter(_ stringArray: [String]) -> [String] {
        let result = stringArray.filter { str in
            !str.starts(with: ["a", "e", "i", "o", "u"])
        }
        return result.sorted(by: >)
    }
    
    func applyFilters(type: APType, alphabetical: Bool, searchText: String) {
        let byType = type == .all ? allApexPredators : allApexPredators.filter { $0.type == type }
        
        let sorted = byType.sorted { p1, p2 in
            alphabetical ? p1.name < p2.name : p1.id < p2.id
        }
        
        if searchText.isEmpty {
            apexPredators = sorted
        } else {
            apexPredators = sorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func delete(at offsets: IndexSet) {
        let toDelete = offsets.map { apexPredators[$0] }
        for predator in toDelete {
            allApexPredators.removeAll { $0.id == predator.id }
        }
        apexPredators.remove(atOffsets: offsets)
    }
}
