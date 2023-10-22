import UIKit
import MapKit

class AdresScreen: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectAddressButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupUI()
        addPinToMapView()
    }

    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    func setupUI() {
        selectAddressButton.layer.cornerRadius = 8
        selectAddressButton.addTarget(self, action: #selector(selectAddressButtonTapped), for: .touchUpInside)
    }

    @objc func selectAddressButtonTapped() {
        // Kullanıcının seçtiği adresi kullanmak için burada gerekli işlemleri yapabilirsin.
        // Örneğin, konumu alabilir ve bu konumu kullanarak işlemler yapabilirsin.
        // Ayrıca, bu adım için harita delegesi olan `didSelectAnnotationView` fonksiyonunu kullanabilirsin.
    }

    func addPinToMapView() {
        // İstanbul'un koordinatları
        let istanbulCoordinate = CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784)
        let annotation = MKPointAnnotation()
        annotation.coordinate = istanbulCoordinate
        annotation.title = "İstanbul"
        mapView.addAnnotation(annotation)

        // Konumu yakınlaştır
        let region = MKCoordinateRegion(center: istanbulCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }

    @IBAction func buttonKapat(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AdresScreen: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Haritada bir konum seçildiğinde bu fonksiyon çağrılır.
        // Bu noktada, kullanıcının seçtiği konumu alabilir ve kullanabilirsin.
    }
}
