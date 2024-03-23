//
//  HomeViewModel.swift
//  SampleSwiftUI
//
//  Created by PS on 23/03/24.
//

import Foundation

class HomeViewModel: ObservableObject {
	
	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []
	
	init() {
		DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
			self.allCoins.append(DeveloperPreview.instance.coin)
			self.portfolioCoins.append(DeveloperPreview.instance.coin)
		}
	}
	
}
