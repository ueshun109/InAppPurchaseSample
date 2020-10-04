//
//  HomeView.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/09/25.
//

import SwiftUI
import Combine

struct HomeView: View {
	@ObservedObject var viewModel: HomeViewModel
	
    var body: some View {
		NavigationView {
			ScrollView {
				ForEach(viewModel.smoothies) { smoothie in
					CardView(viewModel: .init(purchase: PurchaseProduct.shared), smoothie: smoothie)
				}
				.padding()
			}
			.navigationBarTitle("Menu")
		}
    }
}



//struct CardView2: View {
//	let dummy = Input(title: "aaa", language: "swift", star: 1, description: "aaaaa", url: "")
//	var body: some View {
//		VStack(alignment: .leading) {
//			Image(systemName: "car")
//				.renderingMode(.original)
//				.resizable()
//				.aspectRatio(contentMode: .fit)
//				.frame(width: 60, height: 60)
//				.clipShape(Circle())
//				.overlay(Circle().stroke(Color.gray, lineWidth: 2))
//				.shadow(color: .gray, radius: 1, x: 0, y: 0)
//
//			Text(dummy.title)
//				.foregroundColor(.black)
//				.font(.title)
//				.fontWeight(.bold)
//
//			HStack {
//				Text(dummy.language ?? "")
//					.font(.footnote)
//					.foregroundColor(.gray)
//				Spacer()
//				HStack(spacing: 4) {
//					Image(systemName: "star")
//						.renderingMode(.template)
//						.foregroundColor(.gray)
//
//					Text(String(dummy.star))
//						.font(.footnote)
//						.foregroundColor(.gray)
//				}
//			}
//			Text(dummy.description ?? "")
//				.foregroundColor(.black)
//				.lineLimit(nil)
//				.fixedSize(horizontal: false, vertical: true)
//		}
//		.padding(24)
//		.overlay(
//			RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1)
//		)
//		.frame(minWidth: 140, minHeight: 180)
//		.padding()
//	}
//}


class News {
	var info: String
	init(info: String) {
		self.info = info
	}
}

class NewsSubscriber: Subscriber {
	typealias Input = Notification
	typealias Failure = Never
	var publisher: NotificationCenter.Publisher
	var subscription: Subscription?
	
	init(notificationPublisher: NotificationCenter.Publisher) {
		self.publisher = notificationPublisher
		self.publisher.subscribe(self)
	}
	
	// publisherがsubscriberを登録すると呼ばれる
	func receive(subscription: Subscription) {
		print(subscription)
		self.subscription = subscription
		subscription.request(.unlimited)
	}
	
	// publisherから要素が送られてくる。配信個数を要求する
	func receive(_ input: Notification) -> Subscribers.Demand {
		let news = input.object as? News
		print(news?.info ?? "")
		// 配信個数に制限なし
		return .max(0)
	}
	
	// 配信が完了したときに呼ばれる
	func receive(completion: Subscribers.Completion<Never>) {
		print("completion")
	}
}

class NewsPublisher {
	let publisher = NotificationCenter.Publisher(center: .default, name: .News, object: nil)
	
	func callAsFunction() {
		let _ = NewsSubscriber(notificationPublisher: publisher)
		publisher.center.post(name: .News, object: News(info: "Info"), userInfo: nil)
	}
}

extension Notification.Name {
	static let News = Notification.Name(("com.combine_intro.news"))
}


struct ActionSheetSample: View {
	@State private var isShowActionSheet = false
	var body: some View {
		Button(action: {
			isShowActionSheet.toggle()
		}) {
			Image(systemName: "car")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 60, height: 60)
		}
		.actionSheet(isPresented: $isShowActionSheet) { () -> ActionSheet in
			ActionSheet(title: Text("交通手段"), message: Text("利用するものを選んでください"), buttons: [
				.default(Text("自動車"), action: { print("自動車") }),
				.default(Text("電車"), action: { print("電車") }),
				.default(Text("徒歩"), action: { print("徒歩") }),
				.cancel(Text("選択しない"), action: { print("選択しない") })
			])
		}
	}
}

struct SheetSample: View {
	@State private var isShow = false
	var body: some View {
		Button(action: {
			isShow.toggle()
		}) {
			Image(systemName: "photo.on.rectangle")
				.resizable()
				.frame(width: 60, height: 60)
		}
		.sheet(isPresented: $isShow) {
			Button(action: {
				isShow.toggle()
			}) {
				Text("Dismiss")
			}
		}
	}
}

struct AlertSample: View {
	@State private var isShowOkAlert = false
	var okAlert = Alert(title: Text("Download success!!"))
	var errorAlert = Alert(title: Text("An error occured"), message: Text("Retry later!"), dismissButton: .default(Text("close")))
	var retryAlert = Alert(title: Text("retry"),
						   message: Text("please retry!"),
						   primaryButton: .default(Text("primary")),
						   secondaryButton: .cancel()
	)
	var body: some View {
		VStack {
			Button(action: {
				self.isShowOkAlert = true
			}) {
				Image(systemName: "square.and.arrow.down")
					.resizable()
					.frame(width: 44, height: 44)
			}
			.alert(isPresented: $isShowOkAlert) { () -> Alert in
				retryAlert
			}
		}
	}
}

struct ScrolllViewSample: View {
	var body: some View {
		ScrollView(.vertical, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
			VStack {
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						FixedRectangle(color: .red)
						FixedRectangle(color: .red)
						FixedRectangle(color: .red)
					}
				}
				ScrollView(.horizontal) {
					HStack {
						FixedRectangle(color: .yellow)
						FixedRectangle(color: .yellow)
						FixedRectangle(color: .yellow)
					}
				}
				ScrollView(.horizontal) {
					HStack {
						FixedRectangle(color: .blue)
						FixedRectangle(color: .blue)
						FixedRectangle(color: .blue)
					}
				}
			}
		}
		.padding()
		.frame(width: UIScreen.main.bounds.width)
	}
}

struct FixedRectangle: View {
	var color: Color
	var body: some View {
		Rectangle()
			.frame(width: 200, height: 100)
			.foregroundColor(color)
			.cornerRadius(20)
	}
}

struct PathView: View {
	var body: some View {
		Path { path in
			path.addLines([
				CGPoint(x: 0, y: 0),
				CGPoint(x: UIScreen.main.bounds.width, y: 0),
				CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3),
				CGPoint(x: 0, y: 0)
			])
		}.fill(Color.red)
	}
}

struct ButtonView: View {
	var body: some View {
		Button(action: {
			print("tapped button")
		}) {
			VStack {
				Image(systemName: "camera")
					.resizable()
					.foregroundColor(.black)
					.aspectRatio(contentMode: .fit)
					.frame(width: 40, height: 40)
				Text("Select photo")
					.foregroundColor(.black)
					.fontWeight(.heavy)
			}
			.frame(width: 150, height: 100)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color.black, lineWidth: 4)
			)
		}
	}
}

struct GeometryRectangle: View {
	var color: Color
	var body: some View {
		GeometryReader { geometry in
			RoundedRectangle(cornerRadius: 20)
				.fill(self.color)
				.overlay(
					VStack {
						Text("X: \(geometry.frame(in: .global).origin.x) Y: \(geometry.frame(in: .global).origin.y) width: \(geometry.frame(in: .global).width) height: \(geometry.frame(in: .global).height)")
							.foregroundColor(.white)
						Text("size: \(geometry.size.debugDescription)").foregroundColor(.white)
					}
				)
		}.frame(height: 100)
	}
}

struct ScrollGeometryView: View {
	var body: some View {
		ScrollView {
			VStack {
				GeometryReader { geometry in
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.pink)
						.overlay(
							Text("Y: \(geometry.frame(in: .global).origin.y)")
								.foregroundColor(.white)
								.fontWeight(.heavy)
								.font(.largeTitle)
						)
				}.frame(height: 100)
				Spacer()
			}
		}
	}
}

struct MinMaxMidView: View {
	var body: some View {
		VStack {
			Text("座標")
			GeometryReader { geometry in
				VStack(alignment: .leading, spacing: 10) {
					Text("Global座標")
					HStack {
						Text("minx: \(Int(geometry.frame(in: .global).minX))")
						Spacer()
						Text("midx: \(Int(geometry.frame(in: .global).midX))")
						Spacer()
						Text("maxx: \(Int(geometry.frame(in: .global).maxX))")
					}
					HStack {
						Text("minY: \(Int(geometry.frame(in: .global).minY))")
						Spacer()
						Text("midY: \(Int(geometry.frame(in: .global).midY))")
						Spacer()
						Text("maxY: \(Int(geometry.frame(in: .global).maxY))")
					}
					Text("Local座標")
					HStack {
						Text("minx: \(Int(geometry.frame(in: .local).minX))")
						Spacer()
						Text("midx: \(Int(geometry.frame(in: .local).midX))")
						Spacer()
						Text("maxx: \(Int(geometry.frame(in: .local).maxX))")
					}
					HStack {
						Text("minY: \(Int(geometry.frame(in: .local).minY))")
						Spacer()
						Text("midY: \(Int(geometry.frame(in: .local).midY))")
						Spacer()
						Text("maxY: \(Int(geometry.frame(in: .local).maxY))")
					}
					HStack {
						Text("width: \(Int(geometry.size.width))")
						Text("height: \(Int(geometry.size.height))")
					}
				}
				Spacer()
			}
			.padding()
			.background(Color.pink)
			.foregroundColor(.white)
			Spacer()
		}
	}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		HomeView(viewModel: .init(download: DownloadProduct.shared))
    }
}
