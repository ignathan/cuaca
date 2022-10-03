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
    
    let errorLabel: CLabel = {
        let label = CLabel(size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let locationLabel: CLabel = {
        let label = CLabel(size: 36)
        label.textAlignment = .center
        return label
    }()
    
    let temperatureLabel: CLabel = {
        let label = CLabel(size: 36)
        label.textAlignment = .center
        return label
    }()
    
    let conditionLabel: CLabel = {
        let label = CLabel(size: 24)
        label.textAlignment = .center
        return label
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let humidityTitleLabel: CLabel = {
        let label = CLabel(style: .title)
        return label
    }()
    
    let humidityLabel: CLabel = {
        let label = CLabel(style: .content)
        return label
    }()
    
    let feelsTitleLabel: CLabel = {
        let label = CLabel(style: .title)
        return label
    }()
    
    let feelsLabel: CLabel = {
        let label = CLabel(style: .content)
        return label
    }()
    
    let uvTitleLabel: CLabel = {
        let label = CLabel(style: .title)
        return label
    }()
    
    let uvLabel: CLabel = {
        let label = CLabel(style: .content)
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
        view.addSubview(headerStackView)
        view.addSubview(contentStackView)
        
        headerStackView.addArrangedSubview(locationLabel)
        headerStackView.addArrangedSubview(temperatureLabel)
        headerStackView.addArrangedSubview(conditionLabel)
        
        contentStackView.addArrangedSubview(humidityTitleLabel)
        contentStackView.addArrangedSubview(humidityLabel)
        contentStackView.addArrangedSubview(feelsTitleLabel)
        contentStackView.addArrangedSubview(feelsLabel)
        contentStackView.addArrangedSubview(uvTitleLabel)
        contentStackView.addArrangedSubview(uvLabel)
        
        bottomConstraint = searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: searchBar.topAnchor, constant: -10),
            
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
        
        headerStackView.isHidden = true
        contentStackView.isHidden = true
    }
    
    func display(errorMessage: String) {
        loadingView.stopAnimating()
        
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
        
        headerStackView.isHidden = true
        contentStackView.isHidden = true
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
        
        headerStackView.isHidden = false
        contentStackView.isHidden = false
        
        locationLabel.text = location
        temperatureLabel.text = temperature
        conditionLabel.text = condition
        humidityTitleLabel.text = humidityTitle
        humidityLabel.text = humidity
        feelsTitleLabel.text = feelsTitle
        feelsLabel.text = feels
        uvTitleLabel.text = uvTitle
        uvLabel.text = uv
    }
}
