//
//  EditorView.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

struct EditorView: View {
    
    let dateInt: Int
    
    @Environment(\.presentationMode) var mode
    @State var showsExitAlert: Bool = false
    
    @State var editing: EditingComponents = .none
    
    @State var bgColor: Color = .white
    @State var mood: String = "🫥"
    @State var feelSelf: Int = 0
    @State var feelWorld: Int = 0
    
    @State var p_img_pos: Int = 0 // small, large, half, full
    let p_img_width: [CGFloat] = [400, 450, 500, 500]
    let p_img_height: [CGFloat] = [400, 700, 500, 750]
    let p_img_yoffset: [CGFloat] = [-125, 0, -125, 0]
    @State var s_img: Int = 0
    let imgShadow: [CGFloat] = [0, 4, 10, 16]
    @State var artworkImg: UIImage = UIImage(named: "img_placeholder")!
    
    @State var show_year_label: Bool = false
    @State var p_year_label: Int = 0 // bottom, top (if shown)
    let p_year_y: [CGFloat] = [350, -350]
    
    @State var titleContent: String = "Tap to edit"
    @State var c_title: Color = .gray
    let p_title_y: [CGFloat] = [200, 310, 220, 290] // index is p_img_pos
    let padding_title: [CGFloat] = [36, 30, 20, 20]
    
    @State var c_date: Color = .white
    @State var o_date: Int = 2
    let dateLabelOpacity: [CGFloat] = [0.3, 0.5, 0.8, 1.0]
    @State var show_month: Int = 0 // MM/dd, dd, hidden
    @State var p_date: Int = 0 // center, TL, TR, BL, BR
    let p_date_x: [[[CGFloat]]] = [
        [[0, -120, 120, -120, 120], [0, -140, 140, -140, 140], [0, -150, 150, -150, 150], [0, -150, 150, -150, 150]], // MM/dd
        [[0, -158, 158, -158, 158], [0, -180, 180, -180, 180], [0, -200, 200, -200, 200], [0, -200, 200, -200, 200]], // dd
        [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
    ]
    let p_date_y: [[[CGFloat]]] = [
        [[-125, -290, -290, 40, 40], [0, -310, -310, -310, -310], [-125, -320, -320, 80, 80], [0, -320, -320, 200, 200]], // MM/dd
        [[-125, -290, -290, 40, 40], [0, -310, -310, -310, -310], [-125, -320, -320, 80, 80], [0, -320, -320, 200, 200]], // dd
        [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
    ]
    
    enum EditingComponents: Int {
    case none, background, image, title, date
    }
    
    var body: some View {
        ZStack {
            VStack {
                topBar
//                Divider()
//                Text("Editing: title text")
//                    .bold().foregroundColor(.gray)
//                    .padding(10)
                card.padding([.horizontal, .bottom])
                ZStack {
                    Color.background
                    Text("No editor").foregroundColor(.secondary)
                }.frame(height: 200)
            }.ignoresSafeArea(.keyboard)
            VStack {
                Spacer()
                propertyEditor.frame(height: 200)
                    .offset(y: editing == .none ? 250 : 0)
                    .animation(.easeOut(duration: 0.1), value: editing)
            }
        }
        .confirmationDialog("Exit without saving?", isPresented: $showsExitAlert) {
            Button("Discard changes and exit") {mode.wrappedValue.dismiss()}
        } message: {
            Text("Exit without saving?")
        }
    }
    
    @ViewBuilder var topBar: some View {
        HStack {
            Button {showsExitAlert = true
            } label: {Text("Exit").foregroundColor(.secondary)
            }
            Spacer()
            Button {
                //
            } label: {Text("Presets").foregroundColor(.selection)
            }
            Spacer()
            Button {
                let output = fullSizeCard.snapshot() // FIXME: not self
                UIImageWriteToSavedPhotosAlbum(output, nil, nil, nil)
            } label: {Text("Save").foregroundColor(.secondary)
            }
        }
        .font(.system(size: 24, weight: .semibold, design: .rounded))
        .padding(.horizontal).padding(.top, 10)
    }
    
    @ViewBuilder var userImage: some View {
        Image(uiImage: artworkImg).resizable().scaledToFill()
            .frame(width: p_img_width[p_img_pos], height: p_img_height[p_img_pos], alignment: .center)
            .clipped().offset(y: p_img_yoffset[p_img_pos])
            .shadow(radius: imgShadow[s_img])
    }
    
    @ViewBuilder var yearLabel: some View {
        Text(String(format: "%d", dateInt / 10000))
            .font(.system(size: 26, weight: .bold, design: .rounded))
            .foregroundColor(.gray)
            .offset(y: p_year_y[p_year_label])
            .opacity(show_year_label ? 1 : 0)
    }
    
    @ViewBuilder var titleText: some View {
        Text(titleContent)
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundColor(c_title)
            .padding(.horizontal, padding_title[p_img_pos])
            .offset(y: p_title_y[p_img_pos])
    }
    
    @ViewBuilder var dateText: some View {
        Text(show_month == 0
             ? String(format: "%0.2d/%0.2d", (dateInt % 10000) / 100, dateInt % 100)
             : String(format: "%0.2d", dateInt % 100))
        .font(.system(size: 40, weight: .semibold, design: .monospaced))
        .foregroundColor(c_date)
        .opacity(dateLabelOpacity[o_date])
        .offset(x: p_date_x[show_month][p_img_pos][p_date], y: p_date_y[show_month][p_img_pos][p_date])
        .opacity(show_month < 2 ? 1 : 0)
    }
    
    @ViewBuilder var fullSizeCard: some View {
        ZStack {
            //ZStack {
                //sth
                //Rectangle().stroke(Color.selection, lineWidth: 4)//.scaleEffect(1.05)
            //}
            bgColor.onTapGesture {editing = .background}
            userImage.onTapGesture {editing = .image}
            titleText.onTapGesture {editing = .title}
            dateText.onTapGesture {editing = .date}
            yearLabel.onTapGesture {editing = .date}
        }.frame(width: 500, height: 750)
    }
    
    @ViewBuilder var card: some View {
        GeometryReader { geo in
            fullSizeCard
            .scaleEffect(geo.size.width / 500, anchor: .topLeading)
        }
        .aspectRatio(2 / 3, contentMode: .fit)
        .background(Color.background.shadow(radius: 5, y: 3))
    }
    
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
            }.buttonStyle(PreviewOpButtonStyle(bgColor: .gray, fontSize: 18, paddingSize: 6))
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
        ImagePicker(image: $artworkImg)
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

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(dateInt: 20220621, editing: .image)
    }
}
