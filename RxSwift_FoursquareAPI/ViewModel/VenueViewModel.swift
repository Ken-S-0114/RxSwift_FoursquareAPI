//
//  VenueViewModel.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import RxSwift
import SwiftyJSON
import FoursquareAPIClient

final class VenueViewModel {
  fileprivate var venues = Variable<[Venue]>([])
  
  // ForesquareのAPIクライアントのインスタンス
  let client = VenueAPIClient()
  // 観測対象のオブジェクトの一括解放用
  let disposeBag = DisposeBag()
  // イニシャライザ
  init() {}
  
  // APIクライアント経由で情報を取得する
  public func fetch(q: String = "") {
    // APIクライアントのメソッドを実行する
    client.search(query: q)
      .subscribe { [weak self] result in
        // 結果取得ができた際には、APIクライアントの変数:venuesに結果の値を入れる
        switch result {
        case .next(let value):
          self?.venues.value = value
        case .error(let error):
          print(error)
        case .completed:
          ()
        }
      }
      // 観測状態からの解放を行う
      .disposed(by: disposeBag)
  }
}
