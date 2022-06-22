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
    
    var body: some View {
        ZStack {
            CardCalendarView(selection: $dateSelection)
            prefsBtn
            CardPreview(dateSelection: $dateSelection)
        }
    }
    
    @ViewBuilder var prefsBtn: some View {
        HStack {
            Spacer()
            VStack {
                Button {showsPrefs = true
                } label: {Image(systemName: "gearshape")
                }.buttonStyle(PreviewOpButtonStyle(
                    bgColor: .gray, fontSize: 24, paddingSize: 10
                )).padding(.trailing)
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
