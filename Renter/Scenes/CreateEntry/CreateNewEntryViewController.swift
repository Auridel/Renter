//
//  CreateNewEntryViewController.swift
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
import ProgressHUD

protocol CreateNewEntryDisplayLogic: AnyObject {
    func displayCurrentPlan(viewModel: CreateNewEntry.GetMeters.ViewModel)
    func displayTransactionStatus(viewModel: CreateNewEntry.SaveNewEntry.ViewModel)
    func presentAlert(with title: String, message: String)
}

class CreateNewEntryViewController: UIViewController {
    
    var interactor: CreateNewEntryBusinessLogic?
    
    var router: (NSObjectProtocol & CreateNewEntryRoutingLogic & CreateNewEntryDataPassing)?
    
    private enum PlanInputTag: String {
        case cold_plan, hot_plan, day_plan, night_plan
    }
    
    private enum MetersInputTag: String {
        case cold, hot, day, night
    }
    
    private var planViewModel: CreateNewEntry.GetMeters.ViewModel?
    
    private let scrollView = UIScrollView()
    
    private let planGroup = GroupedInputView(
        title: "Monthly Plan",
        inputs: [
            GroupedInput(title: "Cold Plan", tag: PlanInputTag.cold_plan.rawValue),
            GroupedInput(title: "Hot Plan", tag: PlanInputTag.hot_plan.rawValue),
            GroupedInput(title: "Day Plan", tag: PlanInputTag.day_plan.rawValue),
            GroupedInput(title: "Night Plan", tag: PlanInputTag.night_plan.rawValue)
        ])
    
    private let metersGroup = GroupedInputView(
        title: "Current Meters",
        inputs: [
            GroupedInput(title: "Cold", tag: MetersInputTag.cold.rawValue),
            GroupedInput(title: "Hot", tag: MetersInputTag.hot.rawValue),
            GroupedInput(title: "Day Electricity", tag: MetersInputTag.day.rawValue),
            GroupedInput(title: "Night Electricity", tag: MetersInputTag.night.rawValue)
        ])
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .link
        configuration.cornerStyle = .small
        button.configuration = configuration
        return button
    }()

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Error handling
        title = "Create New Entry"
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        configureViews()
        getCurrentPlan()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutViews()
    }
    
    //MARK: - receive events from UI
    
    @objc private func didTapSubmitButton() {
        if metersGroup.validate() == true,
              planGroup.validate() == true
        {
            ProgressHUD.animationType = .circleRotateChase
            ProgressHUD.show()
            
            passCreateNewEntryRequest()
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    // MARK: - request data from CreateNewEntryInteractor

    func getCurrentPlan() {
        let request = CreateNewEntry.GetMeters.Request()
        interactor?.getCurrentPlanData(request: request)
    }

    func passCreateNewEntryRequest() {
        let planData = planGroup.getValues()
        let metersData = metersGroup.getValues()
        
        let request = CreateNewEntry.SaveNewEntry.Request(
            plan: CreateNewEntryUserInput(
                cold: planData[PlanInputTag.cold_plan.rawValue] ?? "",
                hot: planData[PlanInputTag.hot_plan.rawValue] ?? "",
                day: planData[PlanInputTag.day_plan.rawValue] ?? "",
                night: planData[PlanInputTag.night_plan.rawValue] ?? ""),
            meters: CreateNewEntryUserInput(
                cold: metersData[MetersInputTag.cold.rawValue] ?? "",
                hot: metersData[MetersInputTag.hot.rawValue] ?? "",
                day: metersData[MetersInputTag.day.rawValue] ?? "",
                night: metersData[MetersInputTag.night.rawValue] ?? ""))
        interactor?.createNewEntry(request: request)
    }

    // MARK: Common
    
    private func configureViews() {
        submitButton.addTarget(self,
                               action: #selector(didTapSubmitButton),
                               for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(planGroup)
        scrollView.addSubview(metersGroup)
        scrollView.addSubview(submitButton)
    }
    
    private func layoutViews() {
        scrollView.frame = view.bounds
        
        let padding: CGFloat = 16
        let lineSpacing: CGFloat = 24

        planGroup.frame = CGRect(
            x: 0,
            y: padding,
            width: view.width,
            height: planGroup.blockHeight)
        metersGroup.frame = CGRect(
            x: 0,
            y: planGroup.bottom + lineSpacing,
            width: view.width,
            height: metersGroup.blockHeight)
        submitButton.frame = CGRect(
            x: scrollView.width - 100 - padding,
            y: metersGroup.bottom + lineSpacing,
            width: 100,
            height: 50)
        
        scrollView.contentSize = CGSize(width: view.width, height: submitButton.bottom)
    }
}

// MARK: CreateNewEntryDisplayLogic
extension CreateNewEntryViewController: CreateNewEntryDisplayLogic {
    
    // MARK: - display view model from CreateNewEntryPresenter
    
    func displayCurrentPlan(viewModel: CreateNewEntry.GetMeters.ViewModel) {
        planGroup.setValues([
            PlanInputTag.cold_plan.rawValue: viewModel.cold,
            PlanInputTag.hot_plan.rawValue: viewModel.hot,
            PlanInputTag.day_plan.rawValue: viewModel.day,
            PlanInputTag.night_plan.rawValue: viewModel.night
        ])
    }

    func displayTransactionStatus(viewModel: CreateNewEntry.SaveNewEntry.ViewModel) {
        ProgressHUD.show(icon: .succeed)
        if viewModel.isSuccess {
            router?.routeToPreviousScreen()
        }
    }
    
    func presentAlert(with title: String, message: String) {
        DispatchQueue.main.async {
            ProgressHUD.show(icon: .failed)
            
            let alert = ComponentFactory.shared.produceUIAlert(
                with: title,
                message: message)
            self.present(alert, animated: true)
        }
    }
}
