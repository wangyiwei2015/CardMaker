//
//  EditorView.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

struct EditorView: View {
    
    let dateInt: Int
    
    @Binding var previewImg: UIImage?
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
    
    @State var titleContent: String = NSLocalizedString("_TAP_TO_EDIT", comment: "")
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
    
    @State var fontName: String = "PingFangSC-Regular"
    @State var fontSizeIndex: Int = 0
    
    enum EditingComponents: Int {
    case none, background, image, title, date
    }
    
    var body: some View {
        ZStack {
            VStack {
                topBar
                card.padding([.horizontal, .bottom])
                Spacer()
                ZStack {
                    Color.background
                    Text("No editor").foregroundColor(.secondary)
                }.frame(height: editing == .none ? 80 : 200)
            }.ignoresSafeArea(.keyboard)
            VStack {
                Spacer()
                propertyEditor.frame(height: 200)
                    .offset(y: editing == .none ? 250 : 0)
                    .animation(.easeOut(duration: 0.1), value: editing)
            }
        }
        .confirmationDialog("Exit without saving?", isPresented: $showsExitAlert) {
            Button("Discard changes and exit", role: .destructive) {
                if !FileManager.default.fileExists(atPath: "\(NSHomeDirectory())/Documents/\(dateInt)/\(dateInt)_cfg") {
                    try? FileManager.default.removeItem(atPath: "\(NSHomeDirectory())/Documents/\(dateInt)")
                }
                mode.wrappedValue.dismiss()
            }
        } message: {
            Text("Exit without saving?")
        }
        .onAppear {
//            if let savedImg = UIImage(contentsOfFile: "\(NSHomeDirectory())/Documents/\(dateInt)/\(dateInt)_source.jpg") {
//                artworkImg = savedImg
//            }
            print(NSHomeDirectory())
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
            } label: {Text("Presets").foregroundColor(.secondary)//.selection)
            }.hidden()
            Spacer()
            Button {
                let output = fullSizeCard.snapshot()
                let design = CardDesign(
                    date: dateInt, title: titleContent, titleSizeId: fontSizeIndex, titleFontName: fontName,
                    titleColorId: idOfColor(c_title), bgColorId: idOfColor(bgColor),
                    mood: mood, feelSelf: feelSelf, feelWorld: feelWorld,
                    imgStyle: p_img_pos, dateStyle: show_month, dateOpacityId: o_date,
                    dateColorId: idOfColor(c_date), datePosition: p_date,
                    showYear: show_year_label, yearBottom: p_year_label == 0)
                CardData.shared.saveData(design, designDate: dateInt, output: output)
                previewImg = output
                mode.wrappedValue.dismiss()
            } label: {Text("Save").foregroundColor(.secondary)
            }
        }
        .font(.system(size: 24, weight: .semibold, design: .rounded))
        .padding(.horizontal).padding(.top, 10)
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(dateInt: 20220621, previewImg: .constant(nil), editing: .title)
    }
}
