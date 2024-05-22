//
//  ViewController.swift
//  SeSac_BMICalculator
//
//  Created by gnksbm on 5/21/24.
//

import UIKit

final class ViewController: UIViewController {
    var userNameForEdit: String?
    private let heightRange = 50...250
    private let weightRange = 3...250
    
    @IBOutlet var textFieldBackgroundViews: [UIView]!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var calculateButton: UIButton!
    
    private lazy var nameButton = {
        let button = UIButton()
        button.setTitle("이름 변경", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(
            self,
            action: #selector(editNameButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var resetButton = {
        let button = UIButton()
        button.setTitle("리셋", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(
            self,
            action: #selector(resetButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
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
        let user = User.fetchUser()
        updateDescriptionLabelText(userName: user?.name)
        configureTextFields(weight: user?.weight, height: user?.height)
        configureButtons()
        configureNavigation()
    }
    
    private func updateDescriptionLabelText(userName: String?) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let prefixMessage: String
        if let userName {
            prefixMessage = "\(userName)님"
        } else {
            prefixMessage = "당신"
        }
        descriptionLabel.attributedText = .init(
            string: "\(prefixMessage)의 BMI 지수를\n알려드릴게요",
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
    }
    
    private func configureTextFields(weight: Double?, height: Double?) {
        textFieldBackgroundViews.forEach {
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
        }
        weightTextField.rightView = hiddenButton
        weightTextField.rightViewMode = .always
        weightTextField.isSecureTextEntry = true
        if let weight {
            weightTextField.text = "\(weight)"
        }
        if let height {
            heightTextField.text = "\(height)"
        }
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
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = .init(customView: resetButton)
        navigationItem.rightBarButtonItem = .init(customView: nameButton)
    }
    
    private func showInvalidError(error: Error) {
        let alertController = UIAlertController(
            title: "잘못된 입력입니다",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let doneAction = UIAlertAction(title: "확인", style: .destructive)
        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }
    
    @objc private func editNameFieldChanged(_ sender: UITextField) {
        userNameForEdit = sender.text
    }
    
    @objc private func editNameButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "변경할 이름을 입력해주세요",
            message: nil,
            preferredStyle: .alert
        )
        let savedUser = User.fetchUser()
        let saveAction = UIAlertAction(
            title: "저장",
            style: .default
        ) { _ in
            User.updateUser(newName: self.userNameForEdit)
            self.updateDescriptionLabelText(userName: self.userNameForEdit)
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            self.userNameForEdit = nil
        }
        alertController.addTextField { textField in
            textField.text = savedUser?.name
            textField.addTarget(
                self,
                action: #selector(self.editNameFieldChanged),
                for: .editingChanged
            )
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc private func resetButtonTapped(_ sender: UIButton) {
        User.removeUser()
        updateDescriptionLabelText(userName: nil)
        weightTextField.text?.removeAll()
        heightTextField.text?.removeAll()
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
        do {
            let heightDouble = try NumericValidator.validateInput(
                input: heightTextField.text,
                range: 80..<250,
                fieldName: "키"
            )
            let weightDouble = try NumericValidator.validateInput(
                input: weightTextField.text,
                range: 20..<300,
                fieldName: "몸무게"
            )
            User.updateUser(
                newWeight: weightDouble,
                newHeight: heightDouble
            )
            let bmi = BMICalculator.calculate(
                weight: weightDouble,
                height: heightDouble
            )
            let alertController = UIAlertController(
                title: "당신의 BMI 지수는?",
                message: String(format: "%.1f", bmi) + "입니다",
                preferredStyle: .alert
            )
            let doneAction = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(doneAction)
            present(alertController, animated: true)
        } catch {
            showInvalidError(error: error)
        }
    }
}
