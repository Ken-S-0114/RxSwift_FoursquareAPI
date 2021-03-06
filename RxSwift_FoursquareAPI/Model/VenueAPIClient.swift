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
final class VenueAPIClient {
    // クエリ文字列を元に検索を行う
    func search(query: String = "") -> Observable<[Venue]> {
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
            client.request(path: "venues/search", parameter: parameter) { result in
                switch result {
                case .success(let data):
                    //APIのJSONを解析する
                    let json = try! JSON(data: data)
                    let venues = self.parse(venuesJSON: json["response"]["venues"])
                    // パースしてきたjsonの値を通知対象にする
                    observer.onNext(venues)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    // Venue.swift(Model層)で定義した形で取得した値を格納する
    fileprivate func parse(venuesJSON: JSON) -> [Venue] {
        var venues = [Venue]()
        venuesJSON.forEach { (key, venueJSON) in
            venues.append(Venue(json: venueJSON))
        }
        return venues
    }
}
