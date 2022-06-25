//
//  Styles.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

struct CalendarCellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {Circle().fill(Color.gray).opacity(configuration.isPressed ? 0.2 : 0.08)}
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.linear(duration: 0.06), value: configuration.isPressed)
    }
}

struct PreviewOpButtonStyle: ButtonStyle {
    let bgColor: Color
    var fontSize: CGFloat = 30
    var paddingSize: CGFloat = 18
    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label
            .font(.system(size: fontSize, weight: .semibold, design: .rounded))
            .foregroundColor(bgColor)
            .padding(paddingSize)
            .background(
                Circle().fill(.background)
                    .shadow(radius: pressed ? 2 : 4, y: pressed ? 1 : 3)
            )
            .scaleEffect(pressed ? 0.96 : 1)
            .animation(.linear(duration: 0.06), value: configuration.isPressed)
    }
}

struct CapsuleOpButtonStyle: ButtonStyle {
    let bgColor: Color
    var fontSize: CGFloat = 30
    var paddingSize: CGFloat = 18
    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label
            .font(.system(size: fontSize, weight: .semibold, design: .rounded))
            .foregroundColor(bgColor)
            .padding(paddingSize)
            .background(
                Capsule().fill(.background)
                    .shadow(radius: pressed ? 2 : 4, y: pressed ? 1 : 3)
            )
            .scaleEffect(pressed ? 0.96 : 1)
            .animation(.linear(duration: 0.06), value: configuration.isPressed)
    }
}

struct PrefsCapsuleButtonStyle: ButtonStyle {
    var bgColor: Color = .selection
    var fontSize: CGFloat = 20
    var paddingSize: CGFloat = 16
    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label.frame(maxWidth: .infinity)
            .font(.system(size: fontSize, weight: .semibold, design: .rounded))
            .foregroundColor(bgColor)
            .padding(paddingSize)
            .background(
                Capsule().fill(.background)
                    .shadow(radius: pressed ? 2 : 4, y: pressed ? 1 : 3)
            )
            .scaleEffect(pressed ? 0.96 : 1)
            .animation(.linear(duration: 0.06), value: configuration.isPressed)
    }
}

struct EditSelectionBtnStyle: ButtonStyle {
    var selected: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(configuration.isPressed || selected ? UIColor.systemBackground : UIColor.systemGray6))
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}

struct StarBtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct Btn_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("text")
        }
        .buttonStyle(PrefsCapsuleButtonStyle(bgColor: .gray))
    }
}

extension Color {
    static let background = Color(UIColor.systemBackground)
    static let selection = Color("SelectionPrimary")
}

let cardPreviewTransition: Animation = .interactiveSpring(response: 0.3)
