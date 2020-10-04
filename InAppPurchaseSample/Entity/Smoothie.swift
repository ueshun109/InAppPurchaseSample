//
//  Smoothie.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/09/25.
//

import Foundation
import StoreKit

struct Smoothie: Identifiable {
	var id: String
	var title: String
	var price: String
}

extension Smoothie {
	static let all: [Smoothie] = [
		.berryBlue,
		.carrotChops,
		.hulkingLemonade,
		.crazyColada,
		.kiwiCutie,
		.lemonberry,
		.loveYouBerryMuch,
		.mangoJambo,
		.oneInAMelon,
		.peanutButterCup,
		.papasPapaya,
		.sailorMan,
		.thatsASmore,
		.thatsBerryBananas,
		.tropicalBlue
	]
	
	static let allIDs: [Smoothie.ID] = all.map { $0.id }
	
	static let berryBlue = Smoothie(id: "berry-blue", title: "Berry Blue", price: "500")
	static let carrotChops = Smoothie(id: "carrot-chops", title: "Carrot Chops", price: "500")
	static let crazyColada = Smoothie(id: "crazy-colada", title: "Crazy Colada", price: "500")
	static let hulkingLemonade = Smoothie(id: "hulking-lemonade", title: "Hulking Lemonade", price: "500")
	static let kiwiCutie = Smoothie(id: "kiwi-cutie", title: "Kiwi Cutie", price: "500")
	static let lemonberry = Smoothie(id: "lemonberry", title: "Lemonberry", price: "500")
	static let loveYouBerryMuch = Smoothie(id: "love-you-berry-much", title: "Love You Berry Much", price: "500")
	static let mangoJambo = Smoothie(id: "mango-jambo", title: "Mango Jambo", price: "500")
	static let oneInAMelon = Smoothie(id: "one-in-a-melon", title: "One in a Melon", price: "500")
	static let papasPapaya = Smoothie(id: "papas-papaya", title: "Papa's Papaya", price: "500")
	static let peanutButterCup = Smoothie(id: "peanut-butter-cup", title: "Peanut Butter Cup", price: "500")
	static let sailorMan = Smoothie(id: "sailor-man", title: "Sailor Man", price: "500")
	static let thatsASmore = Smoothie(id: "thats-a-smore", title: "That's a Smore!", price: "500")
	static let thatsBerryBananas = Smoothie(id: "thats-berry-bananas", title: "That's Berry Bananas!", price: "500")
	static let tropicalBlue = Smoothie(id: "tropical-blue", title: "Tropical Blue", price: "500")
}

extension Smoothie: Hashable {
	static func == (lhs: Smoothie, rhs: Smoothie) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
