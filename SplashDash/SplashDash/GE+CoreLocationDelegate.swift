//
//  GE+CoreLocationDelegate.swift
//  SplashDash
//
//  Created by Tong Lin on 3/1/17.
//  Copyright © 2017 SHT. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

extension GameViewController: CLLocationManagerDelegate{
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        //the average human can run at the speed of 15 miles per hour for short periods of time.
        if self.gameStatus{
            var currentSpeed = location.speed as Double
            if currentSpeed < 0 {
                currentSpeed = Double(arc4random_uniform(500) + 500)/100
            }
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            print(currentSpeed)
            print(location.timestamp.timeIntervalSince1970)
            print("")
            let currentUser = FIRAuth.auth()?.currentUser?.uid
            let coordinate = SplashCoordinate(userID: currentUser!, midCoordinate: location.coordinate, speed: currentSpeed, teamName: "Wolfpack", splashImageTag: 1)
            
            //push coordinate to firebase
            self.currentRun.append(coordinate)
            pushSplashToDatabase(coor: coordinate)
//            let splash = SplashOverlay(park: coordinate)
//            mapView.addOverlays([splash])
        }
    }
}
