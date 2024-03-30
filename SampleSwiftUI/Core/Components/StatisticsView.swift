//
//  StatisticsView.swift
//  SampleSwiftUI
//
//  Created by PS on 30/03/24.
//

import SwiftUI

struct StatisticsView: View {
	
	let stat: StatisticModel
	
    var body: some View {
		VStack(alignment: .leading, content: {
			Text(stat.title)
				.font(.caption)
				.foregroundStyle(Color.theme.secondaryTextColor)
			Text(stat.value)
				.font(.headline)
				.foregroundStyle(Color.theme.accent)
			HStack(spacing: 4) {
				Image(systemName: "triangle.fill")
					.font(.caption2)
					.rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
				Text(stat.percentageChange?.asPercentString() ?? "")
					.font(.caption)
				.bold()
			}.foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red )
				.opacity((stat.percentageChange == nil ? 0.0 : 1.0))
		})
    }
}

#Preview {
	Group{
		StatisticsView(stat: DeveloperPreview.instance.stat3)
			.previewLayout(.sizeThatFits)
		StatisticsView(stat: DeveloperPreview.instance.stat1)
			.previewLayout(.sizeThatFits)
		StatisticsView(stat: DeveloperPreview.instance.stat2)
			.previewLayout(.sizeThatFits)
	}
	
}
