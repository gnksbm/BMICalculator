//
//  NumericInputError.swift
//  SeSac_BMICalculator
//
//  Created by gnksbm on 5/22/24.
//

import Foundation

enum NumericInputError: LocalizedError {
    case emptyInput(String)
    case containSpace(String)
    case nonNumericInput(String)
    case outOfRange(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emptyInput(let fieldName):
            return "\(fieldName)가 비었습니다"
        case .containSpace(let fieldName):
            return "\(fieldName)의 공백을 제거해주세요"
        case .nonNumericInput(let fieldName):
            return "\(fieldName)는 숫자만 입력해주세요"
        case .outOfRange(let fieldName):
            return "올바른 \(fieldName)를 입력해주세요"
        case .unknown:
            return "알 수 없는 오류입니다"
        }
    }
}
