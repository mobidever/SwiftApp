//
//  Color.swift
//  SampleSwiftUI
//
//  Created by PS on 22/03/24.
//

import Foundation
import SwiftUI

extension Color {
	
	static let theme = ColorTheme()
}

struct ColorTheme {
	
	let accent = Color("AccentColour")
	let background = Color("BackgroundColour")
	let green  = Color("GreenColour")
	let red = Color("RedColour")
	let secondaryTextColor = Color("SecondaryTextColour")
}
