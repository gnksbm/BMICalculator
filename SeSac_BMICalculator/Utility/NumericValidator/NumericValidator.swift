//
//  NumericValidator.swift
//  SeSac_BMICalculator
//
//  Created by gnksbm on 5/22/24.
//

import Foundation

struct NumericValidator {
    static func validateInput(
        input: String?,
        range: Range<Int>,
        fieldName: String = ""
    ) throws -> Double {
        guard let input else { throw NumericInputError.unknown }
        guard !input.isEmpty
        else { throw NumericInputError.emptyInput(fieldName) }
        guard !input.contains(" ")
        else { throw NumericInputError.containSpace(fieldName) }
        guard let double = Double(input)
        else { throw NumericInputError.nonNumericInput(fieldName) }
        guard range ~= Int(double)
        else { throw NumericInputError.outOfRange(fieldName) }
        return double
    }
}
