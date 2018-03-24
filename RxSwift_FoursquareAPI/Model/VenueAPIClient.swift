//
//  VenueAPIClient.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

// FoursquareAPIClientを経由したFoursquareのAPIとの通信処理

import Foundation
import RxSwift
import SwiftyJSON
import FoursquareAPIClient

// Foresquareのメニュー情報を取得用のクライアント部分(実際のデータ通信部分)
class VenueAPIClient {

  // クエリ文字列を元に検索を行う
  fileprivate func search(query: String = "", p: VenueRequest) -> Observable<[Venue]> {
    // Observable戻り値に対して
    return Observable.create { observer in
      // APIクライアントへのアクセス用の設定
      let client = FoursquareAPIClient(
        clientId: APIKey.foresquare_clientid.rawValue,
        clientSecret: APIKey.foresquare_clientsecret.rawValue)
      
      // 検索用のパラメータの設定（暫定的に東京メトロ新大塚駅にしています）
      let parameter: [String : String] = [
        "ll": "35.7260747,139.72983",
        "query": query
      ]
      
      // クライアントへのアクセス
      client.request(path: p.path, parameter: parameter) {
        [weak self] data, error in
        // データの取得と参照に関するチェックをする
        guard let strongSelf = self, let data = data else { return }
        //APIのJSONを解析する
        let json = JSON(data: data)
        let venues = strongSelf.parse(venuesJSON: json)
        
        //パースしてきたjsonの値を通知対象にする
        observer.on(.next(venues))
        observer.on(.completed)
      }
      
      return Disposables.create{}
    }
  }
  
  // Venue.swift(Model層)で定義した形で取得した値を格納する
  fileprivate func parse(venuesJSON: JSON) -> [Venue] {
    var venues = [Venue]()
    for (key: _, venueJSON: JSON) in venuesJSON {
      venues.append(Venue(json: JSON))
    }
    return venues
  }
}
