//
//  Double.swift
//  SampleSwiftUI
//
//  Created by PS on 22/03/24.
//

import Foundation

extension Double {
	
	/// Conversion of Double into a Currency with 2-6 decimal places. usd/$ are default values
	
	private var currencyFormatte6: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		//formatter.locale = .current
		
		formatter.currencyCode = "usd"
		formatter.currencyCode = "$"
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 6
		return formatter
	}
	
	func asCurrencyWith6Decimals()-> String {
		let number = NSNumber(value: self)
		return currencyFormatte6.string(from: number) ?? "0.00"
	}
	
	
	private var currencyFormatte2: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
			//formatter.locale = .current
		
		formatter.currencyCode = "usd"
		formatter.currencyCode = "$"
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}
	
	func asCurrencyWith2Decimals()-> String {
		let number = NSNumber(value: self)
		return currencyFormatte2.string(from: number) ?? "0.00"
	}
	
	func asNumberString() -> String {
		return String(format: "%0.2f", self)
	}
	
	func asPercentString() -> String {
		return asNumberString() + "%"
	}
}
