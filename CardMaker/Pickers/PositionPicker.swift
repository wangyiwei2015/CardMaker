//
//  PositionPicker.swift
//  CardMaker
//
//  Created by wyw on 2022/6/23.
//

import SwiftUI

struct PositionPicker: View {
    
    @Binding var position: Int
    
    let deactiveColor = Color(UIColor.systemGray5)
    let shadowRadius: CGFloat = 3
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {position = 1
                    } label: {
                        Rectangle().fill(position == 1 ? Color.selection : deactiveColor)
                            .shadow(radius: shadowRadius)
                            .overlay {Text("↖")}
                    }.buttonStyle(StarBtnStyle())
                    Button {position = 2
                    } label: {
                        Rectangle().fill(position == 2 ? Color.selection : deactiveColor)
                            .shadow(radius: shadowRadius)
                            .overlay {Text("↗")}
                    }.buttonStyle(StarBtnStyle())
                }
                HStack {
                    Button {position = 3
                    } label: {
                        Rectangle().fill(position == 3 ? Color.selection : deactiveColor)
                            .shadow(radius: shadowRadius)
                            .overlay {Text("↙")}
                    }.buttonStyle(StarBtnStyle())
                    Button {position = 4
                    } label: {
                        Rectangle().fill(position == 4 ? Color.selection : deactiveColor)
                            .shadow(radius: shadowRadius)
                            .overlay {Text("↘")}
                    }.buttonStyle(StarBtnStyle())
                }
            }.frame(width: 240, height: 100)
            Button {position = 0
            } label: {
                Capsule().fill(position == 0 ? Color.selection : deactiveColor)
                    .shadow(radius: shadowRadius)
                    .overlay {Text("●")}
            }.buttonStyle(StarBtnStyle()).frame(width: 100, height: 64)
        }
    }
}

struct PositionPicker_Previews: PreviewProvider {
    static var previews: some View {
        PositionPicker(position: .constant(1))
    }
}
