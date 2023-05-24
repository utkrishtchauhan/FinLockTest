//
//  ContentView.swift
//  FinLockTest
//
//  Created by utkrisht chauhan on 24/05/23.
//

import SwiftUI

struct Country: Codable {
    let iso2: String
    let iso3: String
    let country: String
    let cities: [String]
}

struct CountriesResponse: Codable {
    let error: Bool
    let msg: String
    let data: [Country]
}

class CountryViewModel: ObservableObject {
    @Published var countries: [Country] = []
    //    private var i = 0
    init() {
        fetchCountries()
    }
    
    func fetchCountries() {
        guard let url = URL(string: "https://countriesnow.space/api/v0.1/countries") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)2345")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(CountriesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.countries = response.data
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct ContentView: View {
    @StateObject private var countryViewModel = CountryViewModel()
    @State private var selectedCountry: Country?
    
    var body: some View {
        NavigationView {
            List(countryViewModel.countries, id: \.iso2) { country in
                NavigationLink(destination: CityListView(cities: country.cities)) {
                    Text(country.country)
                }
            }
            .navigationTitle("Countries")
        }
    }
}


struct CityListView: View {
    var cities: [String]
    
    var body: some View {
        List(cities, id: \.self) { city in
            Text(city)
        }
        .navigationTitle("Cities")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
