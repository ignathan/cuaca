//
//  HomeViewController.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.autocapitalizationType = .words
        searchBar.delegate = self
        searchBar.placeholder = "Search or enter city name"
        return searchBar
    }()
    
    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .primaryText
        return view
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryText
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var bottomConstraint: NSLayoutConstraint!
    
    var interactor: HomeInteractor
    var presenter: HomePresenter
    
    init() {
        interactor = HomeInteractor()
        presenter = HomePresenter(interactor: interactor)
        super.init(nibName: nil, bundle: nil)
        
        interactor.delegate = presenter
        presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackground
        
        view.addSubview(loadingView)
        view.addSubview(errorLabel)
        view.addSubview(searchBar)
        
        bottomConstraint = searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint
        ])
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        animateWithKeyboard(notification: notification) { keyboardFrame in
            self.bottomConstraint.constant = -keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        animateWithKeyboard(notification: notification) { keyboardFrame in
            self.bottomConstraint.constant = 0
        }
    }
    
    func animateWithKeyboard(notification: NSNotification,
                             animations: ((_ keyboardFrame: CGRect) -> Void)?)
    {
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!
        
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            animations?(keyboardFrameValue.cgRectValue)
            
            self.view?.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let keyword = searchBar.text else { return }
        
        presenter.requestCurrentWeather(keyword: keyword)
    }
}

// MARK: - HomeDelegate
protocol HomeDelegate: AnyObject {
    
    func displayLoading()
    
    func display(errorMessage: String)
    
    func display(location: String,
                 temperature: String,
                 condition: String,
                 humidityTitle: String,
                 humidity: String,
                 feelsTitle: String,
                 feels: String,
                 uvTitle: String,
                 uv: String)
}

extension HomeViewController: HomeDelegate {
    
    func displayLoading() {
        loadingView.isHidden = false
        loadingView.startAnimating()
        
        errorLabel.isHidden = true
    }
    
    func display(errorMessage: String) {
        loadingView.stopAnimating()
        
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
    }
    
    func display(location: String,
                 temperature: String,
                 condition: String,
                 humidityTitle: String,
                 humidity: String,
                 feelsTitle: String,
                 feels: String,
                 uvTitle: String,
                 uv: String) {
        loadingView.stopAnimating()
        
        errorLabel.isHidden = true
    }
}
