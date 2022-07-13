//
//  CardPreview.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

struct CardPreview: View {
    
    @Binding var dateSelection: Int
    @Binding var cardDataList: [Int]
    @Binding var previewImg: UIImage?
    @Binding var artworkDesign: CardDesign?
    @State var mainSide: Bool = true
    @State var mainSideRotation: Bool = true
    
    @State var openEditor: Bool = false
    @State var delAlert: Bool = false
    @State var sharingOutput: Bool = false
    @State var imgSaved: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var artIsEmpty: Bool {
        previewImg == nil
    }
    
    var isPresented: Bool {
        dateSelection > 0
    }
    
    func quitAction() {
        if previewImg != nil && cardDataList.firstIndex(of: dateSelection) == nil {
            cardDataList.append(dateSelection)
        }
        dateSelection = 0
        imgSaved = false
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea().onTapGesture {
                quitAction()
            }
            .opacity(isPresented ? 1 : 0)
            .animation(cardPreviewTransition, value: isPresented)
            
            VStack(spacing: 20) {
                HStack {
                    Button {
                        delAlert = true
                    } label: {Image(systemName: "trash")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: .red, colorScheme: colorScheme))
                        .opacity(artIsEmpty ? 0 : 1)
                    Spacer()
                    Button {
                        openEditor = true
                    } label: {Image(systemName: "highlighter")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: .selection, colorScheme: colorScheme))
                }
                .opacity(isPresented ? 1 : 0)
                .offset(y: isPresented ? 0 : -200)
                .animation(cardPreviewTransition, value: isPresented)
                
                GeometryReader { geo in
                    ZStack {
                        autoBGColor
                        if mainSide {
                            if let artwork = previewImg {
                                Image(uiImage: artwork)
                                    .resizable().scaledToFill()
                                    .onDrag {
                                        NSItemProvider(contentsOf: URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/\(dateSelection)/\(dateSelection).jpg"))!
                                    }
                            } else {
                                Text("Card of The Day")
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        } else { //dark side
                            VStack {
                                Text((artworkDesign ?? .empty).mood).font(.system(size: 150))
                                
                            }
                        }
                    }
                    .frame(width: 500, height: 750)
                    .scaleEffect(geo.size.width / 500, anchor: .topLeading)
                }
                .aspectRatio(2 / 3, contentMode: .fit)//.padding(colorScheme == .dark ? 2 : 0)
                .background(autoBGColor.shadow(radius: 8, y: 5))
                .rotation3DEffect(Angle(degrees: mainSideRotation ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    mainSideRotation.toggle()}
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in mainSide.toggle()}
                }
                .rotation3DEffect(Angle(degrees: isPresented ? 0 : -15), axis: (-1,1,1))
                .scaleEffect(isPresented ? 1 : 0.7)
                .opacity(isPresented ? 1 : 0)
                .animation(cardPreviewTransition, value: isPresented)
                .scaleEffect(openEditor ? 1.2 : 1)
                .offset(y: openEditor ? UIScreen.main.bounds.height : 0)
                .animation(cardPreviewTransition, value: openEditor)
                
                HStack {
                    Button {
                        quitAction()
                    } label: {Image(systemName: "xmark")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: .secondary, colorScheme: colorScheme))
                    Spacer()
                    Button {
                        UIImageWriteToSavedPhotosAlbum(previewImg!, nil, nil, nil)
                        imgSaved = true
                        haptic.impactOccurred()
                    } label: {Image(systemName: imgSaved ? "checkmark" : "square.and.arrow.down")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: imgSaved ? .gray : .selection, colorScheme: colorScheme))
                        .opacity(artIsEmpty ? 0 : 1)
                        .disabled(imgSaved)
                    Spacer()
                    Button {
                        sharingOutput = true
                    } label: {Image(systemName: "square.and.arrow.up")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: .selection, colorScheme: colorScheme))
                        .opacity(artIsEmpty ? 0 : 1)
                }
                .opacity(isPresented ? 1 : 0)
                .offset(y: isPresented ? 0 : 200)
                .animation(cardPreviewTransition, value: isPresented)
            }.padding(40)
        }
        .fullScreenCover(isPresented: $openEditor, onDismiss: {}) {
            EditorView(
                dateInt: dateSelection, previewImg: $previewImg,
                bgColor: ColorPicker.colors[(artworkDesign ?? .empty).bgColorId / 8][(artworkDesign ?? .empty).bgColorId % 8],
                mood: (artworkDesign ?? .empty).mood,
                feelSelf: (artworkDesign ?? .empty).feelSelf,
                feelWorld: (artworkDesign ?? .empty).feelWorld,
                p_img_pos: (artworkDesign ?? .empty).imgStyle,
                s_img: (artworkDesign ?? .empty).imgStyle,
                artworkImg: UIImage(contentsOfFile: "\(NSHomeDirectory())/Documents/\(dateSelection)/\(dateSelection)_source.jpg") ?? UIImage(named: "img_placeholder")!,
                show_year_label: (artworkDesign ?? .empty).showYear,
                p_year_label: (artworkDesign ?? .empty).yearBottom ? 0 : 1,
                titleContent: (artworkDesign ?? .empty).title,
                c_title: ColorPicker.colors[(artworkDesign ?? .empty).titleColorId / 8][(artworkDesign ?? .empty).titleColorId % 8],
                c_date: ColorPicker.colors[(artworkDesign ?? .empty).dateColorId / 8][(artworkDesign ?? .empty).dateColorId % 8],
                o_date: (artworkDesign ?? .empty).dateOpacityId,
                show_month: (artworkDesign ?? .empty).dateStyle,
                p_date: (artworkDesign ?? .empty).datePosition,
                fontName: (artworkDesign ?? .empty).titleFontName,
                fontSizeIndex: (artworkDesign ?? .empty).titleSizeId
            )
        }
        .confirmationDialog("confirm delete", isPresented: $delAlert) {
            Button("Delete this card", role: .destructive) {
                cardDataList.removeAll(where: {$0 == dateSelection})
                artworkDesign = nil
                previewImg = nil
                try? FileManager.default.removeItem(atPath: "\(NSHomeDirectory())/Documents/\(dateSelection)/")
                dateSelection = 0
            }
        } message: {
            Text("Deleted cards cannot be recovered.")
        }
        .shareSheet(isPresented: $sharingOutput, items: [URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/\(dateSelection)/\(dateSelection).jpg")])
    }
    
    @ViewBuilder var autoBGColor: some View {
        if colorScheme == .light {
            Color.white
        } else {
            Color(UIColor.systemGray6)
        }
    }
}

struct CardPreview_Previews: PreviewProvider {
    static var previews: some View {
        CardPreview(dateSelection: .constant(20220621), cardDataList: .constant([20220621]), previewImg: .constant(nil), artworkDesign: .constant(nil))
    }
}

//--- effects ---

//struct CardFlip: AnimatableModifier {
//    var angle: Double
//    var otherSide: () -> any View
//
//    init(isMainSide: Bool, @ViewBuilder otherSide: @escaping () -> any View) {
//        angle = isMainSide ? 0 : 180
//        self.otherSide = otherSide
//    }
//
//    func body(content: Content) -> some View {
//        //
//    }
//}
