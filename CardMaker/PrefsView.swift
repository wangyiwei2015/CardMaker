//
//  PrefsView.swift
//  CardMaker
//
//  Created by wyw on 2022/6/25.
//

import SwiftUI

struct PrefsView: View {
    
    @Environment(\.presentationMode) var mode
    
    let version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "?"
    let build: String = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "?"
    
    var body: some View {
        VStack {
            ZStack {
                Text("Preferences")
                    .font(.title).bold().foregroundColor(.gray)
                HStack {
                    Spacer()
                    Button {mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }.buttonStyle(PreviewOpButtonStyle(
                        bgColor: .gray, fontSize: 24, paddingSize: 10
                    ))
                }
            }.padding().background(Color.background)
            ScrollView(.vertical) {
                VStack {
                    Text("// Review link")
                    Text("// Source code link")
                    Text("// Contact email")
                    Text("// Get raw data: iTunes file sharing")
                    Text("// Import/export zip")
                    Text("// Stat overview content")
                    HStack {
                        Text("v\(version) (\(build))")
                        Image(systemName: "swift").offset(y: -1)
                        Text("SwiftUI")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray).padding(.vertical)
                }
            }
        }
    }
}

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView()
    }
}
