import UIKit
import CoreLocation

class ViewController: UIViewController {

@IBOutlet weak var cityNameLabel: UILabel!

@IBOutlet weak var weatherDescriptionLabel: UILabel!

@IBOutlet weak var temperatureLabel: UILabel!

@IBOutlet weak var weatherIconImageView: UIImageView!

let locationManager = CLLocationManager()
var weatherData = WeatherData()

override func viewDidLoad() {
super.viewDidLoad()
startLocationManager()
}
func startLocationManager() {
locationManager.requestWhenInUseAuthorization()
DispatchQueue.global().async {
if CLLocationManager.locationServicesEnabled() {

self.locationManager.delegate = self
self.locationManager.desiredAccuracy =
kCLLocationAccuracyHundredMeters
self.locationManager.pausesLocationUpdatesAutomatically = false
self.locationManager.startUpdatingLocation()
}
}
}

    
func updateView() {
cityNameLabel.text = weatherData.name
weatherDescriptionLabel.text = DataSource.weatherIDs
[weatherData.weather[0].id]
temperatureLabel.text = weatherData.main.temp.description + "°"
weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
}

func updateWeatherInfo(latitude: Double, longitude: Double) {
let session = URLSession.shared
let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon= \(longitude.description)&units=metric&lang=ru&appid=740cdb10e250e1eff9b980fcf8f7c0dc")!
let task = session.dataTask(with: url) { (data, response, error) in guard error == nil
    else { print("DataTask error: \(error!.localizedDescription)")
    return
}
do { self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
DispatchQueue.main.async {
self.updateView()
}
}
    
catch {
print(error.localizedDescription)
}
}
    
task.resume()
}
}

extension ViewController: CLLocationManagerDelegate {
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
if let lastLocation = locations.last {
updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
}
}
}
