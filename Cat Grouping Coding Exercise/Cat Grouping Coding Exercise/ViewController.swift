//
//  ViewController.swift
//  Cat Grouping Coding Exercise
//
//  Created by Ivan Galic on 10/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  private let catGrouping = CatGrouping()
  private var tableData: [(Gender, [Pet])] = []
  private let refreshTrigger = MutableProperty<()>(())
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let refreshControl = UIRefreshControl(frame: CGRect.zero)
    tableView.refreshControl = refreshControl
    setupSignals()
    refreshControl.beginRefreshing()
    refreshTrigger.value = ()
  }

  func setupSignals() {
    refreshTrigger <~ tableView.refreshControl!.reactive.controlEvents(.valueChanged).map { _ in
      () }

    refreshTrigger
    .producer
      .take(during: reactive.lifetime)
      .flatMap(.latest) { CatGrouping.catPeopleByGender() }
      .observe(on: UIScheduler())
      .startWithResult { [weak self] (result) in
        guard let this = self else { return }
        this.tableView.refreshControl?.endRefreshing()
        if result.error != nil {
          // TODO: Add error logging and better handling here
          this.showError(message: "We're sorry, there was an error loading the data. Please try again.")
        } else if let data = result.value {
          this.tableData = data.map { ($0.key, $0.value) }
          this.tableView.reloadData()
        }
      }
  }
  
  func showError(message: String) {
    let alertVc = UIAlertController(title: "Error",
                                    message: message,
                                    preferredStyle: .alert)
    alertVc.addAction(UIAlertAction(title: "Ok",
                                    style: .default,
                                    handler: nil))
    self.present(alertVc, animated: true, completion: nil)
  }
  
  // MARK: Table view data source and delegate
  func numberOfSections(in tableView: UITableView) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData[section].1.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let pets = tableData[indexPath.section].1
    cell.textLabel?.text = pets[indexPath.row].name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
    header.font = UIFont.boldSystemFont(ofSize: 20)
    header.text = tableData[section].0.rawValue
    
    let holderView = UIView(frame: header.frame)
    holderView.addSubview(header)
    header.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(10)
      make.top.bottom.right.equalToSuperview()
    }
    
    return holderView
  }
}

