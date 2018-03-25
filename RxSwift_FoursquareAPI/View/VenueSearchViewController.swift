//
//  VenueSearchViewController.swift
//  RxSwift_FoursquareAPI
//
//  Created by 佐藤賢 on 2018/03/25.
//  Copyright © 2018年 佐藤賢. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class VenueSearchViewController: UIViewController {
  
  @IBOutlet weak var venueSearchBar: UISearchBar!
  @IBOutlet weak var venueSearchTableView: UITableView!
  @IBOutlet weak var bottomVenueTableConstraint: NSLayoutConstraint!
  
  // ViewModel・デリゲート・データソースのインスタンスを設定
  let venueViewModel = VenueViewModel()
  var venueDataSource = VenueDataSource()
  var venueDelegate = VenueDelegate()
  
  // 観測対象のオブジェクトの一括解放用
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //RxSwiftでの処理に関する部分をまとめたメソッドを実行
    setupRx()
    
    //RxSwiftを使用しない処理に関する部分をまとめたメソッド実行
    setupUI()
  }
  
  private func setupRx() {
    // 配置したテーブルビューにデリゲートの適用をする
    venueSearchTableView.delegate = self.venueDelegate
    
    // Xibのクラスを読み込む宣言を行う
    let nibTableView = UINib(nibName: "VenueCell", bundle: nil)
    venueSearchTableView.register(nibTableView, forCellReuseIdentifier: "VenueCell")
    
    // 検索バーの変化から0.5秒後に.driveメソッド内の処理を実行する
    venueSearchBar.rx.text.asDriver()
    .throttle(0.5)
      .drive(onNext: { query in
        // ViewModelに定義したfetchメソッドを実行
        self.venueViewModel.fetch(q: query!)
      })
    .disposed(by: disposeBag)
    
    // データの取得ができたらテーブルビューのデータソースの定義に則って表示する値を設定する
    venueViewModel
      .venues
      .asDriver()
      .drive(
        self.venueSearchTableView.rx.items(dataSource: self.venueDataSource)
    )
    .disposed(by: disposeBag)
    
    
  }
  
  private func setupUI() {
    // キーボードのイベントを監視対象にする
    // Case1. キーボードを開いた場合のイベント
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: NSNotification.Name.UIKeyboardWillShow,
      object: nil)
    
    // Case2. キーボードを閉じた場合のイベント
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: NSNotification.Name.UIKeyboardWillHide,
      object: nil)
  }
  
  // キーボード表示時に発動されるメソッド
  @objc private func keyboardWillShow(_ notification: Notification) {
    
    // キーボードのサイズを取得する
    guard let keyboardFrame =
      (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    
    // 一覧表示用テーブルビューのAutoLayoutの制約を更新して高さをキーボード分だけ縮める
    bottomVenueTableConstraint.constant = keyboardFrame.height
    UIView.animate(withDuration: 0.3, animations: {
      self.view.updateConstraints()
    })
  }
  
  //キーボード非表示時に発動されるメソッド
  @objc private func keyboardWillHide(_ notification: Notification) {
    
    //一覧表示用テーブルビューのAutoLayoutの制約を更新して高さを元に戻す
    bottomVenueTableConstraint.constant = 0.0
    UIView.animate(withDuration: 0.3, animations: {
      self.view.updateConstraints()
    })
  }
  
  //メモリ解放時にキーボードのイベント監視対象から除外する
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
