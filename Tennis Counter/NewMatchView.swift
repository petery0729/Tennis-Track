//
//  NewMatchView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 7/22/24.
//

import SwiftUI
import Charts

class AppTerminationObserver: ObservableObject {
    @Published var showClose = false

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppTermination),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    @objc private func handleAppTermination() {
//        if !isDataSaved {
//            // Display a warning to the user
//            DispatchQueue.main.async {
//                self.showAlert = true
//            }
//        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


struct NewMatchView: View {
    
    @Binding var path: [Int]
    @State var selection = 0
    @State var first = true
    
    @AppStorage("isNamesInputed") var isNamesInputed = 0
    @AppStorage("matchNum") var matchNum: Int = 0
    @State var matches = [Int]()
    
    @StateObject private var terminationObserver = AppTerminationObserver()
    
    @State var pointPhase = 0
    @State var causedPress = 1
    @State var commentAdded = false
    
    
    @State var name1 = ""
    @State var name2 = ""
    @State var server = ""
    
    
    @State var ad = 0
    @State var points1 = 0
    @State var points2 = 0
    @State var points1h = 0
    @State var points2h = 0
    @State var games11 = 0
    @State var games12 = 0
    @State var games21 = 0
    @State var games22 = 0
    @State var games13 = 0
    @State var games23 = 0
    @State var sets1 = 0
    @State var sets2 = 0
    @State var set = 1
    
    @State var totalGames = 0
    @State var totalPoints = 0
    @State var lastPoints1 = 0
    @State var lastPoints2 = 0
    @State var lastPointOwn = 0
    @State var lastServer = 0
    @State var showUndo = false
    @State var showRestart = false
    @State var showBack = false
    @State var winner = 0

    
    @State var tiebreakThird = true
    @State var tiebreakTotalPoints = 0
    
    @State var results1 = [Point]()
    @State var results2 = [Point]()
    @State var result = Point(point: 0, server: 0, game: 0,gameN:0,firstServeIn: false, keyShotType: "",shotType: "",stroke: "", location: "",cause: "",comment: "Enter Comment", rallyLength: "", additionalTrackers: [],set:1,breakp: false,breakpcon: false)
    @State var additionalTrackers = [String]()
    @State var owner = 1
    @State var error = false
    @State var serve = false
    @State var statMode1 = 0
    @State var statMode2 = 0
    @State var setLen = 0
    @State var matchLength = 0
    @State var ads = false
    @State var surface: Surface = .Hard
    @State var date = Date()
    @State var time = ""
    
    @State private var isRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var startTime: Date?

    func timeString(from time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        
        return String(format: "%02d:%02d", hours, minutes)
    }

    func startTimer() {
        self.startTime = Date() - self.elapsedTime
        self.isRunning = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            if let startTime = self.startTime {
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.isRunning = false
    }

    func resetTimer() {
        self.stopTimer()
        self.elapsedTime = 0
        self.startTime = nil
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
    
    init(path: Binding<[Int]>){
//        UITableView.appearance().backgroundColor = .clear
//        UITabBar.appearance().backgroundColor = .black
        self._path = path
            
        }
    
    
    var body: some View {
        if isNamesInputed == 0 {
            FormView(name1: $name1, name2: $name2, server: $server, isNamesInputed: $isNamesInputed,tiebreakThird: $tiebreakThird, statMode1: $statMode1, statMode2: $statMode2, setLen: $setLen, matchLength: $matchLength,additionalTrackers: $additionalTrackers, ads: $ads,surface: $surface,date: $date)
        }
        else if isNamesInputed == 1 {
            TabView(selection: $selection) {
                ZStack {
                    Color.black
                        .ignoresSafeArea(.all)
                    VStack {
                        VStack {
                            HStack(spacing:0) {
                                VStack(alignment: .leading, spacing:0) {
                                    Text("\(name1)")
                                        .font(.title)
                                        .padding(.horizontal, 5)
                                    DividerC()
                                    Text("\(name2)")
                                        .font(.title)
                                        .padding(.horizontal, 5)
                                }
                                .background(Color(white:0.2))
                                VStack(alignment: .leading, spacing:0) {
                                    if server==name1 {
                                        Text(Image(systemName: "tennisball.fill"))
                                            .foregroundStyle(Color.accentColor)
                                            .frame(alignment:.center)
                                    } else {
                                        Text("     ")
                                    }
                                        DividerC()
                                    if server==name2 {
                                        Text(Image(systemName: "tennisball.fill"))
                                            .foregroundStyle(Color.accentColor)
                                            .frame(alignment:.center)
                                    } else {
                                        Text("    ")
                                    }
                                }
                                .frame(width:40, height:68)
                                .font(.title2)
                                .background(Color(white:0.2))
                                VStack(spacing:0) {
                                    ButtonView(data: $games11)
                                    DividerC()
                                    ButtonView(data: $games21)
                                }
                                .frame(width: 40)
                                .background(Color(white:0.2))
                                VStack(spacing:0) {
                                    ButtonView(data: $games12)
                                    DividerC()
                                    ButtonView(data: $games22)
                                }
                                .frame(width: 40)
                                .background(Color(white:0.2))
                                if tiebreakThird == false {
                                    VStack(spacing:0) {
                                        ButtonView(data: $games13)
                                        DividerC()
                                        ButtonView(data: $games23)
                                    }
                                    .frame(width: 40)
                                    .background(Color(white:0.2))
                                }
                                VStack(spacing:0) {
                                    if ad==0 {
                                        ButtonView(data: $points1)
                                        DividerC()
                                        ButtonView(data: $points2)
                                    }
                                    if ad==1 {
                                        Text("Ad")
                                            .cornerRadius(10)
                                            .font(.title)
                                        DividerC()
                                        ButtonView(data: $points2)
                                    }
                                    if ad==2 {
                                        ButtonView(data: $points1)
                                        DividerC()
                                        Text("Ad")
                                            .cornerRadius(10)
                                            .font(.title)
                                    }
                                }
                                .frame(width: 40)
                                .foregroundStyle(Color.accentColor)
                                .background(Color(white: 0.9))
                                
                            }
                            .frame(width:300,height:80)
                            .padding(.horizontal, 40)
                            .cornerRadius(10)
                        }
                        .cornerRadius(10)
                        Divider() .background(Color.white)
                        HStack {
                            Text("Record Point:")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(timeString(from: elapsedTime))
                                .font(.title2)
                                .lineLimit(1)
                                .padding(.trailing, 5)
                        }
                        .padding(.trailing, 10)
                        Divider() .background(Color.white)
                        ScrollView() {
                            if pointPhase==0 {
                                VStack {
                                    Text("First Serve")
                                        .font(.title2)
                                        .frame(alignment: .leading)
                                        .foregroundStyle(Color.accentColor)
                                    HStack {
                                        Button {
                                            pointPhase+=1
                                            result.point = (totalPoints+1)
                                            result.set=set
                                            result.firstServeIn = true
                                            if server==name1 {result.server=1} else {result.server=2}
                                        } label: {
                                            Text("In")
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 400)
                                                .font(.title)
                                                .background(Color(white:0.1))
                                                .foregroundStyle(Color.accentColor)
                                                .cornerRadius(10)
                                        }
                                        Button {
                                            pointPhase+=1
                                            result.point = (totalPoints+1)
                                            result.set=set
                                            result.firstServeIn = false
                                            if server==name1 {result.server=1} else {result.server=2}
                                        } label: {
                                            Text("Out")
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 400)
                                                .font(.title)
                                                .background(Color(white:0.1))
                                                .foregroundStyle(.red)
                                                .cornerRadius(10)
                                        }
                                    }
                                } .frame(maxWidth: .infinity)
                                    .padding(0)
                            }
                            else if pointPhase==1 {
                                VStack() {
                                    Text("Key Shot")
                                        .font(.title2)
                                        .frame(alignment: .leading)
                                        .foregroundStyle(Color.accentColor)
                                    HStack() {
                                        Button {
                                            if server==name1 {
                                                owner=1
                                                addPoints1()
                                            }
                                            else {
                                                owner=2
                                                addPoints2()
                                            }
                                            result.keyShotType = "Ace"
                                            serve=true
                                            if (statMode1<2 && server==name1) || (statMode2<2 && server==name2) {
                                                pointPhase+=4
                                            }
                                            result.rallyLength="1-4"
                                        } label: {
                                            ButtonN(text: "Ace")
                                                .foregroundStyle(.green)
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                .background(Color(white:0.1))
                                                .cornerRadius(10)
                                        }
                                        Button {
                                            if server==name1 {
                                                owner=1
                                                addPoints2()
                                            }
                                            else {
                                                owner=2
                                                addPoints1()
                                            }
                                            result.keyShotType = "Double Fault"
                                            serve=true
                                            if (statMode1<2 && server==name1) || (statMode2<2 && server==name2) {
                                                pointPhase+=4
                                            }
                                            result.rallyLength="1-4"
                                        } label: {
                                            ButtonN(text: " Double Fault ")
                                                .foregroundStyle(.red)
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                .background(Color(white:0.1))
                                                .cornerRadius(10)
                                        }
                                    }
                                    HStack {
                                        VStack() {
                                            ButtonN(text: name1)
                                                .foregroundStyle(Color.white)
                                                .frame(width: (UIScreen.screenWidth/2)-10)
                                                .cornerRadius(10)
                                            Button {
                                                addPoints1()
                                                result.keyShotType = "Winner"
                                                if statMode1<2 {
                                                    pointPhase+=4
                                                    print(pointPhase)
                                                }
                                            } label: {
                                                ButtonN(text: "Winner")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            if statMode1>0 {
                                                Button {
                                                    addPoints2()
                                                    result.keyShotType = "Net Mistake"
                                                    error = true
                                                    if statMode1<2 {
                                                        pointPhase+=4
                                                    }
                                                } label: {
                                                    ButtonN(text: "Net Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    addPoints2()
                                                    result.keyShotType = "Wide Mistake"
                                                    error = true
                                                    if statMode1<2 {
                                                        pointPhase+=4
                                                    }
                                                } label: {
                                                    ButtonN(text: "Wide Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    addPoints2()
                                                    result.keyShotType = "Long Mistake"
                                                    error = true
                                                    if statMode1<2 {
                                                        pointPhase+=4
                                                    }
                                                } label: {
                                                    ButtonN(text: "Long Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                            } else {
                                                Button {
                                                    addPoints2()
                                                    result.cause = "Unforced Error"
                                                    error = true
                                                    pointPhase+=4

                                                } label: {
                                                    ButtonN(text: "Unforced Error")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    addPoints2()
                                                    result.cause = "Forced Error"
                                                    error = true
                                                    pointPhase+=4
                                                } label: {
                                                    ButtonN(text: "Forced Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    
                                                } label: {
                                                    Text("     ")
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .font(.title)
                                                        .background(Color.black)
                                                        .foregroundStyle(.black)
                                                        .cornerRadius(10)
                                                }
                                            }
                                        }
                                        VStack {
                                            ButtonN(text: name2)
                                                .foregroundStyle(Color.white)
                                                .frame(width: (UIScreen.screenWidth/2)-10)
                                                .cornerRadius(10)
                                            Button {
                                                addPoints2()
                                                result.keyShotType = "Winner"
                                                owner=2
                                                if statMode2<2 {
                                                    pointPhase+=4
                                                }
                                            } label: {
                                                ButtonN(text: "Winner")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            if statMode2>0 {
                                                Button {
                                                    addPoints1()
                                                    result.keyShotType = "Net Mistake"
                                                    owner=2
                                                    error = true
                                                    if statMode2<2 {
                                                        pointPhase+=4
                                                    }
                                                } label: {
                                                    ButtonN(text: "Net Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    addPoints1()
                                                    result.keyShotType = "Wide Mistake"
                                                    owner=2
                                                    error = true
                                                    if statMode2<2 {
                                                        pointPhase+=4
                                                    }
                                                } label: {
                                                    ButtonN(text: "Wide Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    addPoints1()
                                                    result.keyShotType = "Long Mistake"
                                                    owner=2
                                                    error = true
                                                    if statMode2<2 {
                                                        pointPhase+=4
                                                    }
                                                } label: {
                                                    ButtonN(text: "Long Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                            } else {
                                                Button {
                                                    addPoints1()
                                                    result.cause = "Unforced Error"
                                                    owner=2
                                                    error = true
                                                    pointPhase+=4
                                                } label: {
                                                    ButtonN(text: "Unforced Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    addPoints1()
                                                    result.cause = "Forced Error"
                                                    owner=2
                                                    error = true
                                                    pointPhase+=4
                                                } label: {
                                                    ButtonN(text: "Forced Mistake")
                                                        .foregroundStyle(Color.red)
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .background(Color(white:0.1))
                                                        .cornerRadius(10)
                                                }
                                                Button {
                                                    
                                                } label: {
                                                    Text("    ")
                                                        .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                        .font(.title)
                                                        .background(Color.black)
                                                        .foregroundStyle(.black)
                                                        .cornerRadius(10)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                            }
                            else if pointPhase==2 {
                                ButtonN(text: "Type of Shot")
                                    .foregroundStyle(Color.accentColor)
                                    .frame(width: (UIScreen.screenWidth/2)-10)
                                    .cornerRadius(10)
                                HStack() {
                                    if serve==false {
                                        VStack() {
                                            Button {
                                                result.shotType = "Return"
                                                result.rallyLength="1-4"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Return")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Normal Baseline"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Normal Baseline")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Inside-In"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Inside-In")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Inside-Out"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Inside Out")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Slice"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Slice")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Smash"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Smash")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                        }
                                        VStack() {
                                            Button {
                                                result.shotType = "Drop Shot"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Drop Shot")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Passing Shot"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Passing Shot")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Lob"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Lob")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Approach"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Approach Shot")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                result.shotType = "Volley"
                                                pointPhase+=1
                                            } label: {
                                                ButtonN(text: "Volley")
                                                    .foregroundStyle(Color.accentColor)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color(white:0.1))
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                               
                                            } label: {
                                                ButtonN(text: "SSSSSS")
                                                    .foregroundStyle(Color.black)
                                                    .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                                    .background(Color.black)
                                                    .cornerRadius(10)
                                            }
                                        }
                                    }
                                    else {
                                        Text("") .onAppear() {pointPhase+=3}
                                    }
                                            
                                }.padding(.horizontal)
                            }
                            else if pointPhase==3 {
                                ButtonN(text: "Forehand or Backhand")
                                    .foregroundStyle(Color.white)
                                    .frame(width: (UIScreen.screenWidth/2)-10)
                                    .cornerRadius(10)
                                switch result.shotType {
                                case "Inside-Out":
                                    Text("")
                                        .onAppear() {
                                            pointPhase+=2
                                            result.stroke = "Forehand"
                                            result.location="Cross"
                                        }
                                case "Inside-In":
                                    Text("")
                                        .onAppear() {
                                            pointPhase+=2
                                            result.stroke = "Forehand"
                                            result.location="Down Line"
                                        }
                                default:
                                    HStack {
                                        Button {
                                            pointPhase+=1
                                            result.stroke = "Forehand"
                                        } label: {
                                            Text("Forehand")
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 400)
                                                .font(.title)
                                                .background(Color(white:0.1))
                                                .foregroundStyle(Color.accentColor)
                                                .cornerRadius(10)
                                        }
                                        Button {
                                            pointPhase+=1
                                            result.stroke = "Backhand"
                                        } label: {
                                            Text("Backhand")
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 400)
                                                .font(.title)
                                                .background(Color(white:0.1))
                                                .foregroundStyle(Color.accentColor)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                
                                
                            }
                            else if pointPhase==4 {
                                ButtonN(text: "Location")
                                    .foregroundStyle(Color.white)
                                    .frame(width: (UIScreen.screenWidth/2)-10)
                                    .cornerRadius(10)
                                HStack {
                                    Button {
                                        pointPhase+=1
                                        result.location = "Cross"
                                    } label: {
                                        Text("Cross Court")
                                            .frame(width: (UIScreen.screenWidth/3)-10, height: 400)
                                            .font(.title)
                                            .background(Color(white:0.1))
                                            .foregroundStyle(Color.accentColor)
                                            .cornerRadius(10)
                                    }
                                    Button {
                                        pointPhase+=1
                                        result.location = "Middle"
                                    } label: {
                                        Text("Middle")
                                            .frame(width: (UIScreen.screenWidth/3)-10, height: 400)
                                            .font(.title)
                                            .background(Color(white:0.1))
                                            .foregroundStyle(Color.accentColor)
                                            .cornerRadius(10)
                                    }
                                    Button {
                                        pointPhase+=1
                                        result.location = "Down Line"
                                    } label: {
                                        Text("Down the Line")
                                            .frame(width: (UIScreen.screenWidth/3)-10, height: 400)
                                            .font(.title)
                                            .background(Color(white:0.1))
                                            .foregroundStyle(Color.accentColor)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            else if pointPhase==5 {
                                if error==true {
                                    ButtonN(text: "Cause of Error")
                                        .foregroundStyle(Color.white)
                                        .frame(width: (UIScreen.screenWidth/2)-10)
                                        .cornerRadius(10)
                                    HStack {
                                        Button {
                                            causedPress=1
                                        } label: {
                                            Text("Unforced Error ")
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 200)
                                                .font(.title)
                                                .background(causedPress==1 ? Color.accentColor : Color(white:0.1))
                                                .foregroundStyle(causedPress==1 ? Color.black : Color.accentColor)
                                                .cornerRadius(10)
                                        }
                                        Button {
                                            causedPress=0
                                        } label: {
                                            Text("Forced Error")
                                                .frame(width: (UIScreen.screenWidth/2)-10, height: 200)
                                                .font(.title)
                                                .background(causedPress==0 ? Color.accentColor : Color(white:0.1))
                                                .foregroundStyle(causedPress==0 ? Color.black : Color.accentColor)
                                                .cornerRadius(10)
                                        }
                                    }
                                    if serve || (result.rallyLength=="1-4") {
                                        Button {
                                            pointPhase+=1
                                            if causedPress==0 {result.cause="Forced Error"}
                                            if causedPress==1 {result.cause="Unforced Error"}
                                        } label: {
                                            Text("Confirm")
                                                .frame(width: (UIScreen.screenWidth)-10, height: 75)
                                                .font(.title)
                                                .background(Color(white:0.1))
                                                .foregroundStyle(Color.accentColor)
                                                .cornerRadius(10)
                                        }
                                    }
                                    if !serve && !(result.rallyLength=="1-4") {
                                        ButtonN(text: "Rally Length")
                                            .foregroundStyle(Color.white)
                                            .frame(width: (UIScreen.screenWidth/2)-10)
                                            .cornerRadius(10)
                                        HStack {
                                            Button {
                                                pointPhase+=1
                                                result.rallyLength="1-4"
                                                if causedPress==0 {result.cause="Forced Error"}
                                                if causedPress==1 {result.cause="Unforced Error"}
                                            } label: {
                                                Text("1-4")
                                                    .frame(width: (UIScreen.screenWidth/3)-10, height: 200)
                                                    .font(.title)
                                                    .background(Color(white:0.1))
                                                    .foregroundStyle(Color.accentColor)
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                pointPhase+=1
                                                result.rallyLength = "4-8"
                                                if causedPress==0 {result.cause="Forced Error"}
                                                if causedPress==1 {result.cause="Unforced Error"}
                                            } label: {
                                                Text("4-8")
                                                    .frame(width: (UIScreen.screenWidth/3)-10, height: 200)
                                                    .font(.title)
                                                    .background(Color(white:0.1))
                                                    .foregroundStyle(Color.accentColor)
                                                    .cornerRadius(10)
                                            }
                                            Button {
                                                pointPhase+=1
                                                result.rallyLength = "8+"
                                                if causedPress==0 {result.cause="Forced Error"}
                                                if causedPress==1 {result.cause="Unforced Error"}
                                            } label: {
                                                Text("8+")
                                                    .frame(width: (UIScreen.screenWidth/3)-10, height: 200)
                                                    .font(.title)
                                                    .background(Color(white:0.1))
                                                    .foregroundStyle(Color.accentColor)
                                                    .cornerRadius(10)
                                            }
                                        }
                                    }
                                } else {
                                    Text("")
                                        .onAppear() {
                                            if error==false {
                                                pointPhase+=1
                                            }
                                        }
                                }
                            }
                            else if pointPhase==6 {
                                ButtonN(text: "Add Comment")
                                    .foregroundStyle(Color.accentColor)
                                    .frame(width: (UIScreen.screenWidth/2)-10)
                                    .cornerRadius(10)
                                TextEditor(text: $result.comment)
                                    .frame(width: (UIScreen.screenWidth-10),height: 75)
                                    .font(.title2)
                                    .background(Color(white:0.1))
                                    .scrollContentBackground(.hidden)
                                    .foregroundStyle(result.comment=="Enter Comment" ? Color(white:0.3) : Color.white)
                                    .cornerRadius(10)
                                    .onAppear {
                                        // remove the placeholder text when keyboard appears
                                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                                            withAnimation {
                                                if result.comment == "Enter Comment" {
                                                    result.comment = ""
                                                }
                                            }
                                        }
                                    }
                                HStack {
                                    Button {
                                        if additionalTrackers.isEmpty {
                                            pointPhase+=1
                                        }
                                        commentAdded=true
                                    } label: {
                                        Text(commentAdded ? "✓" : "Add")
                                            .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                            .font(.title)
                                            .background(Color(white:0.1))
                                            .foregroundStyle(Color.accentColor)
                                            .cornerRadius(10)
                                    }
                                    .disabled(commentAdded)
                                    Button {
                                        result.comment=""
                                        if additionalTrackers.isEmpty {
                                            pointPhase+=1
                                        }
                                    } label: {
                                        Text("None")
                                            .frame(width: (UIScreen.screenWidth/2)-10, height: 75)
                                            .font(.title)
                                            .background(Color(white:0.1))
                                            .foregroundStyle(Color.accentColor)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.bottom, 10)
                                if additionalTrackers.isEmpty==false {
                                    ButtonN(text: "Additional Trackers")
                                        .foregroundStyle(Color.accentColor)
                                        .frame(width: (UIScreen.screenWidth)-10)
                                        .cornerRadius(10)
                                    ForEach(additionalTrackers, id: \.self) { tracker in
                                        Button {
                                            pointPhase+=1
                                            result.additionalTrackers.append(tracker)
                                        } label: {
                                            Text(tracker)
                                                .frame(width: (UIScreen.screenWidth)-10, height: 75)
                                                .font(.title)
                                                .background(Color(white:0.1))
                                                .foregroundStyle(Color.accentColor)
                                                .cornerRadius(10)
                                        }
                                    }
                                    Button {
                                        pointPhase+=1
                                    } label: {
                                        Text("None")
                                            .frame(width: (UIScreen.screenWidth)-10, height: 75)
                                            .font(.title)
                                            .background(Color(white:0.1))
                                            .foregroundStyle(Color.accentColor)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            else if pointPhase==7 {
                                Text("")
                                    .onAppear() {
                                        if owner==1 {
                                            results1.append(result)
                                        } else {
                                            results2.append(result)
                                        }
                                        commentAdded=false
                                        serve=false
                                        error=false
                                        owner=1
                                        causedPress=1
                                        result = Point(point: 0, server: 0,game: 0, gameN: 0, firstServeIn: false, keyShotType: "",shotType: "",stroke: "", location: "",cause: "",comment: "Enter Comment", rallyLength: "", additionalTrackers: [],set:1,breakp: false,breakpcon: false)
                                        pointPhase=0
                                    }
                            }
                        }
                        .scrollIndicators(.visible)
                        .frame(width: UIScreen.screenWidth)
                        .padding(0)
                        .ignoresSafeArea()
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .padding(EdgeInsets(.init(top: 0, leading: 0, bottom: 1, trailing: 0)))
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                    .tabItem {
                        Label("Record", systemImage: "rectangle.and.pencil.and.ellipsis")
                            .foregroundColor(.green)
                    }
                    .tag(1)
//
                NewStatisticsView(name1: $name1, name2: $name2, results1: $results1, results2: $results2,selection:$selection,addTrackers: $additionalTrackers,surface: $surface, matchLength: $matchLength, setLen: $setLen, time: $time, date: $date, ads: $ads, tiebreakThird: $tiebreakThird)
                    .onChange(of: totalPoints, {
                        print(totalPoints)
                    })
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                    .tabItem {
                        Label("Statistics", systemImage: "atom")
                            .foregroundColor(.green)
                    }
                    .tag(0)
            }
            .onAppear {
                UITabBar.appearance().unselectedItemTintColor = UIColor.gray // Unselected item colorr
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor(Color(white:0.05).opacity(0.93))
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
                let appearanceN = UINavigationBarAppearance()
                appearanceN.configureWithOpaqueBackground()
                appearanceN.backgroundColor = UIColor(Color(white:0.05).opacity(0.93))
                appearanceN.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearanceN.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
                UINavigationBar.appearance().standardAppearance = appearanceN
                UINavigationBar.appearance().scrollEdgeAppearance = appearanceN
                UINavigationBar.appearance().compactAppearance = appearanceN
                UINavigationBar.appearance().tintColor = .green
                if matchLength==0 && first==true {
                    sets1=1; sets2=1
                    tiebreakThird=true
                }
                if first==true {selection=0; startTimer();first=false}
                matches=UserDefaults.standard.array(forKey: "matches") as? [Int] ?? [Int]()
            }
            .onChange(of: elapsedTime) { old, new in
                time=timeString(from: elapsedTime)
            }
            .navigationBarBackButtonHidden((isNamesInputed>0) ? true : false) // Hide default back button
            .alert("Warning", isPresented: $terminationObserver.showClose) {
                       Button("OK", role: .cancel) { }
                   } message: {
                       Text("You have unsaved data that will be lost if the app is closed.")
                   }
            .alert("Are you sure?", isPresented: $showRestart) {
                Button("Restart", role: .destructive) {
                    restart()
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("This action cannot be undone.")
            }
            .alert(isPresented: $showBack) {
                Alert(
                    title: Text("Are you sure? Match will not be saved."),
                    message: Text("Do you want to go back?"),
                    primaryButton: .destructive(Text("Yes")) {
                        path.removeAll()
                        restart()
                    },
                    secondaryButton: .cancel(Text("No")) // Stay on the current view
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showBack = true // Show the alert when the back button is pressed
                    }) {
                        Image(systemName: "chevron.backward") // Custom back button
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if showUndo {
                            if result.keyShotType=="" || (result.cause=="" && ((statMode1==0 && owner==1) || (statMode2==0 && owner==2))) {
                                if results1.isEmpty && !(results2.isEmpty) {
                                    results2.removeLast()
                                }
                                else if results2.isEmpty && !(results1.isEmpty) {
                                    results1.removeLast()
                                }
                                else if results1.isEmpty && results2.isEmpty {
                                    result = Point(point: 0,server: 0, game: 0, gameN: 0, firstServeIn: false, keyShotType: "",shotType: "",stroke: "", location: "",cause: "",comment: "Enter Comment", rallyLength: "", additionalTrackers: [],set:1,breakp: false,breakpcon: false)
                                }
                                else if results1.last!.point>results2.last!.point {
                                    results1.removeLast()
                                }
                                else if results2.last!.point>results1.last!.point {
                                    results2.removeLast()
                                }
                            }
                            else {
                                result = Point(point: 0, server: 0,game: 0, gameN: 0, firstServeIn: false, keyShotType: "",shotType: "",stroke: "", location: "",cause: "",comment: "Enter Comment", rallyLength: "", additionalTrackers: [],set:1,breakp: false,breakpcon: false)
                            }
                            if lastPointOwn==0 {
                                if points1h==0 && points2h==0 {
                                    if sets1 == 0 && sets2 == 0 {
                                        games11-=1
                                    }
                                    else if (sets1==1) && (sets2==1) {
                                        games13-=1
                                    }
                                    else {
                                        games12-=1
                                    }
                                }
                                else {
                                    if ad==1 {ad=0}
                                }
                            } else {
                                if points1h==0 && points2h==0 {
                                    if sets1 == 0 && sets2 == 0 {
                                      games21-=1
                                    }
                                    else if (sets1==1) && (sets2==1) {
                                        games23-=1
                                    }
                                    else {
                                      games22-=1
                                    }
                                }
                                else {
                                    if ad==2 {ad=0}
                                }
                            }
                            points1h=lastPoints1
                            points2h=lastPoints2
                            if lastServer==0 {server=name1} else {server=name2}
                            if (sets1==1 && sets2==1) && tiebreakThird==true {
                                points1=points1h
                                points2=points2h
                                tiebreakTotalPoints-=1
                            } else {
                                if tiebreakTotalPoints>0 {
                                    points1=points1h
                                    points2=points2h
                                    tiebreakTotalPoints-=1
                                }
                                else if lastPointOwn==0 {
                                    convertPoints(pointsW: &points1, pointsWh: &points1h, pointsL: &points2, pointsLh: &points2h, adSwi: false)
                                } else {
                                    convertPoints(pointsW: &points2, pointsWh: &points2h, pointsL: &points1, pointsLh: &points1h, adSwi: true)
                                }
                            }
                            totalPoints-=1
                            pointPhase=0
                            showUndo=false
                        }
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                            .font(.title3)
                    }
                    .foregroundStyle(Color.accentColor)
                    .padding(.trailing, 3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showRestart=true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .foregroundStyle(Color.red)
                    .padding(.trailing, 3)
                }
                
            }
        }
        
    }
    
    func saveData() {
        matchNum+=1
        matches.append(matchNum)
        if lastPoints1>lastPoints2 {UserDefaults.standard.set(true, forKey: "winner\(matchNum)")}
        else {UserDefaults.standard.set(false, forKey: "winner\(matchNum)")}
        UserDefaults.standard.set(matches, forKey: "matches")
        UserDefaults.standard.set(name1, forKey: "nameA\(matchNum)")
        UserDefaults.standard.set(name2, forKey: "nameB\(matchNum)")
        UserDefaults.standard.set(tiebreakThird, forKey: "tiebreakThird\(matchNum)")
        switch surface {
        case .Clay:
            UserDefaults.standard.set("Clay", forKey: "surface\(matchNum)")
        case .Grass:
            UserDefaults.standard.set("Grass", forKey: "surface\(matchNum)")
        case .Hard:
            UserDefaults.standard.set("Hard", forKey: "surface\(matchNum)")
        }
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

        UserDefaults.standard.set(totalPoints, forKey: "totalPoints\(matchNum)")
        UserDefaults.standard.set(totalGames, forKey: "totalGames\(matchNum)")
        
        encode1(array: results1,key: "resultsA");encode2(array: results2,key: "resultsB")
        print("Saving \(matchNum)")
        UserDefaults.standard.set(additionalTrackers, forKey: "addTrackers\(matchNum)")
        
        resetTimer()
//
        
        if tiebreakThird==true {
            UserDefaults.standard.set(points1h, forKey: "superPointsA\(matchNum)")
            UserDefaults.standard.set(points2h, forKey: "superPointsB\(matchNum)")
        }
        
        path.removeAll()
        isNamesInputed = 0
        pointPhase = 0
    }
    
    func restart() {
        UserDefaults.standard.set(0, forKey: "isNamesInputed")
        name1 = ""
        name2 = ""
        server = ""
        ad = 0
        points1 = 0
        points2 = 0
        points1h = 0
        points2h = 0
        games11 = 0
        games12 = 0
        games21 = 0
        games22 = 0
        games13 = 0
        games23 = 0
        sets1 = 0
        sets2 = 0
        tiebreakThird = true
        tiebreakTotalPoints = 0
        totalGames = 0
        totalPoints = 0
        resetTimer()
        
        path.removeAll()
    }
    
    func convertPoints(pointsW: inout Int, pointsWh: inout Int, pointsL: inout Int, pointsLh: inout Int, adSwi: Bool) {
        switch pointsWh {
        case 0:
            pointsW = 0
        case 1:
            pointsW = 15
        case 2:
            pointsW = 30
        case 3:
            pointsW = 40
        default:
            if adSwi==false {
                ad=1
            }
            else {
                ad=2
            }
        }
        switch pointsLh {
        case 0:
            pointsL = 0
        case 1:
            pointsL = 15
        case 2:
            pointsL = 30
        case 3:
            pointsL = 40
        default:
            if adSwi==false {
                ad=2
            }
            else {
                ad=1
            }
        }
    }
    
    func changeServer() {
        if server==name1 {
            server = name2
        }
        else {
            server=name1
        }
    }
    
    func pointMaker(gamesW: inout Int, gamesL: inout Int, setsW: inout Int, pointsWh: inout Int, pointsW: inout Int, pointsLh: inout Int, pointsL: inout Int, adSwi: Bool) {
        if ( (gamesW==setLen || gamesW==(setLen+1) ) && gamesL==setLen) {
            pointsW=pointsWh
            tiebreakTotalPoints+=1
            if (tiebreakTotalPoints % 2) != 0 {
                changeServer()
            }
            if (pointsWh >= 7) && (pointsLh <= pointsWh-2) {
                setsW+=1
                set+=1
                totalGames+=1
                result.gameN=totalGames
                gamesW+=1
                if winner==1 {result.game=1} else {result.game=2}
                tiebreakTotalPoints=0
                pointsWh=0
                pointsLh=0
            }
        }
        else {
            if ads==false {
                if pointsWh==4 {
                    totalGames+=1
                    result.gameN=totalGames
                    gamesW+=1
                    if winner==1 {result.game=1} else {result.game=2}
                    changeServer()
                    pointsWh=0
                    pointsLh=0
                    ad=0
                }
            }
            else {
                if (pointsWh==4) && (pointsLh != 3) && (pointsLh != 4) {
                    totalGames+=1
                    result.gameN=totalGames
                    gamesW+=1
                    if winner==1 {result.game=1} else {result.game=2}
                    changeServer()
                    pointsWh=0
                    pointsLh=0
                    ad=0
                }
                if pointsWh==5 {
                    changeServer()
                    totalGames+=1
                    result.gameN=totalGames
                    gamesW+=1
                    if winner==1 {result.game=1} else {result.game=2}
                    pointsWh=0
                    pointsLh=0
                    ad=0
                }
                if pointsWh==4 && pointsLh==4 {
                    pointsWh=3
                    pointsLh=3
                    ad=0
                }
            }
            if (gamesW==setLen || gamesW==(setLen+1)) && ((gamesL != gamesW-1) && (gamesL != gamesW)) {
                setsW+=1
                set+=1
                changeServer()
                pointsWh=0
                pointsLh=0
                ad=0
            }
            convertPoints(pointsW: &pointsW, pointsWh: &pointsWh, pointsL: &pointsL, pointsLh: &pointsLh, adSwi: adSwi)
        }
    }
    
    func addPoints1() {
        totalPoints+=1
        pointPhase+=1
        lastPoints1=points1h
        lastPoints2=points2h
        lastPointOwn=0
        if server==name1 {lastServer=0} else {lastServer=1}
        showUndo=true
        points1h+=1
        if tiebreakTotalPoints==0 {
            if ads==true && ( (points1h==3 && points2h < 3 && server==name2) || (points1h==4 && points2h == 3 && server==name2) ) {
                result.breakp=true
                print("happen 1 for P1")
            }
            else if ads==true && ( (points1h==4 && points2h < 3 && server==name2) || (points1h==5 && points2h == 3 && server==name2) ) {
                result.breakpcon=true
                print("happen 1B for P1")
            }
            else if ads==false && points1h==3 && server==name2 {
                result.breakp=true
                print("happen 1 for P1 no ad")
            }
            else if ads==false && points1h==4 && server==name2 {
                result.breakpcon=true
                print("happen 1 for P1 no ad")
            }
            
            if ads==true && ( (points2h==3 && points1h < 3 && server==name1) || (points2h==4 && points1h == 3 && server==name1) ) {
                result.breakp=true
                print("happen 1 for P2")
            }
            else if ads==true && ( (points2h==4 && points1h < 3 && server==name1) || (points2h==5 && points1h == 3 && server==name1) ) {
                result.breakpcon=true
                print("happen 1B for P2")
            }
            else if ads==false && points2h==3 && server==name1 {
                result.breakp=true
                print("happen 1 for P2 no ad")
            }
            else if ads==false && points2h==4 && server==name1 {
                result.breakpcon=true
                print("happen 1B for P2 no ad")
            }
        }
        winner=1
        
        if (sets1 == 0) && (sets2 == 0) {
            pointMaker(gamesW: &games11, gamesL: &games21, setsW: &sets1, pointsWh: &points1h, pointsW: &points1, pointsLh: &points2h, pointsL: &points2, adSwi: false)
        }
        else if (sets1==1) && (sets2==1) {
            if tiebreakThird == false {
                pointMaker(gamesW: &games13, gamesL: &games23, setsW: &sets1, pointsWh: &points1h, pointsW: &points1, pointsLh: &points2h, pointsL: &points2, adSwi: false)
            }
            else {
                points1=points1h
                tiebreakTotalPoints+=1
                if (tiebreakTotalPoints % 2) != 0 {
                    if server==name1 {
                        server = name2
                    }
                    else {
                        server=name1
                    }
                }
                if (points1h >= 10) && (points2h <= points1h-2) {
                    sets1+=1
                    tiebreakTotalPoints=0
                }
            }
        }
        else {
            pointMaker(gamesW: &games12, gamesL: &games22, setsW: &sets1, pointsWh: &points1h, pointsW: &points1, pointsLh: &points2h, pointsL: &points2, adSwi: false)
        }
        if ( sets1==1 || sets2==1 ) && matchLength==1 {
            saveData()
        }
        if sets2==2 {
            saveData()
        }
        if sets1==2 {
            saveData()
        }
    }
    
    func addPoints2() {
        totalPoints+=1
        pointPhase+=1
        lastPoints1=points1h
        lastPoints2=points2h
        lastPointOwn=1
        if server==name1 {lastServer=0} else {lastServer=1}
        showUndo=true
        points2h+=1
        if tiebreakTotalPoints==0 {
            if ads==true && ((points1h==3 && points2h < 3 && server==name2) || (points1h==4 && points2h == 3 && server==name2)) {
                result.breakp=true
                print("happen 2 for P1")
            }
            else if ads==true && ((points1h==4 && points2h < 3 && server==name2) || (points1h==5 && points2h == 3 && server==name2)) {
                result.breakpcon=true
                print("happen 2B for P1")
            }
            else if ads==false && points1h==3 && server==name2 {
                result.breakp=true
                print("happen 2 for P1 no ad")
            }
            else if ads==false && points1h==4 && server==name2 {
                result.breakpcon=true
                print("happen 2B for P1 no ad")
            }
            
            if ads==true && ((points2h==3 && points1h < 3 && server==name1) || (points2h==4 && points1h == 3 && server==name1)) {
                result.breakp=true
                print("happen 2 for P2")
            }
            else if ads==true && ((points2h==4 && points1h < 3 && server==name1) || (points2h==5 && points1h == 3 && server==name1)) {
                result.breakpcon=true
                print("happen 2B for P2")
            }
            else if ads==false && points2h==3 && server==name1 {
                result.breakp=true
                print("happen 2 for P2 no ad")
            }
            else if ads==false && points2h==4 && server==name1 {
                result.breakpcon=true
                print("happen 2B for P1 no ad")
            }
        }
        
        winner=2
        if (sets1 == 0) && (sets2 == 0) {
            pointMaker(gamesW: &games21, gamesL: &games11, setsW: &sets2, pointsWh: &points2h, pointsW: &points2, pointsLh: &points1h, pointsL: &points1, adSwi: true)
        }
        else if (sets1==1) && (sets2==1) {
            if tiebreakThird == false {
                pointMaker(gamesW: &games23, gamesL: &games13, setsW: &sets2, pointsWh: &points2h, pointsW: &points2, pointsLh: &points1h, pointsL: &points1, adSwi: true)
            }
            else {
                points2=points2h
                tiebreakTotalPoints+=1
                if (tiebreakTotalPoints % 2) != 0 {
                    if server==name1 {
                        server = name2
                    }
                    else {
                        server=name1
                    }
                }
                if (points2h >= 10) && (points1h <= points2h-2) {
                    sets2+=1
                    tiebreakTotalPoints=0
                }
            }
        }
        else {
            pointMaker(gamesW: &games22, gamesL: &games12, setsW: &sets2, pointsWh: &points2h, pointsW: &points2, pointsLh: &points1h, pointsL: &points1, adSwi: true)
        }
        if ( sets1==1 || sets2==1 ) && matchLength==1 {
            saveData()
        }
        if sets2==2 {
            saveData()
        }
        if sets1==2 {
            saveData()
        }
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}




#Preview {
    ContentView()
}
