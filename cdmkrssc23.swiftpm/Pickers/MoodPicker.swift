//  MoodPicker.swift

import SwiftUI

struct MoodPicker: View {
    
    @Binding var mood: String
    
    let moods: [String] = ["🫥", "😆", "😌", "🥰", "😕", "😠", "😢", "🤕"]
    
    var body: some View {
        HStack {
            ForEach(0..<moods.count, id: \.self) { index in
                let dotColor = mood != moods[index]
                ? Color.clear : Color(UIColor.systemGray5) //Color.selection
                makeColorButton(index, dotColor: dotColor)
            }
        }
    }
    
    @ViewBuilder func makeColorButton(_ index: Int, dotColor: Color) -> some View {
        Button {mood = moods[index]
        } label: {
            ZStack {
                Circle().fill(dotColor).scaleEffect(1.2)
                Text(moods[index]).font(.system(size: 36))
                //Circle().stroke(dotColor, lineWidth: 4).scaleEffect(1.1)
            }.frame(width: 36, height: 36)
        }
    }
}

struct MoodPicker_Previews: PreviewProvider {
    static var previews: some View {
        MoodPicker(mood: .constant("🫥"))
    }
}
