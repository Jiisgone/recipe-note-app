//
//  GroceryViewController.swift
//  RecipeNoteApp
//
//  Created by Julian Sanchez on 2022-05-24.
//

import UIKit
import CoreLocation
import MapKit

class GroceryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var groceryTable: UITableView!
    
    //MARK: Location Manager
    var locationManager:CLLocationManager!
    
    //MARK: Properties
    var groceriesFound:[MKMapItem] = [MKMapItem]()
//    var groceriesFound:[String] = ["1", "2", "3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groceryTable.dataSource = self
        self.groceryTable.delegate = self

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        //perms
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        //configure map
        let centerOfMapCoordinate = CLLocationCoordinate2D(latitude: 37.3319, longitude: -122.0302)
        let zoomLevel = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let visibleRegion = MKCoordinateRegion(center: centerOfMapCoordinate, span: zoomLevel)
        self.mapView.setRegion(visibleRegion, animated: true)

        self.mapView.showsUserLocation = true
        
        self.groceryTable.rowHeight = 80

//        self.nearbyGroceries()
        
        
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groceriesFound.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as! GroceryTableViewCell

        // Configure the cell...
        
        if indexPath.row < groceriesFound.count{
            
            let nearbyGrocery  = self.groceriesFound[indexPath.row]
            
            cell.groceryNameLbl.text = nearbyGrocery.name
            cell.groceryPhoneLbl.text = nearbyGrocery.phoneNumber
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row clicked")


    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastKnownLocation =  locations.first {
            let lat = lastKnownLocation.coordinate.latitude
            let lng = lastKnownLocation.coordinate.longitude
            print("Current location: \(lat), \(lng), current speed: \(lastKnownLocation.speed)")

            // 2. update the visible map region to match where the user is
            let updatedCenterOfMapCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let updatedVisibleRegion = MKCoordinateRegion(center: updatedCenterOfMapCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            self.mapView.setRegion(updatedVisibleRegion, animated:true)
            print(mapView.region)

        }

        self.nearbyGroceries()

    }

    func nearbyGroceries(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Supermarket"
        request.region = mapView.region
        print("REGION")
        print(request.region)

        let search = MKLocalSearch(request: request)
            search.start(completionHandler: {(response, error) in
                if error != nil {
                    print("Error occured in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    self.groceriesFound.removeAll()
                    self.groceriesFound = response!.mapItems
                    
                    for item in response!.mapItems {

                        var markerToAdd = MKPointAnnotation()
                        markerToAdd.coordinate = item.placemark.coordinate
                        markerToAdd.title = item.name
                        self.mapView.addAnnotation(markerToAdd)
                        self.groceryTable.reloadData()
                }
            }
        })
    }
    

}
