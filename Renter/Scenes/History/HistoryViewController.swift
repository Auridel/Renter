//
//  HistoryViewController.swift
//  Renter
//
//  Created by Oleg Efimov on 16.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HistoryDisplayLogic: AnyObject {
    func displayHistory(viewModel: History.GetHistoryData.ViewModel)
    func displayFiltredHistory(viewModel: History.FilterData.ViewModel)
}

class HistoryViewController: UIViewController {
    
    var interactor: HistoryBusinessLogic?
    
    var router: (NSObjectProtocol & HistoryRoutingLogic & HistoryDataPassing)?
    
    private var rows = [HistoryRowViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HistoryTableViewCell.self,
                           forCellReuseIdentifier: HistoryTableViewCell.identifier)
        return tableView
    }()
    
    // TODO: No data view

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryConfigurator.shared.configure(with: self)
        
        title = "History"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
//        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        
        configureViews()
        passHistoryRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    //MARK: - receive events from UI
    
    
    
    // MARK: - request data from HistoryInteractor

    func passHistoryRequest() {
        let request = History.GetHistoryData.Request()
        interactor?.getHistory(request: request)
    }

    func passFilterRequest() {
//        let request = History.FilterData.Request()
//        interactor?.getFiltredHistory(request: request)
    }
    
    // MARK: Common
    
    private func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
}

// MARK: HistoryDisplayLogic
extension HistoryViewController: HistoryDisplayLogic {

    // MARK: - display view model from HistoryPresenter

    func displayHistory(viewModel: History.GetHistoryData.ViewModel) {
        DispatchQueue.main.async {
            self.rows = viewModel.rows
            self.tableView.reloadData()
        }
    }

    func displayFiltredHistory(viewModel: History.FilterData.ViewModel) {
        // do sometingElse with viewModel
    }
}

// MARK: TableView
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.identifier,
            for: indexPath) as? HistoryTableViewCell
        else {
            return UITableViewCell()
        }
        let viewModel = rows[indexPath.row]
//        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}