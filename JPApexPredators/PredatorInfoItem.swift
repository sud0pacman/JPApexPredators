//
//  PredatorInfoItem.swift
//  JPApexPredators
//
//  Created by G'aniyev Muhammad on 09/04/26.
//

import SwiftUI

struct PredatorInfoItem: View {
    let predator: ApexPredator
    
    var body: some View {
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

#Preview {
    PredatorInfoItem(
        predator: Predators().allApexPredators.first!
    )
}
