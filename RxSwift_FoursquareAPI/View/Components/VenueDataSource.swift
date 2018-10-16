//
//  VenueDataSource.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class VenueDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
  
  // エイリアスの設定
  typealias Element = [Venue]
  // FourSquareからのメニュー情報格納用の変数
  fileprivate var venues = [Venue]()
  
  // RxTableViewDataSourceTypeのメソッドを拡張して設定する
  func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
    switch observedEvent {
    case .next(let value):
      self.venues = value
      tableView.reloadData()
    case .error(let error):
      print(error)
    case .completed:
      ()
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.venues.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! VenueCell
    
    cell.venueName.text = venues[indexPath.row].name
    cell.venueAddress.text = venues[indexPath.row].address
    cell.venueCity.text = venues[indexPath.row].city
    cell.venueState.text = venues[indexPath.row].state
    
    if let categoryIconURL = venues[indexPath.row].categoryIconURL {
      cell.venueIconImage.sd_setImage(with: categoryIconURL)
    }
    
    cell.venueDescription.text = venues[indexPath.row].description
    
    //セルのアクセサリタイプの設定
    cell.accessoryType = UITableViewCell.AccessoryType.none
    cell.selectionStyle = UITableViewCell.SelectionStyle.none
    
    return cell
  }
}
