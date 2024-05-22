//
//  ViewController.swift
//  SeSac_BMICalculator
//
//  Created by gnksbm on 5/21/24.
//

import UIKit

final class ViewController: UIViewController {
    private let heightRange = 50...250
    private let weightRange = 3...250
    
    @IBOutlet var textFieldBackgroundViews: [UIView]!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var calculateButton: UIButton!
    
    private lazy var hiddenButton = {
        let button = UIButton()
        button.setImage(
            .init(systemName: "eye.slash"),
            for: .normal
        )
        button.tintColor = .gray
        button.addTarget(
            self,
            action: #selector(hiddenButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        configureTextFields()
        configureButtons()
    }
    
    private func configureLabels() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        descriptionLabel.attributedText = .init(
            string: "당신의 BMI 지수를\n알려드릴게요",
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
    }
    
    private func configureTextFields() {
        textFieldBackgroundViews.forEach {
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
        }
        weightTextField.rightView = hiddenButton
        weightTextField.rightViewMode = .always
        weightTextField.isSecureTextEntry = true
    }
    
    private func configureButtons() {
        randomButton.addTarget(
            self,
            action: #selector(randomButtonTapped),
            for: .touchUpInside
        )
        calculateButton.layer.cornerRadius = 20
        calculateButton.addTarget(
            self,
            action: #selector(calculateButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func hiddenButtonTapped(_ sender: UIButton) {
        let isSecure = !weightTextField.isSecureTextEntry
        weightTextField.isSecureTextEntry = isSecure
        let imageName = isSecure ? "eye.slash" : "eye"
        let buttonColor = isSecure ? UIColor.gray : .black
        hiddenButton.setImage(
            .init(
                systemName: imageName
            ),
            for: .normal
        )
        hiddenButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @objc private func randomButtonTapped(_ sender: UIButton) {
        guard let randomHeight = heightRange.randomElement(),
              let randomWeight = weightRange.randomElement()
        else { return }
        heightTextField.text = "\(randomHeight)"
        weightTextField.text = "\(randomWeight)"
    }
    
    @objc private func calculateButtonTapped(_ sender: UIButton) {
        guard let weightText = weightTextField.text,
              let weight = Double(weightText),
              let heightText = heightTextField.text,
              let height = Double(heightText)
        else {
            showInvalidInput(message: "숫자만 입력해주세요")
            return
        }
        guard weightRange ~= Int(weight),
              heightRange ~= Int(height)
        else {
            showInvalidInput(message: "정상적인 수를 입력해주세요")
            return
        }
        let bmi = calculateBMI(
            height: height,
            weight: weight
        )
        let alertController = UIAlertController(
            title: "당신의 BMI 지수는?",
            message: String(format: "%.1f", bmi) + "입니다",
            preferredStyle: .alert
        )
        let doneAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }
    
    private func showInvalidInput(message: String) {
        let alertController = UIAlertController(
            title: "잘못된 입력입니다",
            message: message,
            preferredStyle: .alert
        )
        let doneAction = UIAlertAction(title: "확인", style: .destructive)
        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }
    
    private func calculateBMI(height: Double, weight: Double) -> Double {
         weight / (height * height) * 10000
    }
}
