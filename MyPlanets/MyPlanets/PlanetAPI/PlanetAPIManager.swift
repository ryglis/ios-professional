//
//  PlanetAPIManager.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 28/03/2024.
//

import Foundation

protocol PlanetAPIManagerDelegate {
  
    func didFetchPlanetData(forPlanet: Planet)
    func didFailWithError(error: Error)
}

class PlanetAPIManager {
    
    var delegate: PlanetAPIManagerDelegate?
    var planet: Planet?
    
    // Funkcja do pobierania pozycji planety na niebie
    func getPositionOfPlanet(planetName: String, completion: @escaping (String?) -> Void) {
        // Tutaj byłoby wywołanie rzeczywistego API, ale zastosujemy symulację z opóźnieniem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let position = "Pozycja planety \(planetName) na niebie: 37.7749° N, 122.4194° W" // Przykładowa pozycja
            completion(position)
        }
    }
    
    func fetchPlanetData() {
        
        let longitude = SharedLocation.values.longitude
        let latitude = SharedLocation.values.latitude
        let height = SharedLocation.values.height
        let dateStartString = calculateStartDate()
        let dateEndString = calculateEndDate()
        if let planet = self.planet {
            let planetCommand = planet.code
            let urlString = "https://ssd.jpl.nasa.gov/api/horizons.api?format=text&COMMAND=%27\(planetCommand)%27&OBJ_DATA=%27YES%27&MAKE_EPHEM=%27YES%27&EPHEM_TYPE=%27OBSERVER%27&CENTER=%27coord@399%27&COORD_TYPE=%27GEODETIC%27&SITE_COORD=%27\(longitude),\(latitude),\(height)%27&START_TIME=%27\(dateStartString)%27&STOP_TIME=%27\(dateEndString)&STEP_SIZE=%271%20d%27&QUANTITIES=%272,4,7%27"
            print("Uderzam do NASA po dane dla planety \(planet.name)")
            print(urlString)
            performRequest(with: urlString)
        } else {
            print("How can I fetch data if I don't know the planet")
        }
    }
    
    func calculateStartDate() -> String {
        let dateStart = Date()
        let dateformat = getDateFormat()
        let timeZoneString = getTimeZoneString()
        var dateStartString = dateformat.string(from: dateStart) + timeZoneString
        dateStartString = dateStartString.replacingOccurrences(of: " ", with: "%20")
        return dateStartString
    }
    
    func calculateEndDate() -> String {
        let dateEnd = Date().advanced(by: 60)
        let dateformat = getDateFormat()
        var dateEndString = dateformat.string(from: dateEnd)
        dateEndString = dateEndString.replacingOccurrences(of: " ", with: "%20")
        return dateEndString
    }
    
    func getDateFormat() -> DateFormatter {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm"
        return dateformat
    }
    
    func getTimeZoneString() -> String {
        let timeZoneSecondsDiff = TimeZone.current.secondsFromGMT()
        let timeZoneHoursDiff = timeZoneSecondsDiff/3600
        var timeZoneMinutesDiff = 0
        if timeZoneSecondsDiff%3600 > 0 {
            timeZoneMinutesDiff = (timeZoneSecondsDiff%3600)/60
        }
        var timeZoneString = "UT"
        if timeZoneHoursDiff < 0 {
            timeZoneString = timeZoneString + String(timeZoneHoursDiff)
        } else if timeZoneHoursDiff >= 0 {
            timeZoneString = timeZoneString + "+" + String(timeZoneHoursDiff)
        }
        
        if timeZoneMinutesDiff > 0 {
            timeZoneString = timeZoneString + ":" + String(timeZoneMinutesDiff)
        }
        return timeZoneString
    }
          
    
    func performRequest(with urlString: String) {
        var planet = self.planet!
        //1 Create URL
        if let url = URL(string: urlString) {
            //2 Create URLSession
            let session = URLSession(configuration: .default)
            //3 Give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return //ends function
                }
                if let safeDate = data {
                    print("Pozyskałem dane dla planety: \(planet.name)")
                    let rawPlanetDataFromNASA = String(decoding: safeDate, as: UTF8.self)
                    let planetEfemerid = PlanetDataParser.calculateEfemerid(fromRawNASAData: rawPlanetDataFromNASA)
                    planet.updateEfemerid(planetEfemerid: planetEfemerid)
                    DispatchQueue.main.async {
                        self.delegate?.didFetchPlanetData(forPlanet: planet)
                    }
                }
            }
            //4 Start task
            task.resume()
        }
    }
    
}
