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
    
    @State var showsAlert = false
    
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
        return min(streak, 26)
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
                    .font(numFont).foregroundColor(streakDays < 26 ? .selection : .orange)
                    .onTapGesture {
                        if streakDays > 25 {
                            showsAlert = true
                        }
                    }
                Text("Streaks")
                    .font(labelFont).foregroundColor(.gray)
            }.frame(width: itemWidth)
            VStack {
                Text("\(dataList.filter({Int($0 / 10000) == Calendar.current.dateComponents(in: .current, from: .now).year!}).count)")
                    .font(numFont).foregroundColor(.selection)
                Text("Annual")
                    .font(labelFont).foregroundColor(.gray)
            }.frame(width: itemWidth)
        }
        .alert("Wow", isPresented: $showsAlert, actions: {
            Button("Dismiss") {}
        }, message: {Text("You have >= 26 entries this month.")})
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView(dataList: [1,4,5,7,8,9,20220618])
    }
}
