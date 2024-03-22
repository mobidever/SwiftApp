//
//  ContentView.swift
//  SampleSwiftUI
//
//  Created by PS on 21/03/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		
		ZStack{
			Color.theme.background.ignoresSafeArea()
			VStack {
				Image(systemName: "globe")
					.imageScale(.large)
					.foregroundStyle(.tint)
				Text("Hello, world!").foregroundStyle(.primary)
				Text("Hello, world!").foregroundStyle(.secondary)
				Text("Hello, world!").foregroundStyle(.tertiary)
				Text("Hello, world!").foregroundStyle(.quaternary)
				
				Text("Hello, world!").foregroundStyle(Color.theme.red)
				Text("Hello, world!").foregroundStyle(Color.theme.accent)
				Text("Hello, world!").foregroundStyle(Color.theme.green)
			}.background(Color.theme.secondaryTextColor)
			.padding()
		}
        
    }
}

#Preview {
    ContentView()
}
