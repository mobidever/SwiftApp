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
	@Published var searchText = ""
	init() {
		addSubscribers()
//		DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
//			self.allCoins.append(DeveloperPreview.instance.coin)
//			self.portfolioCoins.append(DeveloperPreview.instance.coin)
//		}
	}
	
	func addSubscribers(){
		
//		dataService.$allCoins
//			.sink { [weak self] (returnedCoins) in
//				self?.allCoins = returnedCoins
//			}
//			.store(in: &cancellables)
		
		$searchText.combineLatest(dataService.$allCoins)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.map(filterCoins)
			.sink { [weak self] (returnedCoins) in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
			
	}
	
	private func filterCoins(text: String, coins: [CoinModel]) ->  [CoinModel] {
		
		guard !text.isEmpty else {
			return coins
		}
		let lowerCaseText = text.lowercased()
		
		let filteredCoins = coins.filter { (coin) in
			return coin.name.lowercased().contains(lowerCaseText) ||
			coin.symbol.lowercased().contains(lowerCaseText) ||
			coin.id.lowercased().contains(lowerCaseText)
		}
		
		return filteredCoins
		
	}
	
}
