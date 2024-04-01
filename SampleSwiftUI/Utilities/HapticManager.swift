//
//  HapticManager.swift
//  SampleSwiftUI
//
//  Created by PS on 01/04/24.
//

import Foundation
import SwiftUI


class HapticManager {
	
	static private let generator = UINotificationFeedbackGenerator()
	
	static func notification(type: UINotificationFeedbackGenerator.FeedbackType)
	{
		generator.notificationOccurred(type)
	}


}
