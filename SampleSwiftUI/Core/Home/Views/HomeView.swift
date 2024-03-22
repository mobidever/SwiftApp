//
//  HomeView.swift
//  SampleSwiftUI
//
//  Created by PS on 22/03/24.
//

import SwiftUI

struct HomeView: View {
	
	@State private var showPortfolio : Bool = false
	
    var body: some View {
		ZStack{
			Color.theme.background.ignoresSafeArea()
			
			VStack (content: {
				homeHeader
				Spacer(minLength: 0)
			})
		}
    }
}

#Preview {
	HomeView().navigationBarHidden(true)
}

extension HomeView {
	
	private var homeHeader: some View {
		
		HStack{
			CircleButtonView(iconName: showPortfolio ? "plus" : "info")
				.background{
					CircleButtonAnimationView(animate: $showPortfolio)
				}
			Spacer()
			Text(showPortfolio ? "Portfolio" : "Live Prices" )
				.font(.headline)
				.fontWeight(.heavy)
				.foregroundStyle(Color.theme.accent)
			Spacer()
			CircleButtonView(iconName: "chevron.right")
				.rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
				.onTapGesture {
					withAnimation(.spring()){
						showPortfolio.toggle()
					}
				}
		}
		.padding(.horizontal)
	}
}
