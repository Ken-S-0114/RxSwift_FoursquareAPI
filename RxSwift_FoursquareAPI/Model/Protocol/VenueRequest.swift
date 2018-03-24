//
//  VenueRequest.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import UIKit

protocol VenueRequest {
  var path: String { get }
}

extension VenueRequest {
  var path: String {
   return  "venues/search"
  }

}
