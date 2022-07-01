//
//  EditorView+EditorUI.swift
//  CardMaker
//
//  Created by wyw on 2022/6/25.
//

import SwiftUI

extension EditorView {
    @ViewBuilder var propertyEditorTopBar: some View {
        HStack(spacing: 0) {
            Button {editing = .background
            } label: {Text("BG").bold()
            }.buttonStyle(EditSelectionBtnStyle(selected: editing == .background))
            Button {editing = .image
            } label: {Text("IMG").bold()
            }.buttonStyle(EditSelectionBtnStyle(selected: editing == .image))
            Button {editing = .title
            } label: {Text("TITLE").bold()
            }.buttonStyle(EditSelectionBtnStyle(selected: editing == .title))
            Button {editing = .date
            } label: {Text("DATE").bold()
            }.buttonStyle(EditSelectionBtnStyle(selected: editing == .date))
            Button {editing = .none
            } label: {Image(systemName: "xmark")
            }.buttonStyle(PreviewOpButtonStyle(bgColor: .gray, fontSize: 18, paddingSize: 6, colorScheme: .light))
                .padding(.horizontal, 10)
                .background(Color(UIColor.systemGray6).frame(height: 34))
        }
    }
    
    @ViewBuilder var backgroundEditor: some View {
        Text("Background color").bold().foregroundColor(.gray)
        ColorPicker(color: $bgColor).padding(.horizontal)
        Divider().padding()
        Text("Mood of the day").bold().foregroundColor(.gray)
        MoodPicker(mood: $mood)
        Divider().padding()
        Text("Your feel about yourself").bold().foregroundColor(.gray)
        FiveStarRater(starCount: $feelSelf)
            .padding(.bottom)
        Text("Your feel about the world").bold().foregroundColor(.gray)
        FiveStarRater(starCount: $feelWorld)
            .padding(.bottom)
    }
    
    @ViewBuilder var imageEditor: some View {
        Text("Image content").bold().foregroundColor(.gray)
        ImagePicker(image: $artworkImg, designDate: dateInt, cardDate: dateInt)
        Divider().padding()
        Text("Image style").bold().foregroundColor(.gray)
        HStack {
            Text("Style:").bold()
            Picker("Date label style", selection: $p_img_pos) {
                Text("Small").tag(0)
                Text("Large").tag(1)
                Text("Half").tag(2)
                Text("Full").tag(3)
            }.pickerStyle(SegmentedPickerStyle())
        }.padding(.horizontal)
        HStack {
            Text("Shadow:").bold()
            Picker("img shadow", selection: $s_img) {
                Text("None").tag(0)
                Text("1").tag(1)
                Text("2").tag(2)
                Text("3").tag(3)
            }.pickerStyle(SegmentedPickerStyle())
        }.padding([.horizontal, .bottom])
    }
    
    @ViewBuilder var titleEditor: some View {
        Text("Content").bold().foregroundColor(.gray)
        TextField(text: $titleContent) {
            Text("Tap to edit")
        }.frame(height: 50).padding(.horizontal).background(
            Color.background.shadow(radius: 2)
        ).padding(.horizontal)
        Divider().padding()
        Text("Font").bold().foregroundColor(.gray)
        FontPicker()
        Divider().padding()
        Text("Color").bold().foregroundColor(.gray)
        ColorPicker(color: $c_title).padding([.horizontal, .bottom])
    }
    
    @ViewBuilder var dateEditor_date: some View {
        Text("Date label style").bold().foregroundColor(.gray)
        HStack {
            Text("Format:").bold()
            Picker("Date label style", selection: $show_month) {
                Text("MM/dd").tag(0)
                Text("dd").tag(1)
                Text("Hidden").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
        }.padding(.horizontal)
        HStack {
            Text("Opacity:").bold()
            Picker("Date label style", selection: $o_date) {
                Text("Low").tag(0)
                Text("Med").tag(1)
                Text("High").tag(2)
                Text("Full").tag(3)
            }.pickerStyle(SegmentedPickerStyle())
        }.padding(.horizontal)
        Divider().padding()
        ColorPicker(color: $c_date)
        Divider().padding()
        Text("Date label position").bold().foregroundColor(.gray)
        PositionPicker(position: $p_date)
    }
    
    @ViewBuilder var dateEditor_year: some View {
        Divider().padding()
        Text("Year label style").bold().foregroundColor(.gray)
        Toggle("Show year label", isOn: $show_year_label)
            .tint(Color.selection).padding(.horizontal)
        if show_year_label {
            HStack {
                Text("Position:").bold()
                Picker("Year label pos", selection: $p_year_label) {
                    Text("Bottom").tag(0)
                    Text("Top").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
            }.padding(.horizontal)
        }
    }
    
    @ViewBuilder var propertyEditor: some View {
        ZStack {
            Color.background.shadow(radius: 3)
            VStack(spacing: 0) {
                propertyEditorTopBar.frame(height: 34)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        switch editing {
                        case .background:
                            backgroundEditor
                        case .image:
                            imageEditor
                        case .title:
                            titleEditor
                        case .date:
                            dateEditor_date
                            dateEditor_year.padding(.bottom)
                        default:
                            Spacer()
                        }
                    }.padding(.vertical)
                }
            }
        }
        .ignoresSafeArea(.container)
    }
}
