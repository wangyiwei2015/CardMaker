//
//  Helpers.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

//extension View {
//    func snapshot(origin: CGPoint = .zero, size: CGSize = .zero) -> UIImage {
//        let controller = UIHostingController(rootView: self.environmentObject(AppState()))
//        let view = controller.view
//
//        let targetSize = size == .zero ? controller.view.intrinsicContentSize : size
//        view?.backgroundColor = UIColor.clear
//        view?.bounds = CGRect(origin: origin, size: targetSize)
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}

extension View {
    func snapshot(_ _controller: UIViewController? = nil) -> UIImage {
        let controller = _controller ?? UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct CardDesign {
    var date: Int
    
    var title: String
    var titleFontId: Int
    var titleColorId: Int
    
    var bgColorId: Int
    
    var moodId: Int = 0
    var feelSelf: Int = 0
    var feelWorld: Int = 0
    
    var imgStyle: Int
    
    var dateStyle: Int
    var dateOpacityId: Int
    var dateColorId: Int
    var datePosition: Int
    
    var showYear: Bool
    var yearBottom: Bool
}

class CardData: NSObject {
    private override init() {}
    static let shared = CardData()
    private let dataDir = "\(NSHomeDirectory())/Documents/"
    
    private func listAllDates() -> [Int] {
        let files = try! FileManager.default.contentsOfDirectory(atPath: dataDir)
        return files.map({Int($0) ?? 0}).filter({$0 > 20000000})
    }
    
    public var allDates: [Int] {listAllDates()}
    
    public func saveData(_ work: CardDesign, designDate: Int, output: UIImage) {
        try? FileManager.default.createDirectory(atPath: "\(dataDir)\(designDate)/", withIntermediateDirectories: true)
        let configFile = "\(dataDir)\(designDate)/\(work.date)_cfg"
        let imgFile = "\(dataDir)\(designDate)/\(work.date).jpg"
        try! output.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: imgFile))
        var cfgText = work.title
        cfgText.append("\ntitleFontId=\(work.titleFontId)")
        cfgText.append("\ntitleColorId=\(work.titleColorId)")
        cfgText.append("\nbgColorId=\(work.bgColorId)")
        cfgText.append("\nmoodId=\(work.moodId)")
        cfgText.append("\nfeelSelf=\(work.feelSelf)")
        cfgText.append("\nfeelWorld=\(work.feelWorld)")
        cfgText.append("\nimgStyle=\(work.imgStyle)")
        cfgText.append("\ndateStyle=\(work.dateStyle)")
        cfgText.append("\ndateOpacityId=\(work.dateOpacityId)")
        cfgText.append("\ndateColorId=\(work.dateColorId)")
        cfgText.append("\ndatePosition=\(work.datePosition)")
        cfgText.append("\nshowYear=\(work.showYear)")
        cfgText.append("\nyearBottom=\(work.yearBottom)")
        try! cfgText.write(toFile: configFile, atomically: true, encoding: .utf8)
    }
    
    public func loadData(_ designDate: Int) -> [CardDesign] {
        if let cfgText = try? String(contentsOfFile: "\(dataDir)\(designDate)/\(designDate)_cfg") {
            let components = cfgText.split(separator: "\n")
            guard components.count == 14 else {return []}
            var cfgDict: [String:String] = [:]
            components.filter({String($0).firstIndex(of: "=") != nil}).forEach { str in
                let kvp = str.split(separator: "=")
                cfgDict[String(kvp[0])] = String(kvp[1])
            }
            let firstCard = CardDesign(
                date: designDate, title: String(components[0]),
                titleFontId: Int(cfgDict["titleFontId"] ?? "0") ?? 0,
                titleColorId: Int(cfgDict["titleColorId"] ?? "6") ?? 6,
                bgColorId: Int(cfgDict["bgColorId"] ?? "2") ?? 2,
                imgStyle: Int(cfgDict["imgStyle"] ?? "0") ?? 0,
                dateStyle: Int(cfgDict["dateStyle"] ?? "0") ?? 0,
                dateOpacityId: Int(cfgDict["dateOpacityId"] ?? "2") ?? 2,
                dateColorId: Int(cfgDict["dateColorId"] ?? "2") ?? 2,
                datePosition: Int(cfgDict["datePosition"] ?? "0") ?? 0,
                showYear: Bool(cfgDict["showYear"] ?? "false") ?? false,
                yearBottom: Bool(cfgDict["yearBottom"] ?? "true") ?? true)
            return [firstCard]
        } else {
            return []
        }
    }
    
    public func loadPreviews(_ date: Int) -> [UIImage] {
        if let firstImg = UIImage(contentsOfFile: "\(dataDir)\(date)/\(date).jpg") {
            return [firstImg]
        } else {
            return []
        }
    }
}
