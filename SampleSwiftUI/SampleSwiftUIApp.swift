//
//  SampleSwiftUIApp.swift
//  SampleSwiftUI
//
//  Created by PS on 21/03/24.
//

import SwiftUI

@main
struct SampleSwiftUIApp: App {
	
	@StateObject var vm = HomeViewModel()
	
    var body: some Scene {
        WindowGroup {
			NavigationView{
				HomeView().navigationBarHidden(true)
			}
			.environmentObject(vm)
            //ContentView()
        }
    }
}
