//
//  ContentView.swift
//  JPApexPredators
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var predators = Predators() 

    @State var searchText: String = ""
    @State var alphabetical: Bool = false
    @State var currentSelection = APType.all

    var body: some View {
        NavigationStack {
            List {
                ForEach(predators.apexPredators) { predator in
                    NavigationLink {
                        PredatorDetail(predator: predator, position: .camera(MapCamera(
                            centerCoordinate: predator.location,
                            distance: 30000
                        )))
                    } label: {
                        HStack {
                            Image(predator.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .shadow(color: .white, radius: 1)

                            VStack(alignment: .leading) {
                                Text(predator.name)
                                    .fontWeight(.bold)

                                Text(predator.type.rawValue.capitalized)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 13)
                                    .padding(.vertical, 5)
                                    .background(predator.type.background)
                                    .clipShape(.capsule)
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    predators.delete(at: offsets, type: currentSelection, alphabetical: alphabetical, searchText: searchText)
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(.default, value: predators.apexPredators.map { $0.id })
            .onAppear {
                predators.applyFilters(type: currentSelection, alphabetical: alphabetical, searchText: searchText)
            }
            .onChange(of: searchText) {
                predators.applyFilters(type: currentSelection, alphabetical: alphabetical, searchText: searchText)
            }
            .onChange(of: currentSelection) {
                predators.applyFilters(type: currentSelection, alphabetical: alphabetical, searchText: searchText)
            }
            .onChange(of: alphabetical) {
                predators.applyFilters(type: currentSelection, alphabetical: alphabetical, searchText: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            alphabetical.toggle()
                        }
                    } label: {
                        Image(systemName: alphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: alphabetical)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $currentSelection.animation()) {
                            ForEach(APType.allCases) { type in
                                Label(type.rawValue.capitalized, systemImage: type.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
