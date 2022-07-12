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
    @State var cardDataList: [Int] = CardData.shared.allDates
    
    @State var year: Int = Calendar.current.dateComponents([.year], from: Date()).year!
    @State var month: Int = Calendar.current.dateComponents([.month], from: Date()).month!
    
    @State var preview: UIImage? = nil
    @State var selectedArtwork: CardDesign? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Group {
                VStack {
                    topBar
                    CardCalendarView(
                        selection: $dateSelection,
                        cardDataList: $cardDataList,
                        year: $year, month: $month
                    ).drawingGroup()
                    Spacer()
                }
                VStack {
                    Spacer()
                    StatView(dataList: cardDataList)
                        .padding(.bottom, 40).drawingGroup()
                }
            }.blur(radius: (dateSelection > 0) || showsPrefs ? 6 : 0)
            CardPreview(
                dateSelection: $dateSelection, cardDataList: $cardDataList,
                previewImg: $preview, artworkDesign: $selectedArtwork
            )
        }
        .onChange(of: dateSelection) { _ in
            preview = CardData.shared.loadPreviews(dateSelection).first
            selectedArtwork = CardData.shared.loadData(dateSelection).first
        }
        .fullScreenCover(isPresented: $showsPrefs) {
            PrefsView()
        }
    }
    
    @ViewBuilder var topBar: some View {
        Group {
            ZStack {
                prefsBtn
                yearStepper
            }.drawingGroup()
            Picker("month", selection: $month) {
                ForEach(1...12, id: \.self) { id in
                    Text("\(id)")
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
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
                Button {withAnimation{showsPrefs = true}
                } label: {Image(systemName: "gearshape")
                }.buttonStyle(PreviewOpButtonStyle(
                    bgColor: .gray, fontSize: 21, paddingSize: 8, colorScheme: colorScheme
                )).padding(.trailing)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
