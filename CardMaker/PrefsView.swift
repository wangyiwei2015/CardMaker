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
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/cn/app/calendar-card-maker/id1631577584")!)
                    } label: {
                        Label("Rate or Review", systemImage: "star.fill")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                    .padding(.horizontal, 40).padding(.top)
                    Button {
                        UIApplication.shared.open(URL(string: "https://github.com/wangyiwei2015/CardMaker")!)
                    } label: {
                        Label("View on GitHub", systemImage: "swift")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                    .padding(.horizontal, 40).padding(.top)
                    Button {
                        UIApplication.shared.open(URL(string: "mailto:wangyw.dev@outlook.com?subject=CardMaker-Feedback&body=v\(version),(\(build))")!)
                    } label: {
                        Label("Contact by email", systemImage: "envelope.fill")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                    .padding(.horizontal, 40).padding(.top)
                    /*
                    Button {
                        //
                    } label: {
                        Label("Export all data", systemImage: "shippingbox.fill")
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                    .padding(.horizontal, 40).padding(.top)
                    Text("or access raw data with iTunes").foregroundColor(.gray)
                    */
                    
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
