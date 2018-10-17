//
//  VenueViewModel.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON
import FoursquareAPIClient

final class VenueViewModel {
    fileprivate(set) var venues = BehaviorRelay<[Venue]>(value: [])
    // ForesquareのAPIクライアントのインスタンス
    let client = VenueAPIClient()
    // 観測対象のオブジェクトの一括解放用
    let disposeBag = DisposeBag()

    init() {}

    // APIクライアント経由で情報を取得する
    func fetch(q: String = "") {
        // APIクライアントのメソッドを実行する
        client.search(query: q)
            // イベントステータスに応じて処理
            .subscribe { [weak self] result in
                guard let me = self else { return }
                // 結果取得ができた際には、APIクライアントの変数:venuesに結果の値を入れる
                switch result {
                case .next(let data):
                    me.venues.accept(data)
                case .error(let error):
                    print(error)
                case .completed:
                    ()
                }
            }
            .disposed(by: disposeBag)
    }

}
