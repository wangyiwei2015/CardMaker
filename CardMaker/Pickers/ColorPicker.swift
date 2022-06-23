//
//  ColorPicker.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

struct ColorPicker: View {
    
    @Binding var color: Color
    
    let colors: [[Color]] = [
        [.selection, Color("SelectionSecondary"), .white, Color(UIColor.systemGray5), Color(UIColor.systemGray3), Color(UIColor.systemGray2), .gray, .black],
        [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .brown],
    ]
    
    var body: some View {
        VStack {
            ForEach(0..<colors.count, id: \.self) { row in
                makeRow(row)
            }
        }
    }
    
    @ViewBuilder func makeRow(_ row: Int) -> some View {
        HStack {
            ForEach(0..<colors[row].count, id: \.self) { col in
                let dotColor = color != colors[row][col]
                    ? Color.clear
                    : (row == 0 && col == 2 ? Color.black : Color.white)
                makeColorButton(row, col, dotColor: dotColor)
            }
        }
    }
    
    @ViewBuilder func makeColorButton(_ row: Int, _ col: Int, dotColor: Color) -> some View {
        Button {color = colors[row][col]
        } label: {
            ZStack {
                Circle().fill(colors[row][col])
                    .shadow(color: .gray, radius: 3)
                Circle().fill(dotColor).padding(10)
            }.frame(width: 34, height: 34)
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(color: .constant(.red))
    }
}

func idOfColor(_ color: Color) -> Int {
    let colors: [[Color]] = [
        [.selection, Color("SelectionSecondary"), .white, Color(UIColor.systemGray5), Color(UIColor.systemGray3), Color(UIColor.systemGray2), .gray, .black],
        [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .brown],
    ]
    if let index = colors[0].firstIndex(of: color) {return index}
    else {return (colors[1].firstIndex(of: color) ?? -colors[0].count) + colors[0].count}
}
