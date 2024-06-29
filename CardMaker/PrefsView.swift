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
    
    @State var showsAppearancePrefs = false
    @State var showsWidgetPrefs = false
    
    @AppStorage("_IMG_QUALITY") var importedImgQuality: Double = 1.0
    
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
                    
                    Group {
                        Button {
                            showsAppearancePrefs = true
                        } label: {
                            Label("Appearance", systemImage: "paintbrush.fill")
                                .shadow(radius: 0.5, y: 0.5)
                        }
                        .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                        .padding(.horizontal, 40).padding(.top)
                        
                        Button {
                            showsWidgetPrefs = true
                        } label: {
                            Label("Widgets", systemImage: "square.3.layers.3d.down.left")
                                .shadow(radius: 0.5, y: 0.5)
                        }
                        .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                        .padding(.horizontal, 40).padding(.top)
                        
                        ShareLink(item: URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/", isDirectory: true)) {
                            Label("Export all data", systemImage: "shippingbox.fill")
                                .shadow(radius: 0.5, y: 0.5)
                        }
                        .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                        .padding(.horizontal, 40).padding(.top)
                        Text("(or access raw data with iTunes)").foregroundColor(.gray)
                    }

                    Button {
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/cn/app/calendar-card-maker/id1631577584")!)
                    } label: {
                        Label("Rate or Review", systemImage: "star.fill")
                            .shadow(radius: 0.5, y: 0.5)
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                    .padding(.horizontal, 40).padding(.top)
                    Button {
                        UIApplication.shared.open(URL(string: "https://github.com/wangyiwei2015/CardMaker")!)
                    } label: {
                        Label("View on GitHub", systemImage: "swift")
                            .shadow(radius: 0.5, y: 0.5)
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                    .padding(.horizontal, 40).padding(.top)
                    Button {
                        UIApplication.shared.open(URL(string: "mailto:wangyw.dev@outlook.com?subject=CardMaker-Feedback&body=v\(version),(\(build))")!)
                    } label: {
                        Label("Contact by email", systemImage: "envelope.fill")
                            .shadow(radius: 0.5, y: 0.5)
                    }
                    .buttonStyle(PrefsCapsuleButtonStyle(colorScheme: colorScheme))
                    .padding(.horizontal, 40).padding(.top)
                    
                    HStack {
                        Text("v\(version) (\(build))")
                        Image(systemName: "swift").offset(y: -1)
                        Text("SwiftUI")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray).padding(.vertical)
                    
                    HStack(alignment: .center) {
                        Text("IN MEMORY OF")
                        Image("riqianlogo").resizable()
                            .scaledToFit().frame(height: 24)
                        Text("RI-QIAN")
                        // https://www.ifanr.com/app/764929
                        // ID: 1140397151
                    }
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray)
                }
            }
        }
        .sheet(isPresented: $showsAppearancePrefs) {
            VStack {
                ZStack {
                    Text("Appearance")
                        .font(.title).bold().foregroundColor(.gray)
                    HStack {
                        Spacer()
                        Button { showsAppearancePrefs = false
                        } label: {
                            Image(systemName: "xmark")
                        }.buttonStyle(PreviewOpButtonStyle(
                            bgColor: .gray, fontSize: 24, paddingSize: 10, colorScheme: colorScheme
                        ))
                    }
                }.padding(16).background(Color(UIColor.systemGray6))
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Label("Quality of imported photo", systemImage: "tray.and.arrow.down")
                            .font(.title3).bold()
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Button { importedImgQuality = 1.0
                        } label: {
                            Image(systemName: importedImgQuality == 1.0 ? "circle.fill" : "circle.dotted")
                        }.buttonStyle(PreviewOpButtonStyle(
                            bgColor: .selection, fontSize: 24, paddingSize: 10, colorScheme: colorScheme
                        ))
                        Text("High").font(.title3)
                        Spacer()
                        
                        Button { importedImgQuality = 0.75
                        } label: {
                            Image(systemName: importedImgQuality == 0.75 ? "circle.fill" : "circle.dotted")
                        }.buttonStyle(PreviewOpButtonStyle(
                            bgColor: .selection, fontSize: 24, paddingSize: 10, colorScheme: colorScheme
                        ))
                        Text("Med").font(.title3)
                        Spacer()
                        
                        Button { importedImgQuality = 0.5
                        } label: {
                            Image(systemName: importedImgQuality == 0.5 ? "circle.fill" : "circle.dotted")
                        }.buttonStyle(PreviewOpButtonStyle(
                            bgColor: .selection, fontSize: 24, paddingSize: 10, colorScheme: colorScheme
                        ))
                        Text("Low").font(.title3)
                    }.padding(.horizontal, 30)
                    
                    HStack {
                        Label("Using custom font", systemImage: "character.book.closed")
                            .font(.title3).bold()
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Text("_Custom_font_instr")
                            .padding(.horizontal)
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $showsWidgetPrefs) {
            Text("Developing :D\n下次一定~").multilineTextAlignment(.center)
        }
    }
}

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView(showsAppearancePrefs: true)
    }
}
