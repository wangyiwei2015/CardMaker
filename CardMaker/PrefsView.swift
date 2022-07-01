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
    
    @Environment(\.colorScheme) var colorScheme
    
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
                        bgColor: .gray, fontSize: 24, paddingSize: 10, colorScheme: colorScheme
                    ))
                }
            }.padding().background(Color.background)
            ScrollView(.vertical) {
                VStack {
                    Button {
                        //
                    } label: {
                        Label("Rate or Review", systemImage: "star.fill")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle())
                    .padding(.horizontal, 40).padding(.top)
                    Button {
                        //
                    } label: {
                        Label("View on GitHub", systemImage: "swift")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle())
                    .padding(.horizontal, 40).padding(.top)
                    Button {
                        //
                    } label: {
                        Label("Contact by email", systemImage: "envelope.fill")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle())
                    .padding(.horizontal, 40).padding(.top)
                    Button {
                        //
                    } label: {
                        Label("Export all data", systemImage: "shippingbox.fill")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle())
                    .padding(.horizontal, 40).padding(.top)
                    
                    Text("or access raw data with iTunes").foregroundColor(.gray)
                    Text("// Stat overview content").padding()
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
