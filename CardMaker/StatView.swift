//
//  StatView.swift
//  CardMaker
//
//  Created by wyw on 2022/6/25.
//

import SwiftUI

struct StatView: View {
    
    var dataList: [Int]
    
    let itemWidth: CGFloat = 100
    let numFont = Font.system(size: 36, weight: .bold, design: .rounded)
    let labelFont = Font.system(size: 20, weight: .semibold, design: .rounded)
    
    var streakDays: Int {
        guard dataList.count > 0 else {return 0}
        let sortedList = dataList.sorted()
        var last = sortedList.last!
        var streak = 1
        for i in (0..<sortedList.count-1).reversed() {
            last -= 1
            if sortedList[i] != last {
                break
            } else {
                streak += 1
            }
        }
        return streak
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("\(dataList.count)")
                    .font(numFont).foregroundColor(.selection)
                Text("Entries")
                    .font(labelFont).foregroundColor(.gray)
            }.frame(width: itemWidth)
            VStack {
                Text("\(streakDays)")
                    .font(numFont).foregroundColor(.selection)
                Text("Streaks")
                    .font(labelFont).foregroundColor(.gray)
            }.frame(width: itemWidth)
            VStack {
                Text("999")
                    .font(numFont).foregroundColor(.selection)
                Text("Ratings")
                    .font(labelFont).foregroundColor(.gray)
            }.frame(width: itemWidth)
        }
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView(dataList: [1,2,3,4,5,7,8,9])
    }
}
