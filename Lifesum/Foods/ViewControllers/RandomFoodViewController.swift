//
//  RandomFoodViewController.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import UIKit

class RandomFoodViewController: UIViewController {
    @IBOutlet private weak var circleContainerView: UIView!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productCalories: UILabel!
    @IBOutlet private weak var carbsValue: UILabel!
    @IBOutlet private weak var proteinValue: UILabel!
    @IBOutlet private weak var fatValue: UILabel!
    @IBOutlet weak var moreInfoBtnContainer: UIView!
    @IBOutlet private weak var moreInfoBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: RandomFoodViewModel

    init(viewModel: RandomFoodViewModel) {
        self.viewModel = viewModel
        super.init(nibName: RandomFoodViewController.IDENTIFIER, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        viewModel.getRandomFood { [weak self] item in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()

                if let item = item {
                    self?.setProduct(item: item)
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    override func becomeFirstResponder() -> Bool {
        true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            activityIndicator.startAnimating()
            viewModel.getRandomFood { [weak self] item in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()

                    if let item = item {
                        self?.setProduct(item: item)
                    }
                }
            }
        }
    }

    func setProduct(item: FoodItem) {
        UIView.transition(with: view,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in

                              self?.productName.text = item.title
                              self?.productCalories.text = "\(item.calories)"
                              self?.carbsValue.text = item.carbs.stringValueWithPercentage
                              self?.proteinValue.text = item.protein.stringValueWithPercentage
                              self?.fatValue.text = item.fat.stringValueWithPercentage

                          }, completion: nil)
    }

    func setupUI() {
        let circleRadius = circleView.frame.width / 2

        circleView.clipsToBounds = true

        circleView.cornerRadius = circleRadius
        circleContainerView.dropShadow(shadowColor: .gradientOrange, shadowOffset: CGSize(width: 4, height: 4))

        circleView.addGradient(colors: [.gradientOrange, .gradientRed], opacity: 1.0, angle: 45)
        moreInfoBtn.addGradient(colors: [.gradientNavy, .gradientNavy2], opacity: 1.0)
        moreInfoBtnContainer.dropShadow(shadowColor: .gradientNavy2, shadowOffset: CGSize(width: 2, height: 2))
    }
}
