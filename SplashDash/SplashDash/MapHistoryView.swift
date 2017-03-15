//
//  MapHistoryView.swift
//  SplashDash
//
//  Created by Sabrina Ip on 3/5/17.
//  Copyright © 2017 SHT. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import SnapKit

class MapHistoryView: UIView, MKMapViewDelegate {
    //MARK: - Properties
    var regionCalculations: (minLat: CLLocationDegrees, minLong: CLLocationDegrees, maxLat: CLLocationDegrees, maxLong: CLLocationDegrees)!
    var datePickerDate: String!
    var databaseReference: FIRDatabaseReference!
    var splashOverlays: [SplashOverlay] = [] {
        didSet {
            self.mapSliderView.slider.maximumValue = Float(self.splashOverlays.count - 1)
            print(self.mapSliderView.slider.maximumValue)
        }
    }
    
    let calendar: Calendar = Calendar.current
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.splashOverlays = []
        
        setupViewHierarchy()
        configureConstraints()
        setUpMapViewLocation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    func datePickerChanged(_ sender: UIDatePicker) {
        let selectedDate = self.datePicker.date
        self.datePickerDate = returnFormattedDate(date: selectedDate)
        
        if let date = self.datePickerDate {
            fetchSplashForPickerDate(date: date)
        }
    }
    
    func returnFormattedDate(date: Date) -> String {
        //Formatting date string
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        
        return format.string(from: date)
    }
    
    //MARK: - Setup Views
    func setupViewHierarchy() {
        self.addSubview(mapSliderView)
        self.addSubview(datePicker)
        self.addSubview(monthUpCaretLabel)
        self.addSubview(monthDownCaretLabel)
        self.addSubview(dateUpCaretLabel)
        self.addSubview(dateDownCaretLabel)
        self.addSubview(yearUpCaretLabel)
        self.addSubview(yearDownCaretLabel)
    }
    
    func configureConstraints() {
        monthUpCaretLabel.snp.remakeConstraints { (view) in
            view.centerX.equalToSuperview().multipliedBy(0.45)
            view.top.equalToSuperview()
            view.bottom.equalTo(datePicker.snp.top).offset(8.0)
        }
        
        monthDownCaretLabel.snp.remakeConstraints { (view) in
            view.centerX.equalToSuperview().multipliedBy(0.45)
            view.top.equalTo(datePicker.snp.bottom).inset(8.0)
        }
        
        dateUpCaretLabel.snp.remakeConstraints { (view) in
            view.centerX.equalToSuperview().multipliedBy(1.13)
            view.top.equalToSuperview()
            view.bottom.equalTo(datePicker.snp.top).offset(8.0)
        }
        
        dateDownCaretLabel.snp.remakeConstraints { (view) in
            view.centerX.equalToSuperview().multipliedBy(1.13)
            view.top.equalTo(datePicker.snp.bottom).inset(8.0)
        }
        
        yearUpCaretLabel.snp.remakeConstraints { (view) in
            view.centerX.equalToSuperview().multipliedBy(1.55)
            view.top.equalToSuperview()
            view.bottom.equalTo(datePicker.snp.top).offset(8.0)
        }
        
        yearDownCaretLabel.snp.remakeConstraints { (view) in
            view.centerX.equalToSuperview().multipliedBy(1.55)
            view.top.equalTo(datePicker.snp.bottom).inset(8.0)
        }
        
        datePicker.snp.remakeConstraints { (view) in
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(50)
        }
        
        mapSliderView.snp.remakeConstraints { (view) in
            view.leading.trailing.bottom.equalToSuperview()
            //            view.top.equalTo(datePicker.snp.bottom).offset(8.0)
            view.top.equalTo(yearDownCaretLabel.snp.bottom).offset(16.0)
        }
    }
    
    func setUpMapViewLocation() {
        //load mapview for the current date selected on the picker
        let oneDayAgo: Date = calendar.date(byAdding: .day, value: -1, to: Date())!
        self.datePickerDate = returnFormattedDate(date: oneDayAgo)
        fetchSplashForPickerDate(date: self.datePickerDate)
        
        //40.730043, -73.991250
        let center = CLLocationCoordinate2D(latitude: 40.730043, longitude: -73.991250) //40.751085, -73.984946
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        self.mapSliderView.mapView.setRegion(region, animated: false)
    }

    func fetchSplashForPickerDate(date: String){
        //Remove all current overlay views prior to populating the map
        self.mapSliderView.mapView.removeOverlays(self.mapSliderView.mapView.overlays)
        
        //Setting database reference to date selected from datePicker
        guard let date = self.datePickerDate else { return }
        self.databaseReference = FIRDatabase.database().reference().child("Public/\(date)")
        
        var overlays: [SplashOverlay] = []
        
//        self.databaseReference.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
//            let enumerator = snapshot.children
//            while let child = enumerator.nextObject() as? FIRDataSnapshot {
//                
//                if let value = child.value as? NSDictionary {
//                    if let splashCoor = SplashCoordinate(value) {
//                        
//                        //draw all splashes parsed from database
//                        let splash = SplashOverlay(coor: splashCoor)
//                        overlays.append(splash)
//                        
//                        self.splashOverlays = overlays
//                    }
//                }
//            }
//            self.mapSliderView.mapView.addOverlays(self.splashOverlays)
//        }
        
        let chronologicalQuery = self.databaseReference.queryOrderedByKey()
        chronologicalQuery.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FIRDataSnapshot {
                
                if let value = child.value as? NSDictionary {
                    if let splashCoor = SplashCoordinate(value) {
                        
                        //draw all splashes parsed from database
                        let splash = SplashOverlay(coor: splashCoor)
                        overlays.append(splash)
                        
                        self.splashOverlays = overlays
                    }
                }
            }
            self.mapSliderView.mapView.addOverlays(self.splashOverlays)
        }
    }
    
    //MARK: - MKMap Delegate Methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let myOverlay = overlay as? SplashOverlay{
            let splashOverlay = SplashOverlayView(overlay: myOverlay, teamName: myOverlay.teamName, splashImageTag: myOverlay.splashImageTag)
            return splashOverlay
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
//    func setMapPinAndRegion() {
//        mapView.removeAnnotations(mapView.annotations)
//        for (index, request) in requests.enumerated() {
//            guard let coordinates = request.coordinates else { continue }
//            
//            let pinAnnotation = RequestMKPointAnnotation()
//            pinAnnotation.coordinate = coordinates
//            
//            if let address = request.incidentAddress {
//                pinAnnotation.title = address
//            } else {
//                pinAnnotation.title = request.createdDate
//            }
//            
//            pinAnnotation.subtitle = request.descriptor
//            
//            pinAnnotation.index = index
//            mapView.addAnnotation(pinAnnotation)
//            
//            if let calc = regionCalculations {
//                if coordinates.latitude < calc.minLat {
//                    regionCalculations?.minLat = coordinates.latitude
//                }
//                if coordinates.latitude > calc.maxLat {
//                    regionCalculations?.maxLat = coordinates.latitude
//                }
//                if coordinates.longitude < calc.minLong {
//                    regionCalculations?.minLong = coordinates.longitude
//                }
//                if coordinates.longitude > calc.maxLong {
//                    regionCalculations?.maxLong = coordinates.longitude
//                }
//            } else {
//                regionCalculations = (minLat: coordinates.latitude, minLong: coordinates.longitude, maxLat: coordinates.latitude, maxLong: coordinates.longitude)
//            }
//            
//            guard let calc = regionCalculations else { return }
//            
//            let midLat = (calc.maxLat + calc.minLat) / 2
//            let midLong = (calc.maxLong + calc.minLong) / 2
//            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(midLat), longitude: CLLocationDegrees(midLong))
//            
//            let latSpan = calc.maxLat - calc.minLat
//            let longSpan = calc.maxLong - calc.minLong
//            
//            let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(latSpan), longitudeDelta: CLLocationDegrees(longSpan))
//            
//            let mkCoordinateRegion = MKCoordinateRegion(center: center, span: span)
//            
//            self.mapView.setRegion(mkCoordinateRegion, animated: true)
//        }
//
//    }
    
    //MARK: - Views
    lazy var mapSliderView: MapSliderView = {
        let view = MapSliderView()
        view.mapView.delegate = self
        
        return view
    }()

    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.setValue(UIColor.white, forKey: "textColor")
        
        //Max date should always be yesterday
        let calendar = Calendar.current
        let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: Date())
        
        //Min date should be 03/10/17 since this is the first day that we have data for
        var dateComponent = DateComponents()
        dateComponent.year = 2017
        dateComponent.month = 03
        dateComponent.day = 10
        let date = Calendar(identifier: Calendar.Identifier.gregorian).date(from: dateComponent)
        
        dp.datePickerMode = .date
        dp.maximumDate = oneDayAgo
        dp.minimumDate = date
        dp.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        return dp
    }()
    
    lazy var monthUpCaretLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "^"
        
        return label
    }()
    
    lazy var monthDownCaretLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.white
        label.text = "^"
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        return label
    }()
    
    lazy var dateUpCaretLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "^"
        
        return label
    }()
    
    lazy var dateDownCaretLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "^"
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        return label
    }()
    
    lazy var yearUpCaretLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "^"
        
        return label
    }()
    
    lazy var yearDownCaretLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "^"
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        return label
    }()
}
