import UIKit
import CoreLocation
import MapKit

class TakipScreen: UIViewController {
    var locationManager = CLLocationManager()
    var courierLocation = CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784) // İstanbul Koordinatları
    var fixedLocation = CLLocationCoordinate2D(latitude: 41.0422, longitude: 29.0094) // Sabit Lokasyon Koordinatları
    var courierAnnotation: MKPointAnnotation!
    var fixedAnnotation: MKPointAnnotation!

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        addCourierAnnotation()
        addFixedAnnotation()
        updateCourierLocation()

        // Her iki pini de görebilecek bir bölge oluştur
        let courierLocationCoord = CLLocation(latitude: courierLocation.latitude, longitude: courierLocation.longitude).coordinate
        let fixedLocationCoord = CLLocation(latitude: fixedLocation.latitude, longitude: fixedLocation.longitude).coordinate
        let regionCenter = CLLocationCoordinate2D(latitude: (courierLocationCoord.latitude + fixedLocationCoord.latitude) / 2, longitude: (courierLocationCoord.longitude + fixedLocationCoord.longitude) / 2)
        let region = MKCoordinateRegion(center: regionCenter, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }

    func addCourierAnnotation() {
        courierAnnotation = MKPointAnnotation()
        courierAnnotation.coordinate = courierLocation
        courierAnnotation.title = "Kurye"
        courierAnnotation.subtitle = "Hareket Ediyor"
        mapView.addAnnotation(courierAnnotation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let annotationView = self.mapView.view(for: self.courierAnnotation) as? MKMarkerAnnotationView {
                annotationView.markerTintColor = UIColor.systemGreen
                annotationView.glyphImage = UIImage(named: "kurye") // Kurye pin resmi
                print("MKMarkerAnnotationView çalıştı")
            }
        }
    }




    



    func addFixedAnnotation() {
        fixedAnnotation = MKPointAnnotation()
        fixedAnnotation.coordinate = fixedLocation
        fixedAnnotation.title = "Teslimat adresi"
        mapView.addAnnotation(fixedAnnotation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let annotationView = self.mapView.view(for: self.fixedAnnotation) as? MKMarkerAnnotationView {
                annotationView.markerTintColor = UIColor.systemGreen
                annotationView.glyphImage = UIImage(named: "home") // Kurye pin resmi
                print("MKMarkerAnnotationView çalıştı")
            }
        }
    }

    func updateCourierLocation() {
        let courierLocationCLLocation = CLLocation(latitude: courierLocation.latitude, longitude: courierLocation.longitude)
        let fixedLocationCLLocation = CLLocation(latitude: fixedLocation.latitude, longitude: fixedLocation.longitude)
        
        let distance = courierLocationCLLocation.distance(from: fixedLocationCLLocation)
        let duration: TimeInterval = 0.1 // Saniyede 5 birim hızla hareket et

        let steps = Int(distance / (duration * 5)) // 5 birim adımda bir güncelleme yap

        var step = 0

        Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { timer in
            guard step < steps else {
                timer.invalidate()
                return
            }

            let stepLat = (self.fixedLocation.latitude - self.courierLocation.latitude) / Double(steps)
            let stepLon = (self.fixedLocation.longitude - self.courierLocation.longitude) / Double(steps)

            self.courierLocation.latitude += stepLat
            self.courierLocation.longitude += stepLon
            self.courierAnnotation.coordinate = self.courierLocation

            step += 1
        }
    }


    @IBAction func buttonKapat(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
    }
}

extension TakipScreen: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Kuryenin gerçek zamanlı konumunu almak istiyorsanız burada kullanabilirsiniz.
    }
}
