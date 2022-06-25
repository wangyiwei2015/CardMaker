//
//  EditorView+CardDesign.swift
//  CardMaker
//
//  Created by wyw on 2022/6/25.
//

import SwiftUI

extension EditorView {
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
        Text(titleContent.replacingOccurrences(of: "\\n", with: "\n"))
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
            Group {
                bgColor.onTapGesture {editing = .background}
                userImage.onTapGesture {editing = .image}
                titleText.onTapGesture {editing = .title}
                dateText.onTapGesture {editing = .date}
                yearLabel.onTapGesture {editing = .date}
            }
        }.frame(width: 500, height: 750).clipped()
    }
    
    @ViewBuilder var card: some View {
        GeometryReader { geo in
            fullSizeCard
            .scaleEffect(geo.size.width / 500, anchor: .topLeading)
        }
        .aspectRatio(2 / 3, contentMode: .fit)
        .background(Color.background.shadow(radius: 5, y: 3))
        .animation(.easeOut(duration: 0.1), value: editing)
    }
}
