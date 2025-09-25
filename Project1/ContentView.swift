//
//  ContentView.swift
//  Project1
//
//  Created by Benjamin Poerschke on 21.09.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Grey-white background
                LinearGradient(
                    colors: [
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
                            .padding(.horizontal, 30)
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
                            .padding(.horizontal, 20)
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
    @State private var guests: String = "2"      // numerisches Feld
    @State private var needsKidChair = false
    @State private var date = Date()
    @State private var phone = ""
    @State private var email = ""
    @State private var comment = ""

    private var isFormValid: Bool {
        (Int(guests) ?? 0) > 0 && !phone.isEmpty && !email.isEmpty
    }

    var body: some View {
        ZStack {
            // Ganz hinten: Hintergrundbild
            Image("restaurantpic")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 6, opaque: true)

            // Darüber: Abdunkelung
            LinearGradient(
                colors: [Color.black.opacity(0.65), Color.black.opacity(0.45)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

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
                            TextField("2", text: $guests)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.9), in: Capsule())
                                .frame(minWidth: 60)
                        }

                        Divider().background(Color.white.opacity(0.25))

                        HStack(spacing: 12) {
                            Label("Kid chair needed", systemImage: "chair.lounge.fill")
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
                        VStack(spacing: 12) {
                            TextField("Phone number", text: $phone)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
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
                            print("Send reservation: \(guests) guests | \(date) | \(phone) | \(email) | kidChair: \(needsKidChair) | note: \(comment)")
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "paperplane.fill")
                                Text("Send reservation")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 18)
                            .background(Color.gray.opacity(isFormValid ? 0.5 : 0.22), in: Capsule())
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
        ScrollView {
            VStack(spacing: 20) {
                Text("Our Menu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Here you will later see all categories of dishes, wines and desserts.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Menu")
    }
}

// Location View
struct LocationsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Our Locations")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Here you will later see addresses, maps and opening hours.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Locations")
        }
    }
}
