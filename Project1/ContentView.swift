//
//  ContentView.swift
//  Project1
//
//  Created by Benjamin Poerschke on 21.09.2025.


import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Grey-white background
                LinearGradient(
                    colors: [ //gradient
                        Color(red: 30/255, green: 30/255, blue: 30/255),
                        Color(red: 80/255, green: 80/255, blue: 80/255)
                    ],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // Krone in Silber/Grau
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .padding(30)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.gray.opacity(0.7)
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 6)
                    
                    // Titel
                    Text("Welcome to MiCasa")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Divider in Silber
                    Divider()
                        .frame(width: 190, height: 2)
                        .background(Color.white.opacity(0.7))
                        .padding(20)
                    
                    // Untertitel
                    Text("The award winning Catalonyan fine dining Restaurant & Bar")
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray.opacity(0.9))
                        .padding(.horizontal, 32)
                    
                    // Button zur Reservierung
                    NavigationLink {
                        ReservationView()
                    } label: {
                        Text("Make a Reservation")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 50)
                    
                    // Menü
                    NavigationLink {
                        MenuView()
                    } label: {
                        Text("Menu")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 5)
                    
                    // Locations
                    NavigationLink {
                        LocationsView()
                    } label: {
                        Text("Locations")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 5)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}



struct ReservationView: View {
    // MARK: - State
    @State private var guests: Int = 1
    @State private var needsKidChair = false
    @State private var date = Date()
    @State private var phone = ""
    @State private var email = ""
    @State private var selectedCountry = CountryData.default
    @State private var comment = ""
    @State private var showSuccess = false

    private var isFormValid: Bool {
        guests > 0 && !phone.isEmpty && !email.isEmpty
    }

    var body: some View {
        ZStack {

            // Darüber: Abdunkelung
            LinearGradient(
                colors: [Color.black.opacity(0.65), Color.black.opacity(0.45)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if showSuccess {
                SuccessView()
                    .transition(.opacity)
                    .zIndex(1)
            }

            // Ganz vorne: Inhalt
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    // Titel (Restaurantname)
                    Text("Restaurant")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 6)
                        .padding(.horizontal)

                    // Gäste + Kid Chair – Card (GLAS)
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Label("Number of guests", systemImage: "person.3.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            HStack(spacing: 0) {
                                Button {
                                    if guests > 1 { guests -= 1 }
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                }
                                .disabled(guests <= 1)

                                Text("\(guests)")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(minWidth: 28)
                                    .padding(.horizontal, 4)

                                Button {
                                    guests += 1
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                }
                            }
                            .buttonStyle(.plain)
                            .background(Color.white.opacity(0.9), in: Capsule())
                        }

                        Divider().background(Color.white.opacity(0.25))

                        HStack(spacing: 12) {
                            Label("Kids chair needed", systemImage: "chair.lounge.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Toggle("", isOn: $needsKidChair)
                                .labelsHidden()
                        }
                    }
                    .padding(14)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.18), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                    .padding(.horizontal)

                    // Booking date – Card (GLAS) mit weißen Chips
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Booking date")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal)

                        HStack(spacing: 12) {
                            DatePicker("", selection: $date, displayedComponents: [.date])
                                .labelsHidden()
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color.white.opacity(0.9), in: Capsule())

                            DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                                .labelsHidden()
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color.white.opacity(0.9), in: Capsule())

                            Spacer(minLength: 0)
                        }
                        .padding(12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                        .padding(.horizontal)
                    }

                    // Contact – Felder bleiben weiß (Lesbarkeit)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contact")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white.opacity(0.9))
                        VStack(spacing: 8) {
                            HStack(spacing: 6) {
                                Menu {
                                    ForEach(CountryData.all.sorted(by: { $0.name < $1.name })) { c in
                                        Button(action: { selectedCountry = c }) {
                                            Text("\(c.flag)  \(c.name)  \(c.dialCode)")
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text(selectedCountry.flag)
                                        Text(selectedCountry.dialCode)
                                            .fontWeight(.semibold)
                                        Image(systemName: "chevron.down")
                                            .font(.footnote)
                                            .opacity(0.6)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background(Color.white, in: Capsule())
                                }

                                Divider()
                                    .frame(height: 22)
                                    .opacity(0.2)

                                TextField("Phone number", text: $phone)
                                    .keyboardType(.numberPad)
                                    .onChange(of: phone) { newVal in
                                        phone = newVal.filter { $0.isNumber }
                                    }
                            }
                            .padding(12)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 12))

                            TextField("E-mail", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(12)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)

                    // Comment – Card (GLAS)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comment (optional)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white.opacity(0.9))

                        TextEditor(text: $comment)
                            .frame(minHeight: 110)
                            .padding(10)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.18), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)

                    // Send-Bar mit Button (weiß wie im Mock)
                    HStack {
                        Button {
                            withAnimation {
                                showSuccess = true
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "paperplane.fill")
                                Text("Send reservation")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 18)
                            .background(isFormValid ? Color.black : Color.gray.opacity(0.22), in: Capsule())
                        }
                        .disabled(!isFormValid)

                        Spacer()
                    }
                    .padding(12)
                    .background(.white, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 3)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
        }
        .navigationTitle("New Reservation")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// Menu View
struct MenuView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 30/255, green: 30/255, blue: 30/255),
                    Color(red: 80/255, green: 80/255, blue: 80/255)
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    Text("Our Menu")
                        .font(.largeTitle.bold())
                        .padding(.top)
                        .foregroundColor(.white)
                    Text("Experience the finest Spanish specialties, reimagined for a modern palate.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.horizontal)

                    VStack(spacing: 20) {
                        menuCard(
                            name: "Pulpo a la Gallega",
                            description: "Galician-style octopus, tender and smoky, served with saffron potatoes, smoked paprika oil, and Maldon salt.",
                            price: "€29"
                        )
                        menuCard(
                            name: "Paella de Mariscos",
                            description: "Classic seafood paella with Mediterranean prawns, calamari, mussels, and bomba rice infused with saffron.",
                            price: "€34"
                        )
                        menuCard(
                            name: "Cochinillo Asado",
                            description: "Crispy slow-roasted suckling pig with apple purée and sherry reduction.",
                            price: "€38"
                        )
                        menuCard(
                            name: "Chuleta de Buey",
                            description: "Aged rib steak, fire-grilled, served with pimientos de padrón and rosemary salt.",
                            price: "€44"
                        )
                        menuCard(
                            name: "Gazpacho Andaluz",
                            description: "Chilled Andalusian tomato soup with green olive oil and sourdough crisps.",
                            price: "€14"
                        )
                        menuCard(
                            name: "Crema Catalana",
                            description: "Traditional Catalan cream with caramelized sugar crust and Valencia orange zest.",
                            price: "€12"
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
        }
    }

    private func menuCard(name: String, description: String, price: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Spacer()
                Text(price)
                    .font(.title3)
                    .foregroundColor(.yellow)
            }
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.82))
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.13), lineWidth: 1))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

// MARK: - Map Pin for LocationsView
struct BCNPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// Location View
struct LocationsView: View {
    private let pins = [
        BCNPin(coordinate: CLLocationCoordinate2D(latitude: 41.387, longitude: 2.170)), // Plaça Catalunya
        BCNPin(coordinate: CLLocationCoordinate2D(latitude: 41.403, longitude: 2.174)), // Sagrada Família
        BCNPin(coordinate: CLLocationCoordinate2D(latitude: 41.380, longitude: 2.185))  // Barceloneta
    ]
    
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.390, longitude: 2.176),
        span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.03)
    )
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 30/255, green: 30/255, blue: 30/255),
                    Color(red: 80/255, green: 80/255, blue: 80/255)
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text("Our Locations")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Here you will later see addresses, maps and opening hours.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.horizontal)
                    
                    Map(coordinateRegion: $mapRegion, annotationItems: pins) { pin in
                        MapMarker(coordinate: pin.coordinate, tint: .red)
                    }
                    .frame(height: 240)
                    .cornerRadius(18)
                    .padding(.horizontal)
                }
                .navigationTitle("Locations")
            }
        }
    }
}

// MARK: - Country / Dial Code Data
struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iso2: String
    let dialCode: String
    var flag: String {
        let base: UInt32 = 127397
        var scalarView = String.UnicodeScalarView()
        for v in iso2.uppercased().unicodeScalars {
            if let s = UnicodeScalar(base + v.value) { scalarView.append(s) }
        }
        return String(scalarView)
    }
}

enum CountryData {
    static let all: [Country] = [
        Country(name: "Argentina", iso2: "AR", dialCode: "+54"),
        Country(name: "Australia", iso2: "AU", dialCode: "+61"),
        Country(name: "Austria", iso2: "AT", dialCode: "+43"),
        Country(name: "Belgium", iso2: "BE", dialCode: "+32"),
        Country(name: "Brazil", iso2: "BR", dialCode: "+55"),
        Country(name: "Bulgaria", iso2: "BG", dialCode: "+359"),
        Country(name: "Canada", iso2: "CA", dialCode: "+1"),
        Country(name: "Chile", iso2: "CL", dialCode: "+56"),
        Country(name: "China", iso2: "CN", dialCode: "+86"),
        Country(name: "Colombia", iso2: "CO", dialCode: "+57"),
        Country(name: "Croatia", iso2: "HR", dialCode: "+385"),
        Country(name: "Czech Republic", iso2: "CZ", dialCode: "+420"),
        Country(name: "Denmark", iso2: "DK", dialCode: "+45"),
        Country(name: "Egypt", iso2: "EG", dialCode: "+20"),
        Country(name: "Estonia", iso2: "EE", dialCode: "+372"),
        Country(name: "Finland", iso2: "FI", dialCode: "+358"),
        Country(name: "France", iso2: "FR", dialCode: "+33"),
        Country(name: "Germany", iso2: "DE", dialCode: "+49"),
        Country(name: "Greece", iso2: "GR", dialCode: "+30"),
        Country(name: "Hong Kong", iso2: "HK", dialCode: "+852"),
        Country(name: "Hungary", iso2: "HU", dialCode: "+36"),
        Country(name: "Iceland", iso2: "IS", dialCode: "+354"),
        Country(name: "India", iso2: "IN", dialCode: "+91"),
        Country(name: "Indonesia", iso2: "ID", dialCode: "+62"),
        Country(name: "Ireland", iso2: "IE", dialCode: "+353"),
        Country(name: "Israel", iso2: "IL", dialCode: "+972"),
        Country(name: "Italy", iso2: "IT", dialCode: "+39"),
        Country(name: "Japan", iso2: "JP", dialCode: "+81"),
        Country(name: "Kenya", iso2: "KE", dialCode: "+254"),
        Country(name: "Luxembourg", iso2: "LU", dialCode: "+352"),
        Country(name: "Malaysia", iso2: "MY", dialCode: "+60"),
        Country(name: "Mexico", iso2: "MX", dialCode: "+52"),
        Country(name: "Netherlands", iso2: "NL", dialCode: "+31"),
        Country(name: "New Zealand", iso2: "NZ", dialCode: "+64"),
        Country(name: "Norway", iso2: "NO", dialCode: "+47"),
        Country(name: "Pakistan", iso2: "PK", dialCode: "+92"),
        Country(name: "Philippines", iso2: "PH", dialCode: "+63"),
        Country(name: "Poland", iso2: "PL", dialCode: "+48"),
        Country(name: "Portugal", iso2: "PT", dialCode: "+351"),
        Country(name: "Qatar", iso2: "QA", dialCode: "+974"),
        Country(name: "Romania", iso2: "RO", dialCode: "+40"),
        Country(name: "Russia", iso2: "RU", dialCode: "+7"),
        Country(name: "Saudi Arabia", iso2: "SA", dialCode: "+966"),
        Country(name: "Singapore", iso2: "SG", dialCode: "+65"),
        Country(name: "Slovakia", iso2: "SK", dialCode: "+421"),
        Country(name: "Slovenia", iso2: "SI", dialCode: "+386"),
        Country(name: "South Africa", iso2: "ZA", dialCode: "+27"),
        Country(name: "South Korea", iso2: "KR", dialCode: "+82"),
        Country(name: "Spain", iso2: "ES", dialCode: "+34"),
        Country(name: "Sweden", iso2: "SE", dialCode: "+46"),
        Country(name: "Switzerland", iso2: "CH", dialCode: "+41"),
        Country(name: "Taiwan", iso2: "TW", dialCode: "+886"),
        Country(name: "Thailand", iso2: "TH", dialCode: "+66"),
        Country(name: "Turkey", iso2: "TR", dialCode: "+90"),
        Country(name: "Ukraine", iso2: "UA", dialCode: "+380"),
        Country(name: "United Arab Emirates", iso2: "AE", dialCode: "+971"),
        Country(name: "United Kingdom", iso2: "GB", dialCode: "+44"),
        Country(name: "United States", iso2: "US", dialCode: "+1"),
        Country(name: "Vietnam", iso2: "VN", dialCode: "+84")
    ]
    static let `default`: Country = all.first(where: { $0.iso2 == "DE" }) ?? all[0]
}

struct SuccessView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 30/255, green: 30/255, blue: 30/255),
                    Color(red: 80/255, green: 80/255, blue: 80/255)
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("Success!")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SuccessView()
}

