//
//  CardPreview.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

struct CardPreview: View {
    
    @Binding var dateSelection: Int
    @State var previewImg: UIImage? = nil
    @State var mainSide: Bool = true
    @State var mainSideRotation: Bool = true
    
    @State var openEditor: Bool = false
    
    var artIsEmpty: Bool {
        previewImg == nil
    }
    
    var isPresented: Bool {
        dateSelection > 0
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea().onTapGesture {
                dateSelection = 0
            }
            .opacity(isPresented ? 1 : 0)
            .animation(cardPreviewTransition, value: isPresented)
            
            VStack(spacing: 20) {
                HStack {
                    Button {
                        //
                    } label: {Image(systemName: "trash")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: .red))
                        .opacity(artIsEmpty ? 0 : 1)
                    Spacer()
                    Button {openEditor = true
                    } label: {Image(systemName: "highlighter")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: Color.selection))
                }
                .opacity(isPresented ? 1 : 0)
                .offset(y: isPresented ? 0 : -200)
                .animation(cardPreviewTransition, value: isPresented)
                
                GeometryReader { geo in
                    ZStack {
                        Color.background
                        if mainSide {
                            if let artwork = previewImg {
                                Image(uiImage: artwork)
                                    .resizable().scaledToFit()
                            } else {
                                Text("Create a card for today")
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        } else { //dark side
                            VStack {
                                Text("🫥").font(.system(size: 150))
                            }
                        }
                    }
                    .frame(width: 500, height: 750)
                    .scaleEffect(geo.size.width / 500, anchor: .topLeading)
                }
                .aspectRatio(2 / 3, contentMode: .fit)
                .background(Color.background.shadow(radius: 8, y: 5))
                .rotation3DEffect(Angle(degrees: mainSideRotation ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    mainSideRotation.toggle()}
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in mainSide.toggle()}
                }
                .scaleEffect(isPresented ? 1 : 0.9)
                .opacity(isPresented ? 1 : 0)
                .animation(cardPreviewTransition, value: isPresented)
                .offset(y: openEditor ? UIScreen.main.bounds.height : 0)
                .animation(cardPreviewTransition, value: openEditor)
                
                HStack {
                    Button {
                        dateSelection = 0
                    } label: {Image(systemName: "xmark")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: .secondary))
                    Spacer()
                    Button {
                        //
                    } label: {Image(systemName: "square.and.arrow.down")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: Color.selection))
                        .opacity(artIsEmpty ? 0 : 1)
                    Spacer()
                    Button {
                        //
                    } label: {Image(systemName: "square.and.arrow.up")
                    }.buttonStyle(PreviewOpButtonStyle(bgColor: Color.selection))
                        .opacity(artIsEmpty ? 0 : 1)
                }
                .opacity(isPresented ? 1 : 0)
                .offset(y: isPresented ? 0 : 200)
                .animation(cardPreviewTransition, value: isPresented)
            }.padding(40)
        }
        .fullScreenCover(isPresented: $openEditor, onDismiss: {}) {
            EditorView(dateInt: dateSelection)
        }
    }
}

struct CardPreview_Previews: PreviewProvider {
    static var previews: some View {
        CardPreview(dateSelection: .constant(20220621), previewImg: UIImage())
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
