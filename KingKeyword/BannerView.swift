//
//  BannerView.swift
//  KingKeyword
//
//  Created by 이보라 on 2022/11/25.
//

import SwiftUI
import GoogleMobileAds

final class BannerViewController: UIViewController {
    
    var adUnitID: String? {
        get { bannerView.adUnitID }
        set { bannerView.adUnitID = newValue }
    }
    
    private var bannerView = GADBannerView(adSize: GADAdSizeBanner)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        bannerView.load(GADRequest())
    }
}

extension BannerViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}

struct BannerAdView: UIViewControllerRepresentable {
    let adUnitID: String

    init(adUnitID: String = "ca-app-pub-8909845574938855/8882950548") {
        self.adUnitID = adUnitID
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = BannerViewController()
        vc.adUnitID = adUnitID
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
