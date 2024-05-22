//
//  BMICalculator.swift
//  SeSac_BMICalculator
//
//  Created by gnksbm on 5/22/24.
//

import Foundation

struct BMICalculator {
    static func calculate(weight: Double, height: Double) -> Double {
        weight / (height * height) * 10000
    }
}
