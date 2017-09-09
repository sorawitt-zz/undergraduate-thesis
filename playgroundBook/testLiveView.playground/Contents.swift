import UIKit
import PlaygroundSupport

class MyLiveView: UIView, PlaygroundLiveViewSafeAreaContainer {}
let liveView = MyLiveView()
liveView.backgroundColor = UIColor.darkGray

let innerView = UIView()
innerView.clipsToBounds = true
innerView.translatesAutoresizingMaskIntoConstraints = false

liveView.addSubview(innerView)

NSLayoutConstraint.activate([
    innerView.leadingAnchor.constraint(equalTo: liveView.liveViewSafeAreaGuide.leadingAnchor),
    innerView.trailingAnchor.constraint(equalTo: liveView.liveViewSafeAreaGuide.trailingAnchor),
    innerView.topAnchor.constraint(equalTo: liveView.liveViewSafeAreaGuide.topAnchor),
    innerView.bottomAnchor.constraint(equalTo: liveView.liveViewSafeAreaGuide.bottomAnchor)
    ])

PlaygroundPage.current.liveView = liveView