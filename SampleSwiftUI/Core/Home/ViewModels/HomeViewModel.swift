//
//  HomeViewModel.swift
//  SampleSwiftUI
//
//  Created by PS on 23/03/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
	
	private let dataService = CoinDataService()
	
	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []
	
	private var cancellables = Set<AnyCancellable>()
	init() {
		addSubscribers()
//		DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
//			self.allCoins.append(DeveloperPreview.instance.coin)
//			self.portfolioCoins.append(DeveloperPreview.instance.coin)
//		}
	}
	
	func addSubscribers(){
		
		dataService.$allCoins
			.sink { [weak self] (returnedCoins) in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
	}
	
}
