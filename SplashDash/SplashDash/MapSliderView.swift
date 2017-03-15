//
//  MapSliderView.swift
//  SplashDash
//
//  Created by Harichandan Singh on 3/15/17.
//  Copyright © 2017 SHT. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapSliderview: UIView {
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViewHierarchy()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Methods
    func setUpViewHierarchy() {
        self.addSubview(mapView)
        self.addSubview(sliderContainerView)
        self.addSubview(slider)
        
        self.layer.cornerRadius = 8
    }
    
    func configureConstraints() {
        mapView.snp.makeConstraints { (view) in
            view.leading.top.trailing.equalToSuperview()
        }
        
        sliderContainerView.snp.makeConstraints { (view) in
            view.top.equalTo(mapView.snp.bottom)
            view.leading.trailing.bottom.equalToSuperview()
        }
        
        slider.snp.makeConstraints { (view) in
            view.centerX.centerY.equalTo(sliderContainerView)
            view.leading.equalToSuperview().offset(8.0)
            view.trailing.equalToSuperview().inset(8.0)
        }
    }
    
    //MARK: - Views
    lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .standard
        //        view.isUserInteractionEnabled = false
        view.showsScale = true
        view.showsCompass = true
        view.showsBuildings = false
        view.showsPointsOfInterest = false
        view.showsCompass = false
        view.delegate = self
        
        return view
    }()
    
    lazy var sliderContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = SplashColor.primaryColor()
        slider.backgroundColor = UIColor.lightGray
        
        return slider
    }()
}
