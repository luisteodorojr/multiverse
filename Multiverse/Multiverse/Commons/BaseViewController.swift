//
//  BaseViewController.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(from viewController: UIViewController)
}

class BaseViewController: UIViewController {
    weak var viewCoordinatorDelegate: CoordinatorDelegate?
    private var errorView: ErrorView?
    private var loadingView: LoadingView?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent || isBeingDismissed {
            viewCoordinatorDelegate?.didFinish(from: self)
        }
    }
    
    func setupBackButtonAppearance() {
        navigationItem.backButtonTitle = ""
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func showError(message: String, retryAction: (() -> Void)? = nil) {
        hideError()
        
        let errorView = ErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.configure(message: message, retryAction: retryAction)
        view.addSubview(errorView)
        self.errorView = errorView
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func hideError() {
        errorView?.removeFromSuperview()
        errorView = nil
    }
    
    func showLoading() {
        hideLoading()
        
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.configure(message: "Carregando informações...")
        view.addSubview(loadingView)
        self.loadingView = loadingView
        
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
}
