//
//  FiveStarRater.swift
//  CardMaker
//
//  Created by wyw on 2022/6/23.
//

import SwiftUI

struct FiveStarRater: View {
    
    @Binding var starCount: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...5, id: \.self) { star in
                Button {starCount = star
                } label: {
                    Image(systemName: starCount >= star ? "star.fill" : "star")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundColor(.orange)
                }.buttonStyle(StarBtnStyle())
            }
        }
    }
}

struct FiveStarRater_Previews: PreviewProvider {
    static var previews: some View {
        FiveStarRater(starCount: .constant(4))
    }
}
