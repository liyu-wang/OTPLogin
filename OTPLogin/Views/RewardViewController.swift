//
//  RewardViewController.swift
//  OTPLogin
//
//  Created by Liyu Wang on 4/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class RewardViewController: UIViewController {

    var viewModel: RewardViewModel! = RewardViewModel()
    
    private let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configAnimationView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animationView.play(
            fromProgress: 0,
            toProgress: 1,
            loopMode: LottieLoopMode.loop,
            completion: { (finished) in
                if finished {
                    print("Animation Complete")
                } else {
                    print("Animation cancelled")
                }
            }
        )
    }
    
}

// MARK: - UI

extension RewardViewController {
    
    private func configAnimationView() {
        guard let animation = Animation.named("1138-deer", subdirectory: nil) else { return }
        
        self.animationView.animation = animation
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.animationView)
        
        NSLayoutConstraint.activate([
            self.animationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.animationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.animationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.animationView.heightAnchor.constraint(equalTo: self.animationView.widthAnchor, multiplier: animation.size.height / animation.size.width)
        ])
    }
    
}
