//
//  FontPicker.swift
//  CardMaker
//
//  Created by wyw on 2022/6/23.
//

import SwiftUI

struct FontPicker: View {
    
    var title: String
    @Binding var selectedFont: String
    @Binding var fontSizeIndex: Int
    @State var showsPicker = false
    
    var body: some View {
        VStack {
            HStack {
                Text(selectedFont)
                    .font(.custom(selectedFont, size: 20))
                Button("change") {
                    showsPicker = true
                }
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.selection)
            }.padding(.top, 10)
            Picker("", selection: $fontSizeIndex) {
                Text("Smaller").tag(-1)
                Text("Default").tag(0)
                Text("Bigger").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
                .frame(width: 260)
        }
        .sheet(isPresented: $showsPicker) {
            FontPickerList(previewText: title, selectedFont: $selectedFont)
        }
        .padding(.horizontal)
    }
}

struct FontPickerList: View {
    
    var previewText: String
    @Binding var selectedFont: String
    @Environment(\.presentationMode) var presentationMode
    
    @State var favouriteFonts: [String]? = UserDefaults.standard.array(forKey: "_FAV_FONTS") as? [String]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                Color.clear.frame(height: 20)
                Section {
                    if let fav = favouriteFonts {
                        ForEach(fav.sorted()) {name in
                            Button(name) {
                                selectedFont = name
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.custom(name, size: 20))
                            .foregroundColor(.primary)
                            .padding(8)
                            .contextMenu {
                                Button {
                                    if favouriteFonts == nil {
                                        favouriteFonts = []
                                    }
                                    favouriteFonts!.removeAll(where: {$0 == name})
                                    UserDefaults.standard.set(favouriteFonts!, forKey: "_FAV_FONTS")
                                } label: {
                                    Label("Remove favourite", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                } header: {Label("Favourite", systemImage: "star")
                    .font(.system(size: 20))
                    .foregroundColor(.selection)
                    .frame(maxWidth: .infinity).padding(5)
                    .background(Color(UIColor.systemGray6))
                }// footer: {Divider()}
                Section {
                    Text("nil")
                } header: {Label("Featured", systemImage: "heart")
                    .font(.system(size: 20))
                    .foregroundColor(.selection)
                    .frame(maxWidth: .infinity).padding(5)
                    .background(Color(UIColor.systemGray6))
                }// footer: {Divider()}
                ForEach(UIFont.familyNames) {fname in
                    Section {
                        ForEach(UIFont.fontNames(forFamilyName: fname)) {name in
                            Button(name) {
                                selectedFont = name
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.custom(name, size: 20))
                            .foregroundColor(.primary)
                            .padding(8)
                            .contextMenu {
                                Button {
                                    if favouriteFonts == nil {
                                        favouriteFonts = []
                                    }
                                    guard favouriteFonts!.firstIndex(of: name) == nil else {return}
                                    favouriteFonts!.append(name)
                                    UserDefaults.standard.set(favouriteFonts!, forKey: "_FAV_FONTS")
                                } label: {
                                    Label("Favourite", systemImage: "star.fill")
                                }
                            }
                        }
                    } header: {
                        Text(fname).font(.system(size: 20))
                            .foregroundColor(.selection)
                            .frame(maxWidth: .infinity).padding(5)
                            .background(Color(UIColor.systemGray6))
                    }// footer: {Divider()}
                }
            }
        }
    }
}

extension String: Identifiable {
    public var id: String {self}
}

struct FontPicker_Previews: PreviewProvider {
    static var previews: some View {
        FontPicker(title: "title preview", selectedFont: .constant("MarkerFelt-Thin"), fontSizeIndex: .constant(0), showsPicker: true)
    }
}
