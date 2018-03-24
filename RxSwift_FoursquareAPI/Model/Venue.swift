//
//  Venue.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import UIKit

struct Venue: CustomStringConvertible {
  
  let venueId: String
  let name: String
  let address: String
  let latitude: Double
  let longitude: Double
  let city: String
  let state: String
  let categoryIconURL: URL
  
  // 取得データの詳細に関する変数
  /* CustomStringConvertibleにはdescriptionというプロパティが定義
   * → 結果 descriptionで定義された文字列が表示される
   */
  var description: String {
    return "<venueId=\(venueId)"
      + ", name=\(name)"
      + ", address=\(address)"
      + ", latitude=\(latitude), longitude=\(longitude)"
      + ", state=\(state)"
      + ", city=\(city)"
      + ", categoryIconURL=\(categoryIconURL)>"
  }
  
  //イニシャライザ（取得したForesquareAPIからのレスポンスに対して必要なものを抽出する）
  init(json: JSON) {
    //ForesquareAPIからのレスポンスで主要情報を取得する(SWiftyJSONを使用)
    self.venueId = json["id"].string ?? ""
  }
}
