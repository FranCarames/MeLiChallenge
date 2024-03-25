//
//  AmountFormatters.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 24/03/2024.
//

import Foundation

final class AmountFormatters {
    static var inputsNF: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static var moneyNF: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.decimalSeparator = ","
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter
    }()
}

//    Double to String
extension AmountFormatters {
///    This function is used to format currency amounts to the format and add the symbol
    static func getMoneyAmount(for amount: Double?) -> String? {
        guard let amount = amount else { return nil }
        return AmountFormatters.moneyNF.string(from: NSNumber(value: amount))
    }
}
