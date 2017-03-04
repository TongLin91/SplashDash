//
//  GE+SnapKit.swift
//  SplashDash
//
//  Created by Tong Lin on 3/1/17.
//  Copyright © 2017 SHT. All rights reserved.
//

import UIKit
import SnapKit

extension GameViewController{
    
    func configureConstraints(){
        rootView.snp.remakeConstraints { (view) in
            view.top.bottom.leading.trailing.equalToSuperview()
        }
        
        mapView.snp.remakeConstraints { (view) in
            view.top.bottom.leading.trailing.equalToSuperview()
        }
        
        gameButton.snp.remakeConstraints { (view) in
            view.bottom.equalToSuperview().offset(-80)
            view.trailing.equalToSuperview().offset(-30)
            view.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        findMeButton.snp.remakeConstraints { (view) in
            view.trailing.equalTo(gameButton)
            view.bottom.equalTo(gameButton.snp.top).offset(-40)
            view.size.equalTo(CGSize(width: 70, height: 70))
        }
    }
}
