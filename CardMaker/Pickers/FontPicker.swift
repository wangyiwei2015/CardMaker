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
            }
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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                Section {
                    Text("nil")
                } header: {Label("Favourite", systemImage: "star")
                } footer: {Divider()
                }
                Section {
                    Text("nil")
                } header: {Label("Featured", systemImage: "heart")
                } footer: {Divider()
                }
                ForEach(UIFont.familyNames) {fname in
                    Section(fname) {
                        ForEach(UIFont.fontNames(forFamilyName: fname)) {name in
                            Button(name) {
                                selectedFont = name
                                presentationMode.wrappedValue.dismiss()
                            }.contextMenu {
                                Button {
                                    print(0)
                                } label: {
                                    Label("Favourite", systemImage: "star.fill")
                                }
                            }
                        }.background(Color(UIColor.systemGray6))
                    }
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
        FontPicker(title: "title preview", selectedFont: .constant("MarkerFelt-Thin"), fontSizeIndex: .constant(0))
    }
}
