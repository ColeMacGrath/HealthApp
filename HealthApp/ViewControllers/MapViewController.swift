import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var doctor: Doctor!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsTraffic = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(doctor.direction) { (placemarks, error) in
            if error == nil {
                for placemark in placemarks! {
                    let annotation = MKPointAnnotation()
                    annotation.title = "\(NSLocalizedString("map.address", comment: "")) \(self.doctor.username)"
                    annotation.coordinate = (placemark.location?.coordinate)!
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            } else {
                print("Something wrong: \(String(describing: error?.localizedDescription))")
            }
        }
        
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        imageView.image = doctor.profilePicture
        annotationView?.leftCalloutAccessoryView = imageView
        
        return annotationView
    }
}
