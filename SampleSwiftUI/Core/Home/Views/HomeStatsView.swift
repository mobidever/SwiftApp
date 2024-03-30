//
//  HomeStatsView.swift
//  SampleSwiftUI
//
//  Created by PS on 30/03/24.
//

import SwiftUI

struct HomeStatsView: View {
	
//	let statistics: [StatisticModel] = [
//		StatisticModel(title: "title", value: "value", percentageChange: 1),
//		StatisticModel(title: "title", value: "value"),
//		StatisticModel(title: "title", value: "value", percentageChange: -7)
//		
//	]
	
	@EnvironmentObject private var vm: HomeViewModel
	
	@Binding var showPortfolio: Bool
	
    var body: some View {
		HStack{
			
			ForEach(vm.statistics) { stat in
					StatisticsView(stat: stat)
					.frame(width: UIScreen.main.bounds.width/3)
			}
		}.frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
	HomeStatsView(showPortfolio: .constant(false)).environmentObject(DeveloperPreview.instance.homeVM)
}
