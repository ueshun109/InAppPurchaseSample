//
//  Smoothie.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/09/25.
//

import Foundation

struct Smoothie: Identifiable {
	var id: String
	var title: String
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
	
	static let berryBlue = Smoothie(id: "recipe.berry-blue", title: "Berry Blue")
	static let carrotChops = Smoothie(id: "recipe.carrot-chops", title: "Carrot Chops")
	static let crazyColada = Smoothie(id: "recipe.crazy-colada", title: "Crazy Colada")
	static let hulkingLemonade = Smoothie(id: "recipe.hulking-lemonade", title: "Hulking Lemonade")
	static let kiwiCutie = Smoothie(id: "recipe.kiwi-cutie", title: "Kiwi Cutie")
	static let lemonberry = Smoothie(id: "recipe.lemonberry", title: "Lemonberry")
	static let loveYouBerryMuch = Smoothie(id: "recipe.love-you-berry-much", title: "Love You Berry Much")
	static let mangoJambo = Smoothie(id: "recipe.mango-jambo", title: "Mango Jambo")
	static let oneInAMelon = Smoothie(id: "recipe.one-in-a-melon", title: "One in a Melon")
	static let papasPapaya = Smoothie(id: "recipe.papas-papaya", title: "Papa's Papaya")
	static let peanutButterCup = Smoothie(id: "recipe.peanut-butter-cup", title: "Peanut Butter Cup")
	static let sailorMan = Smoothie(id: "recipe.sailor-man", title: "Sailor Man")
	static let thatsASmore = Smoothie(id: "recipe.thats-a-smore", title: "That's a Smore!")
	static let thatsBerryBananas = Smoothie(id: "recipe.thats-berry-bananas", title: "That's Berry Bananas!")
	static let tropicalBlue = Smoothie(id: "recipe.tropical-blue", title: "Tropical Blue")
}

extension Smoothie: Hashable {
	static func == (lhs: Smoothie, rhs: Smoothie) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
