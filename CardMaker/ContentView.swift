//
//  ContentView.swift
//  CardMaker
//
//  Created by wyw on 2022/6/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var showsPrefs: Bool = false
    @State var dateSelection = 0
    @State var cardDataList: [Int] = {
        let files = try! FileManager.default.contentsOfDirectory(atPath: dataDir)
        return files.map({Int($0) ?? 0}).filter({$0 > 20000000})
    }()
    
    @State var year: Int = Calendar.current.dateComponents([.year], from: Date()).year!
    @State var month: Int = Calendar.current.dateComponents([.month], from: Date()).month!
    
    var body: some View {
        ZStack {
            VStack {
                Group {
                    ZStack {
                        prefsBtn
                        yearStepper
                    }
                    
                    Picker("month", selection: $month) {
                        ForEach(1...12, id: \.self) { id in
                            Text("\(id)")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }//.background(Color(UIColor.systemGray6))
                CardCalendarView(
                    selection: $dateSelection, cardDataList: $cardDataList,
                    year: $year, month: $month
                )
                Spacer()
            }
            CardPreview(dateSelection: $dateSelection)
        }
    }
    
    @ViewBuilder var yearStepper: some View {
        HStack {
            Button {year -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.gray)
            }
            Text(String(format: "%4d", year))
                .font(.system(size: 25, weight: .semibold, design: .monospaced))
                .padding(.horizontal)
            Button {year += 1
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.gray)
            }
        }.padding(10).padding(.horizontal)
        .background(Capsule().fill(Color(UIColor.systemGray6)))
    }
    
    @ViewBuilder var prefsBtn: some View {
        HStack {
            Button {
                year = Calendar.current.dateComponents([.year], from: Date()).year!
                month = Calendar.current.dateComponents([.month], from: Date()).month!
            } label: {
                Image(systemName: "record.circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.selection)
                    .opacity(
                        (year == Calendar.current.dateComponents([.year], from: Date()).year! &&
                        month == Calendar.current.dateComponents([.month], from: Date()).month!)
                        ? 0 : 1
                    )
                    .padding(.horizontal)
            }.padding()
            Spacer()
            VStack {
                Button {showsPrefs = true
                } label: {Image(systemName: "gearshape")
                }.buttonStyle(PreviewOpButtonStyle(
                    bgColor: .gray, fontSize: 24, paddingSize: 10
                )).padding(.trailing)
                //Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
