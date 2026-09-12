//
//  ContentView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 11/11/23.
//

// https://random.imagecdn.app/500/500

import SwiftUI

struct ContentView: View {
    
    
    @State private var path = [Int]()
    @State var matches: [Int] = []
    @State var winners = [Bool]()
    @State var surfaces = [String]()
    @State var dates = [Date]()
    
    init() {
        if let savedMatches = UserDefaults.standard.array(forKey: "matches") as? [Int] {
            _matches = State(initialValue: savedMatches)
        } else {
            // Provide a default value if there is nothing stored in UserDefaults
            _matches = State(initialValue: [1, 2, 3])
            print("data not found")
        }
        
    }
    @AppStorage("matchNum") var matchNum: Int = UserDefaults.standard.integer(forKey: "matchNum")
    @State private var update = false
    @State var matchSelected = 0
    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Format as day/month/year
        return formatter.string(from: date)
    }
    
    func ReturnDataString(vari: String, i: Int) -> String {
        return UserDefaults.standard.string(forKey: "\(vari)\(i)") ?? ""
    }
    
    func ReturnDataInt(vari: String, match: Int) -> Int {
        return UserDefaults.standard.integer(forKey: "\(vari)\(match)")
    }
    
    func encode1(array: [Point],key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(array) // Encode array of `Person` into `Data`
            UserDefaults.standard.set(data, forKey: "\(key)\(matchNum)") // Store data in UserDefaults
        } catch {
            print("Failed to encode and store data: \(error)")
        }
    }
    func encode2(array: [Point],key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(array) // Encode array of `Person` into `Data`
            UserDefaults.standard.set(data, forKey: "\(key)\(matchNum)") // Store data in UserDefaults
        } catch {
            print("Failed to encode and store data: \(error)")
        }
    }
    
    
    @State var showButton = false
    @State var showImport = false
    @State private var selectedFileData: FileData? = nil
    
    func saveSharedMatch() {
        if let selectedFileData {
            let name1 = selectedFileData.name1
            let name2 = selectedFileData.name2
            let results1 = selectedFileData.results1
            let results2 = selectedFileData.results2
            
            let addTrackers = selectedFileData.additionalTrackers
            let surface = selectedFileData.surface
            let matchLength = selectedFileData.matchLength
            let setLen = selectedFileData.setLen
            let time = selectedFileData.time
            let date = selectedFileData.date
            let ads = selectedFileData.ads
            let tiebreakThird = selectedFileData.tiebreakThird
            let games11 = selectedFileData.games11
            let games12 = selectedFileData.games12
            let games21 = selectedFileData.games21
            let games22 = selectedFileData.games22
            let games13 = selectedFileData.games13
            let games23 = selectedFileData.games23
            let superPoints1 = selectedFileData.superPoints1
            let superPoints2 = selectedFileData.superPoints2
            matchNum+=1
            print(matchNum)
            matches.append(matchNum)
            UserDefaults.standard.set(matches, forKey: "matches")
            UserDefaults.standard.set(name1, forKey: "nameA\(matchNum)")
            UserDefaults.standard.set(name2, forKey: "nameB\(matchNum)")
            UserDefaults.standard.set(tiebreakThird, forKey: "tiebreakThird\(matchNum)")
            UserDefaults.standard.set(surface, forKey: "surface\(matchNum)")
            UserDefaults.standard.set(matchLength, forKey: "matchLength\(matchNum)")
            UserDefaults.standard.set(setLen, forKey: "setLen\(matchNum)")
            UserDefaults.standard.set(time, forKey: "time\(matchNum)")
            UserDefaults.standard.set(date, forKey: "date\(matchNum)")
            UserDefaults.standard.set(ads, forKey: "ads\(matchNum)")
            
            UserDefaults.standard.set(games11, forKey: "gamesA1\(matchNum)")
            UserDefaults.standard.set(games21, forKey: "gamesB1\(matchNum)")
            UserDefaults.standard.set(games12, forKey: "gamesA2\(matchNum)")
            UserDefaults.standard.set(games22, forKey: "gamesB2\(matchNum)")
            UserDefaults.standard.set(games13, forKey: "gamesA3\(matchNum)")
            UserDefaults.standard.set(games23, forKey: "gamesB3\(matchNum)")
            
            UserDefaults.standard.set(false, forKey: "delete\(matchNum)")
            
            encode1(array: results1,key: "resultsA");encode2(array: results2,key: "resultsB")
            print("Saving \(matchNum)")
            UserDefaults.standard.set(addTrackers, forKey: "addTrackers\(matchNum)")
            UserDefaults.standard.set(ads, forKey: "ads\(matchNum)")
            
            if tiebreakThird==true {
                UserDefaults.standard.set(superPoints1, forKey: "superPointsA\(matchNum)")
                UserDefaults.standard.set(superPoints2, forKey: "superPointsB\(matchNum)")
            }
        }
    }
    // Method to handle file import and decode JSON from it
    func handleFileImport(result: Result<[URL], Error>) {
        do {
            let urls = try result.get()
            if let selectedUrl = urls.first {
                // Step 1: Read the data from the file
                if selectedUrl.startAccessingSecurityScopedResource() {
                    let data = try Data(contentsOf: selectedUrl)
                    
                    // Step 2: Decode the JSON into the dictionary of people and pets
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(FileData.self, from: data)
                    
                    // Step 3: Assign the decoded data to the state variables
                    selectedFileData = decodedData
                    saveSharedMatch()
                    print("worked")
                }
                selectedUrl.stopAccessingSecurityScopedResource()
            }
        } catch {
            print("Failed to read or decode JSON file: \(error.localizedDescription)")
        }
    }
    
        
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.black
                    .ignoresSafeArea(.all)
                    
                VStack(spacing: 15) {
                    
                    NavigationLink(value: 0) {
                        Text("Record New Match")
                            .font(.title)
                            .frame(width: 300, height: 75)
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundStyle(Color.black)
                    }
                    NavigationLink(value: 1) {
                        Text("Recorded Matches")
                            .font(.title)
                            .frame(width: 300, height: 75)
                            .background(LinearGradient(colors: [Color(white:0.2),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10)
                            .foregroundStyle(Color.green)
                    }
                }
                .fontWeight(.medium)
                .navigationTitle("Start")
                .navigationDestination(for: Int.self) { num in
                    if num == 0 {
                        NewMatchView(path: $path)
                            .navigationTitle("Record Match")
                            .navigationBarTitleDisplayMode(.inline)
                            .tint(.green)
                    }
                    else if num==1 {
                        ZStack {
                            Color.black
                                .edgesIgnoringSafeArea(.all)
                            VStack(spacing: 30) {
                                if matchNum==0 {
                                    Text("No Matches Stored Yet")
                                        .font(.title2)
                                        .foregroundStyle(Color(white:0.9))
                                }
                                else {
                                    List {
                                        ForEach(matches, id: \.self) { i in
                                            if UserDefaults.standard.bool(forKey: "delete\(i)")==false {
                                                if update == false {
                                                    NavigationLink(value: (i+1)) {
                                                        HStack {
                                                            if !winners.isEmpty {
                                                                Spacer()
                                                                VStack() {
                                                                    Text("\(ReturnDataString(vari: "nameA", i: i))")
                                                                        .foregroundStyle(winners[i-1] ? Color.accentColor : Color.white)
                                                                    Text("vs")
                                                                    Text("\(ReturnDataString(vari: "nameB", i: i))")
                                                                        .foregroundStyle(winners[i-1] ? Color.white : Color.accentColor)
                                                                }
                                                                Spacer()
                                                                Grid(alignment: .topLeading ) {
                                                                    GridRow {
                                                                        if surfaces[i-1]=="Hard" {
                                                                            Text("\(surfaces[i-1])")
                                                                                .font(.title2)
                                                                                .foregroundStyle(Color.blue)
                                                                        } else {
                                                                            Text("\(surfaces[i-1])")
                                                                                .font(.title2)
                                                                                .foregroundStyle(surfaces[i-1]=="Clay" ? Color.orange : Color.green)
                                                                        }
                                                                    }
                                                                    .padding(.vertical,5)
                                                                    GridRow {
                                                                        Text("\(formattedDate(from: dates[i-1]))")
                                                                            .font(.title2)
                                                                            .foregroundStyle(Color.accentColor)
                                                                    }
                                                                }
                                                                .padding(.trailing,10)
                                                            }
                                                        }
                                                        .font(.title)
                                                        .frame(width: (UIScreen.screenWidth-12), height: 100)
                                                        .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                                                        .listRowBackground(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                                                        .cornerRadius(10)
//                                                        .shadow(color: Color(white:0.2),radius: 3)
//                                                        .border(Color(white:0.15), width: 1)

                                                    }
                                                    .frame(width: (UIScreen.screenWidth), height: 100)
                                                }
                                            } else {
                                                EmptyView()
                                            }
                                        }
                                    }
                                    .navigationTitle("Recorded Matches")
                                    .navigationBarTitleDisplayMode(.large)
                                    .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                                    .foregroundStyle(Color.white)
                                    .scrollContentBackground(.hidden)
                                    .scrollIndicators(.visible)
                                    .onAppear() {
                                        winners.removeAll()
                                        surfaces.removeAll()
                                        dates.removeAll()
                                        if let savedMatches = UserDefaults.standard.array(forKey: "matches") as? [Int] {
                                            matches = savedMatches
                                            for i in matches {
                                                winners.append(UserDefaults.standard.bool(forKey: "winner\(i)"))
                                                surfaces.append(UserDefaults.standard.string(forKey: "surface\(i)") ?? "")
                                                dates.append(UserDefaults().object(forKey: "date\(i)") as? Date ?? Date())
                                            }
                                        } else {
                                            // Provide a default value if there is nothing stored in UserDefaults
                                            matches = [1, 2, 3]
                                            print("data not found")
                                        }
                                        showButton=true
                                        update = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                update = false
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                            .fileImporter(isPresented: $showImport, allowedContentTypes: [.json], allowsMultipleSelection: false) { result in
                                handleFileImport(result: result)
                                update = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        update = false
                                    }
                                }
                            }
                            .toolbar {
                                if showButton==true {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button {
                                           showImport=true
                                        } label: {
                                            Image(systemName: "square.and.arrow.up") // Share icon
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    else if num>=2 {
                        PastMatchView(match: (num-1),update: $update,path:$path)
                            .navigationTitle("Statistics")
                    }
                }
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color(white:0.05).opacity(0.93))
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().tintColor = .green
        }
            
    }
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

#Preview {
    ContentView()
}
