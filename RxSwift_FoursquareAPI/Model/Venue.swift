//
//  Venue.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

// 取得データの定義とマッピングに関するロジック部分

import UIKit
import SwiftyJSON

// アイコンのサイズに関する定数
private let kCategoryIconSize = 88

// ForesquareAPIから取得した情報に関する定義（Model層に該当）
struct Venue {
    let venueId: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let city: String
    let state: String
    let categoryIconURL: URL?

    //イニシャライザ（取得したForesquareAPIからのレスポンスに対して必要なものを抽出する）
    init(json: JSON) {
        // ForesquareAPIからのレスポンスで主要情報を取得する(SWiftyJSONを使用)
        self.venueId = json["id"].string ?? ""
        self.name = json["name"].string ?? ""
        self.address = json["location"]["address"].string ?? ""
        self.latitude = json["location"]["lat"].double ?? 0.0
        self.longitude = json["location"]["lng"].double ?? 0.0
        self.city = json["location"]["city"].string ?? ""
        self.state = json["location"]["state"].string ?? ""

        // ForesquareAPIからのレスポンスでカテゴリーを元にしてアイコンのURLを作成する(SWiftyJSONを使用)
        if let categories = json["categories"].array, categories.count > 0 {
            let iconPrefix = json["categories"][0]["icon"]["prefix"].string ?? ""
            let iconSuffix = json["categories"][0]["icon"]["suffix"].string ?? ""
            let iconUrlString = String(format: "%@%d%@", iconPrefix, kCategoryIconSize, iconSuffix)
            self.categoryIconURL = URL(string: iconUrlString)
        } else {
            self.categoryIconURL = nil
        }
    }
}

extension Venue: CustomStringConvertible {
    // 取得データの詳細に関する変数
    var description: String {
        return "<venueId=\(venueId)"
            + ", name=\(name)"
            + ", address=\(address)"
            + ", latitude=\(latitude), longitude=\(longitude)"
            + ", state=\(state)"
            + ", city=\(city)"
            + ", categoryIconURL=\(String(describing: categoryIconURL))>"
    }
}
