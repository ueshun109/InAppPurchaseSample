//
//  HomeView.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/09/25.
//

import SwiftUI

struct HomeView: View {
	@ObservedObject var viewModel: HomeViewModel
	
    var body: some View {
		NavigationView {
			ScrollView {
				ForEach(viewModel.smoothies) { smoothie in
					CardView(viewModel: .init(download: DownloadProduct.shared, purchase: PurchaseProduct.shared), smoothie: smoothie)
				}
				.padding()
			}
			.navigationBarTitle("Menu")
			.navigationBarItems(trailing: Button(action: {
				viewModel.startSubscription()
			}) {
				Text("Subscription")
			})
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		HomeView(viewModel: .init(download: DownloadProduct.shared, purchase: PurchaseProduct.shared))
    }
}
