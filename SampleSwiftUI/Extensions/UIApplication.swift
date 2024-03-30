//
//  UIApplication.swift
//  SampleSwiftUI
//
//  Created by PS on 30/03/24.
//

import Foundation
import SwiftUI

extension UIApplication {

	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}

}
