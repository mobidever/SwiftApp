//
//  SampleSwiftUIApp.swift
//  SampleSwiftUI
//
//  Created by PS on 21/03/24.
//

import SwiftUI

@main
struct SampleSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationView{
				HomeView().navigationBarHidden(true)
			}
            ContentView()
        }
    }
}
