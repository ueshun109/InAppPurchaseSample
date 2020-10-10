//
//  CardView.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/10/03.
//

import SwiftUI
import StoreKit

struct CardView: View {
	@ObservedObject var viewModel: CardViewModel
	
	let smoothie: Smoothie
	
	init(viewModel: CardViewModel, smoothie: Smoothie) {
		self.viewModel = viewModel
		self.smoothie = smoothie
	}
	
	var body: some View {
		HStack {
			Image(smoothie.id)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.blur(radius: viewModel.unLock ? 0.0 : 3.0)
				.overlay(
					Image(systemName: "lock.fill")
						.renderingMode(.template)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
						.isHidden(viewModel.unLock)
				)
			HStack {
				Text(smoothie.title)
					.font(.title3)
					.fontWeight(.bold)
					.lineLimit(2)
				Spacer()
				Button(action: {
					viewModel.buy(product: smoothie.id)
				}) {
					VStack {
						Text(viewModel.unLock ? "Purchased" : smoothie.price)
							.fontWeight(.semibold)
							.minimumScaleFactor(0.4)
							.lineLimit(1)
					}
					.padding(.vertical, 4)
					.padding(.horizontal, 16)
					.foregroundColor(.white)
					.background(Color.black)
					.cornerRadius(40)
				}
			}
			.padding()
			Spacer()
		}
	}
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
		CardView(viewModel: .init(download: DownloadProduct.shared, purchase: PurchaseProduct.shared), smoothie: Smoothie.berryBlue)
    }
}

extension View {
	@ViewBuilder func isHidden(_ hidden: Bool) -> some View {
		if hidden {
			self.hidden()
		} else {
			self
		}
	}
}
