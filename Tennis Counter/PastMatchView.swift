//
//  PastMatchView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 7/22/24.
//
//
//  NewStatisticsView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 7/24/24.
//

import SwiftUI
import Charts
import UniformTypeIdentifiers

struct PastMatchView: View {
    var match: Int
    @Binding var update: Bool
    @Binding var path: [Int]
    
    @State var name1: String = ""
    @State var name2: String = ""
    
    @State var results1: [Point] = [Point]()
    @State var results2: [Point] = [Point]()
    
    @State var tab = 0
    @State var addTrackers = [String]()
    @State var surface: String = ""
    @State var matchLength: Int = 0
    @State var setLen: Int = 0
    @State var time: String = ""
    @State var date: Date = Date()
    @State var ads: Bool = false
    @State var tiebreakThird: Bool = false
    
    @State var pointMom = [PercentPoint]()
    @State var gameMom = [PercentPoint]()
    @State var sortedPoints = [sortedPoint]()
    @State var matchLengthStr = ""
    @State var gameAmount = 0
    @State var showConfirm = false
    
    
    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Format as day/month/year
        return formatter.string(from: date)
    }
    
    func ReturnDataFloat(vari: String) -> Float {
        return UserDefaults.standard.float(forKey: "\(vari)\(match)")
    }
    func ReturnDataString(vari: String) -> String {
        return UserDefaults.standard.string(forKey: "\(vari)\(match)") ?? ""
    }
    
    func ReturnDataInt(vari: String) -> Int {
        return UserDefaults.standard.integer(forKey: "\(vari)\(match)")
    }
    
    func ReturnDataPercentPointAArray(vari: String) -> [Any] {
        return UserDefaults.standard.array(forKey: "\(vari)\(match)") ?? []
    }
    
    func ReturnDataPointArray(vari: String) -> [Point]? {
        if let data = UserDefaults.standard.data(forKey: "\(vari)\(match)") {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([Point].self, from: data) // Decode `Data` back to array of `Person`
                print("Worked")
                return result
            } catch {
                print("Failed to decode data: \(error)")
                return nil
            }
        } else {
            print("No data found")
            return nil
        }
    }
    
    
    func deleteMatch() {
        update = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                update = false
            }
        }
        UserDefaults.standard.removeObject(forKey: "nameA")
        UserDefaults.standard.removeObject(forKey: "nameB\(match)")
        UserDefaults.standard.removeObject(forKey: "gamesA1\(match)")
        UserDefaults.standard.removeObject(forKey: "gamesB1\(match)")
        UserDefaults.standard.removeObject(forKey: "gamesA2\(match)")
        UserDefaults.standard.removeObject(forKey: "gamesB2\(match)")
        UserDefaults.standard.removeObject(forKey: "gamesA3\(match)")
        UserDefaults.standard.removeObject(forKey: "gamesB3\(match)")
        UserDefaults.standard.removeObject(forKey: "tiebreakThird\(match)")
        UserDefaults.standard.removeObject(forKey: "results1A\(match)")
        UserDefaults.standard.removeObject(forKey: "results2B\(match)")
        UserDefaults.standard.removeObject(forKey: "addTrackers\(match)")
        UserDefaults.standard.removeObject(forKey: "surface\(match)")
        UserDefaults.standard.removeObject(forKey: "matchLength\(match)")
        UserDefaults.standard.removeObject(forKey: "setLen\(match)")
        UserDefaults.standard.removeObject(forKey: "time\(match)")
        UserDefaults.standard.removeObject(forKey: "date\(match)")
        UserDefaults.standard.removeObject(forKey: "ads\(match)")
        UserDefaults.standard.set(true, forKey: "delete\(match)")
        path.removeLast()
    }
    
    @State private var selectedFileData: FileData? = nil
    @State private var showDocumentPicker = false
    @State private var fileUrl: URL? = nil
    @State private var showShareSheet = false
    
    // Method to export JSON to a file and allow sharing
    func exportJSON() {
        // Step 1: Create a dictionary to hold both arrays
        let dataToExport = FileData(match: match, results1: results1, results2: results2, name1: name1, name2: name2, tiebreakThird: tiebreakThird, surface: surface, matchLength: matchLength, setLen: setLen, time: time, date: date, ads: ads, games11: ReturnDataInt(vari: "gamesA1"), games21: ReturnDataInt(vari: "gamesB1"), games12: ReturnDataInt(vari: "gamesA2"), games22: ReturnDataInt(vari: "gamesB2"), games13: ReturnDataInt(vari: "gamesA3"), games23: ReturnDataInt(vari: "games23"), delete: UserDefaults.standard.bool(forKey: "delete\(match)"), additionalTrackers: addTrackers, superPoints1: ReturnDataInt(vari: "superPointsA"), superPoints2: ReturnDataInt(vari: "superPointsB"))
        
        // Step 2: Encode the dictionary into JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(dataToExport)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                // Step 3: Save the JSON data to a temporary file
                let fileURL = documentsDirectory.appendingPathComponent("\(name1) vs. \(name2).json")
                
                // Step 4: Store the file URL and show the share sheet
                fileUrl = fileURL
                showShareSheet = true
                // Write the JSON to file
                try jsonData.write(to: fileURL)
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    print("File exists at path: \(fileURL.path)")
                } else {
                    print("File does not exist")
                }
                do {
                    let jsonData = try Data(contentsOf: fileURL)
                    print("Successfully read file")
                } catch {
                    print("Error reading file: \(error.localizedDescription)")
                }
            }
            
        } catch {
            print("Failed to encode or save JSON: \(error.localizedDescription)")
        }
    }
    func shareFile(url: URL) {
        do {
            let jsonData = try Data(contentsOf: url)
            print("Successfully read file")
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
        do {
            let jsonData = try Data(contentsOf: url)
            print("Successfully read file")
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
    }
    

        
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .all)
            VStack {
                VStack {
                    HStack(spacing:0) {
                        VStack(alignment: .leading, spacing:0) {
                            Text("\(name1)")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 5)
                            DividerC()
                            Text("\(name2)")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 5)
                        }
                        .background(Color(white:0.2))
                        if tiebreakThird==false || matchLength==1 {
                            VStack(spacing:0) {
                                ButtonPView(data: (ReturnDataInt(vari: "gamesA1")))
                                DividerC()
                                ButtonPView(data: (ReturnDataInt(vari: "gamesB1")))
                            }
                            .frame(width: 40)
                            .background(Color(white:0.2))
                            VStack(spacing:0) {
                                ButtonPView(data: ReturnDataInt(vari: "gamesA2"))
                                DividerC()
                                ButtonPView(data: ReturnDataInt(vari: "gamesB2"))
                            }
                            .frame(width: 40)
                            .background(Color(white:0.2))
                            VStack(spacing:0) {
                                ButtonPView(data: ReturnDataInt(vari: "gamesA3"))
                                DividerC()
                                ButtonPView(data: ReturnDataInt(vari: "gamesB3"))
                            }
                            .frame(width: 40)
                            .background(Color(white:0.2))
                        } else {
                            VStack(spacing:0) {
                                ButtonPView(data: ReturnDataInt(vari: "superPointsA"))
                                DividerC()
                                ButtonPView(data: ReturnDataInt(vari: "superPointsB"))
                            }
                            .background(Color(white:0.2))
                        }
                    }
                    .frame(width:300,height:80)
                    .padding(.horizontal, 40)
                    .cornerRadius(10)
                }
                .cornerRadius(10)
                Divider() .background(Color.white)
                Picker(selection: $tab) {
                    Text("Info").tag(0)
                    Text("Stats").tag(1)
                    Text("Graphs").tag(2)
                    Text("Momentum").tag(3)
                    Text("Log").tag(4)
                } label: {
                    Text("")
                }
                .background(Color(white: 0.1))
                .pickerStyle(.segmented)
                .frame(height: 50,alignment: .topLeading)
                .padding(.top, 5)
                if tab==0 {
                    List {
                        HStack {
                            Spacer()
                            Text(name1) .font(.title2)
                            Text("")
                                .frame(width:(UIScreen.screenWidth/4))
                            Text(name2) .font(.title2)
                            Spacer()
                        }
                        .padding(.horizontal,10)
                        .listRowBackground(Color(white: 0.1))
                        GridRow {
                            Text("Match Format: ")
                                .foregroundStyle(Color.accentColor)
                            if matchLength==0 {
                                Text("One Super-Tiebreak")
                            } else {
                                if tiebreakThird {
                                    if ads {
                                        Text("\(matchLengthStr) of \(setLen) with a super-tiebreak for the third set and with ads")
                                    } else {
                                        Text("\(matchLengthStr) of \(setLen) with a super-tiebreak for the third set and with no ads")
                                    }
                                } else {
                                    if ads {
                                        Text("\(matchLengthStr) of \(setLen) with ads")
                                    } else {
                                        Text("\(matchLengthStr) of \(setLen) with ads")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal,10)
                        .listRowBackground(Color(white: 0.1))
                        .onAppear() {
                            self.name1 = ReturnDataString(vari:"nameA")
                            self.name2 = ReturnDataString(vari:"nameB")
                            self.results1 = ReturnDataPointArray(vari: "resultsA") ?? [Point]()
                            self.results2 = ReturnDataPointArray(vari: "resultsB") ?? [Point]()
                            self.addTrackers = UserDefaults().stringArray(forKey: "addTrackers\(match)") ?? [String]()
                            self.surface = UserDefaults().string(forKey: "surface\(match)") ?? ""
                            self.matchLength = ReturnDataInt(vari: "matchLength")
                            self.setLen = ReturnDataInt(vari: "setLen")
                            self.time =  ReturnDataString(vari: "time")
                            self.date = UserDefaults().object(forKey: "date\(match)") as? Date ?? Date()
                            self.ads = UserDefaults().bool(forKey: "ads\(match)")
                            self.tiebreakThird = UserDefaults().bool(forKey: "tiebreakThird\(match)")
                            switch matchLength {
                            case 1:
                                matchLengthStr="One set"
                            case 2:
                                matchLengthStr="Three sets"
                            default:
                                matchLengthStr="Tiebreak"
                            }
                            
                        }
                        GridRow {
                            Text("Surface: ")
                                .foregroundStyle(Color.accentColor)
                            Text("\(surface)")
                        }
                        .padding(.horizontal,10)
                        .listRowBackground(Color(white: 0.1))
                        GridRow {
                            Text("Date: ")
                                .foregroundStyle(Color.accentColor)
                            Text("\(formattedDate(from: date))")
                        }
                        .padding(.horizontal,10)
                        .listRowBackground(Color(white: 0.1))
                        GridRow {
                            Text("Duration: ")
                                .foregroundStyle(Color.accentColor)
                            Text("\(time)")
                        }
                        .padding(.horizontal,10)
                        .listRowBackground(Color(white: 0.1))
                    }
                    .foregroundStyle(Color.white)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.visible)
                    .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                    .scrollIndicators(.automatic)
                }
                if tab==1 {
                    statPView(graph: false, name1: name1, name2: name2, results1: results1, results2: results2, addTrackers: addTrackers)
                }
                if tab==2 {
                    statPView(graph: true, name1: name1, name2: name2, results1: results1, results2: results2, addTrackers: addTrackers)
                }
                if tab==3 {
                    List {
                        Text("Points")
                            .listRowBackground(Color(white: 0.1))
                        Chart {
                            ForEach(pointMom) { d in
                                LineMark(x: .value("Point", d.point), y: .value("Momentum", d.percent))
                                    .foregroundStyle(Color.green)
                            }
                        }
                        .foregroundStyle(.white)
                        .background(Color.black)
                        .chartYScale(range: .plotDimension(padding: 10))
                        .chartXAxisLabel("Point", alignment: .bottom)
                        .chartYAxisLabel("Momentum", alignment: .top)
                        .padding()
                        .cornerRadius(10)
                        .padding(.horizontal,10)
                        .listRowBackground(Color(white: 0.1))
                        Text("Games")
                            .listRowBackground(Color(white: 0.1))
                        Chart {
                            ForEach(gameMom) { d in
                                LineMark(x: .value("Game", d.point), y: .value("Momentum", d.percent))
                                    .foregroundStyle(Color.green)
                            }
                        }
                        .foregroundStyle(.white)
                        .background(Color.black)
                        .chartYScale(range: .plotDimension(padding: 10))
                        .chartXAxisLabel("Game", alignment: .bottom)
                        .chartYAxisLabel("Momentum", alignment: .top)
                        .padding()
                        .cornerRadius(10)
                        .padding(.horizontal,10)
                        .listRowBackground(Color(white: 0.1))
                        
                    }
                    .foregroundStyle(Color.white)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.visible)
                    .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                    .scrollIndicators(.automatic)
                    .onAppear() {
                        pointMom.removeAll()
                        gameMom.removeAll()
                        for point in results1 {
                            if point.keyShotType=="winner" || point.keyShotType=="ace" {
                                pointMom.append(PercentPoint(point: point.point, percent: 0))
                            } else {
                                pointMom.append(PercentPoint(point: point.point, percent: 1))
                            }
                        }
                        for point in results2 {
                            if point.keyShotType=="winner" || point.keyShotType=="ace" {
                                pointMom.append(PercentPoint(point: point.point, percent: 1))
                            } else {
                                pointMom.append(PercentPoint(point: point.point, percent: 0))
                            }
                        }
                        pointMom.sort {$0.point<$1.point}
                        for point in results1 {
                            if point.game==1 {
                                gameMom.append(PercentPoint(point: point.gameN, percent: 0))
                            } else if point.game==2 {
                                gameMom.append(PercentPoint(point: point.gameN, percent: 1))
                            }
                        }
                        for point in results2 {
                            if point.game==2 {
                                gameMom.append(PercentPoint(point: point.gameN, percent: 1))
                            } else if point.game==1 {
                                gameMom.append(PercentPoint(point: point.gameN, percent: 0))
                            }
                        }
                        gameMom.sort {$0.point<$1.point}
                    }
                }
                if tab==4 {
                    List {
                        ForEach($sortedPoints) { $point in
                            VStack(alignment:.center) {
                                Text(point.owner==1 ? name1:name2)
                                    .font(.title2)
                                    .padding(.bottom, 5)
                                Grid(alignment: .topLeading, verticalSpacing: 5) {
                                    GridRow {
                                        Text("Point")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.point)")
                                            .padding(.trailing,10)
                                        Text("Stroke")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.stroke)")
                                    }
                                    GridRow {
                                        Text("Server")
                                            .foregroundStyle(Color.accentColor)
                                        Text(point.point.server==1 ? name1: name2)
                                        Text("first Serve")
                                            .foregroundStyle(Color.accentColor)
                                        Text(point.point.firstServeIn ? "In":"Out")
                                    }
                                    HStack() {
                                        Text("Key Shot")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.keyShotType)")
                                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                                    }
                                    HStack {
                                        Text("Location")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.location)")
                                            .frame(maxWidth: .infinity)
                                    }
                                    HStack {
                                        Text("Cause")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.cause)")
                                            .frame(maxWidth: .infinity)
                                    }
                                    HStack {
                                        Text("Shot Type")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.shotType)")
                                            .frame(maxWidth: .infinity)
                                    }
                                    HStack {
                                        Text("Rally Length")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.rallyLength)")
                                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                                    }
                                    HStack {
                                        Text("Comment")
                                            .foregroundStyle(Color.accentColor)
                                        Text(point.point.comment=="Enter Comment" ? "":point.point.comment)
                                            .frame(maxWidth: .infinity)
                                    }
                                    ForEach(addTrackers, id: \.self) { tracker in
                                        HStack {
                                            Text(tracker)
                                                .foregroundStyle(Color.accentColor)
                                            ForEach(point.point.additionalTrackers, id: \.self) {track in
                                                if tracker==track {
                                                    Text(point.point.additionalTrackers.isEmpty ? "":"Yes")
                                                } else {
                                                    Text("No")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal,10)
                            .listRowBackground(Color(white: 0.1))
                            .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.visible)
                    .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                    .scrollIndicators(.automatic)
                    .onAppear() {
                        sortedPoints.removeAll()
                        for point in results1 {
                            sortedPoints.append(sortedPoint(point: point, owner: 1))
                        }
                        for point in results2 {
                            sortedPoints.append(sortedPoint(point: point, owner: 2))
                        }
                        sortedPoints.sort {$0.point.point<$1.point.point}
                    }
                }
            }
            .onAppear() {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            }
            .alert("Are you sure?", isPresented: $showConfirm) {
                Button("Delete", role: .destructive) {
                    deleteMatch()
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showConfirm=true
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundStyle(Color.red)
                .padding(.trailing, 3)

            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    exportJSON()
                    if let fileUrl {
                        shareFile(url: fileUrl)
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up") // Share icon
                }
            }
                

        }

    }
}



extension UTType {
    static var json: UTType {
        UTType(exportedAs: "com.results")
    }
}



struct RowSPView: View {
    
    var graph: Bool
    var results1: [Point]
    var results2: [Point]
    var statT: String
    var stat: String
    var statType: String
    @Binding var setsFiltered: Int
    @State var statCount1:Float = 0.0
    @State var statCount2:Float = 0.0
    @State var total1:Float = 0.0
    @State var total2:Float = 0.0
    @State var percent1:Float = 0.0
    @State var percent2:Float = 0.0
    @State var points1=[PercentPoint]()
    @State var points2=[PercentPoint]()
    @State var count=0
    @State var results1c = [Point]()
    @State var results2c = [Point]()
    
    
    var body: some View {
        VStack {
            Text("\(statT)")
            HStack {
                Spacer()
                VStack {
                    Text(stat=="breakPointCon" ? "\(Int(statCount1))/\(Int(total1))":"\(Int(statCount1))")
                    if total1>0 {
                        if graph==false {
                            Gauge(value: percent1, label: {
                                Text("\(Int(100*percent1))%")
                            }
                            )
                        } else {
                            Chart {
                                ForEach(points1) { d in
                                    LineMark(x: .value("Point", d.point), y: .value(statT, (d.percent*100)))
                                        .foregroundStyle(Color.green)
                                }
                            }
                            .foregroundStyle(.white)
                            .frame(width: 125,height: 125)
                            .background(Color.black)
                            .chartYScale(range: .plotDimension(padding: 10))
                            .chartXAxisLabel("Point", alignment: .bottom)
                            .chartYAxisLabel(statT, alignment: .top)
                            .padding()
                            .cornerRadius(10)
                        }
                    } else {
                        if graph==false {
                            Gauge(value: 0, label: {
                                Text("0%")
                            }
                            )
                        } else {
                            Chart {
                                LineMark(x: .value("Point", 0), y: .value(statT, 0))
                                    .foregroundStyle(Color.green)
                            }
                            .foregroundStyle(.white)
                            .frame(width: 125,height: 125)
                            .background(Color.black)
                            .chartYScale(range: .plotDimension(padding: 10))
                            .chartXAxisLabel("Point", alignment: .bottom)
                            .chartYAxisLabel(statT, alignment: .top)
                            .padding()
                            .cornerRadius(10)
                        }
                    }
                }
                Spacer()
                VStack {
                    Text(stat=="breakPointCon" ? "\(Int(statCount2))/\(Int(total2))":"\(Int(statCount2))")
                    if total2>0 {
                        if graph==false {
                            Gauge(value: percent2, label: {
                                Text("\(Int(100*percent2))%")
                            }
                            )
                        } else {
                            Chart {
                                ForEach(points2) { d in
                                    LineMark(x: .value("Point", d.point), y: .value(statT, (d.percent*100)))
                                        .foregroundStyle(Color.green)
                                }
                            }
                            .foregroundStyle(.white)
                            .frame(width: 125,height: 125)
                            .background(Color.black)
                            .chartYScale(range: .plotDimension(padding: 10))
                            .chartXAxisLabel("Point", alignment: .bottom)
                            .chartYAxisLabel(statT, alignment: .top)
                            .padding()
                            .cornerRadius(10)
                        }
                    } else {
                        if graph==false {
                            Gauge(value: 0, label: {
                                Text("0%")
                            }
                            )
                        } else {
                            Chart {
                                LineMark(x: .value("Point", 0), y: .value(statT, 0))
                                    .foregroundStyle(Color.green)
                            }
                            .foregroundStyle(.white)
                            .frame(width: 125,height: 125)
                            .background(Color.black)
                            .chartYScale(range: .plotDimension(padding: 10))
                            .chartXAxisLabel("Point", alignment: .bottom)
                            .chartYAxisLabel(statT, alignment: .top)
                            .padding()
                            .cornerRadius(10)
                        }
                    }
                }
                Spacer()
            }.onAppear() {
                statCount1=0.0
                statCount2=0.0
                total1=0.0
                total2=0.0
                points1=[]
                points2=[]
                for point in results1 {
                    switch statType {
                    case "firstServe":
                        if point.firstServeIn==true{
                            if point.server==1 {
                                statCount1+=1
                            }
                            else {
                                statCount2+=1
                            }
                        }
                        if point.server==1 {
                            total1+=1
                        }
                        else {
                            total2+=1
                        }
                    case "breakPointCon":
                        if point.breakpcon==true{
                            if point.server==2 {
                                statCount1+=1
                            }
                            else {
                                statCount2+=1
                            }
                        }
                        if point.server==1 {
                            if point.breakp==true {total2+=1}
                        }
                        else {
                            if point.breakp==true {total1+=1}
                        }
                    case "keyShotType":
                        if point.keyShotType==stat {
                            self.statCount1+=1
                        }
                        if point.keyShotType != "" {
                            total1+=1
                        }
                    case "shotType":
                        if point.shotType==stat {
                            self.statCount1+=1
                        }
                        if point.shotType != "" {
                            total1+=1
                        }
                    case "stroke":
                        if point.stroke==stat {
                            self.statCount1+=1
                        }
                        if point.stroke != "" {
                            total1+=1
                        }
                    case "location":
                        if point.location==stat {
                            self.statCount1+=1
                        }
                        if point.location != "" {
                            total1+=1
                        }
                    case "cause":
                        if point.cause != "" {
                            if point.cause==stat {
                                self.statCount1+=1
                            }
                            total1+=1
                        }
                    case "rallyLength":
                        if point.rallyLength==stat {
                            self.statCount1+=1
                        }
                        if point.rallyLength != "" {
                            total1+=1
                        }
                    default:
                        for add in point.additionalTrackers {
                            if add==stat {
                                self.statCount1+=1
                            }
                            total1+=1
                        }
                    }
                    percent1=(statCount1/total1)
                    points1.append(PercentPoint(point: point.point, percent: percent1))
                }
                for point in results2 {
                    switch statType {
                    case "firstServe":
                        if point.firstServeIn==true{
                            if point.server==1 {
                                statCount1+=1
                            }
                            else {
                                statCount2+=1
                            }
                        }
                        if point.server==1 {
                            total1+=1
                        }
                        else {
                            total2+=1
                        }
                    case "breakPointCon":
                        if point.breakpcon==true{
                            if point.server==2 {
                                statCount1+=1
                            }
                            else {
                                statCount2+=1
                            }
                        }
                        if point.server==1 {
                            if point.breakp==true {total2+=1}
                        }
                        else {
                            if point.breakp==true {total1+=1}
                        }
                    case "keyShotType":
                        if point.keyShotType==stat {
                            self.statCount2+=1
                        }
                        if point.keyShotType != "" {
                            total2+=1
                        }
                    case "shotType":
                        if point.shotType==stat {
                            self.statCount2+=1
                        }
                        if point.shotType != "" {
                            total2+=1
                        }
                    case "stroke":
                        if point.stroke==stat {
                            self.statCount2+=1
                        }
                        if point.stroke != "" {
                            total2+=1
                        }
                    case "location":
                        if point.location==stat {
                            self.statCount2+=1
                        }
                        if point.location != "" {
                            total2+=1
                        }
                    case "cause":
                        if point.cause != "" {
                            if point.cause==stat {
                                self.statCount2+=1
                            }
                            total2+=1
                        }
                    case "rallyLength":
                        if point.rallyLength==stat {
                            self.statCount2+=1
                        }
                        if point.rallyLength != "" {
                            total2+=1
                        }
                    default:
                        for add in point.additionalTrackers {
                            if add==stat {
                                self.statCount2+=1
                            }
                            total2+=1
                        }
                    }
                    percent2=(statCount2/total2)
                    points2.append(PercentPoint(point: point.point, percent: percent2))
                }
                if graph==true {count+=1}
                percent1=(statCount1/total1)
                percent2=(statCount2/total2)

            }
            .onChange(of: setsFiltered, { oldValue, newValue in
                statCount1=0.0
                statCount2=0.0
                total1=0.0
                total2=0.0
                points1=[]
                points2=[]
                results1c = results1.filter { point in
                    point.set==setsFiltered
                }
                results2c = results2.filter { point in
                    point.set==setsFiltered
                }
                if setsFiltered==0 {
                    for point in results1 {
                        switch statType {
                        case "firstServe":
                            if point.firstServeIn==true{
                                if point.server==1 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                total1+=1
                            }
                            else {
                                total2+=1
                            }
                        case "breakPointConv":
                            if point.breakpcon==true{
                                if point.server==2 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                if point.breakp==true {total2+=1}
                            }
                            else {
                                if point.breakp==true {total1+=1}
                            }
                        case "keyShotType":
                            if point.keyShotType==stat {
                                self.statCount1+=1
                            }
                            if point.keyShotType != "" {
                                total1+=1
                            }
                        case "shotType":
                            if point.shotType==stat {
                                self.statCount1+=1
                            }
                            if point.shotType != "" {
                                total1+=1
                            }
                        case "stroke":
                            if point.stroke==stat {
                                self.statCount1+=1
                            }
                            if point.stroke != "" {
                                total1+=1
                            }
                        case "location":
                            if point.location==stat {
                                self.statCount1+=1
                            }
                            if point.location != "" {
                                total1+=1
                            }
                        case "cause":
                            if point.cause != "" {
                                if point.cause==stat {
                                    self.statCount1+=1
                                }
                                total1+=1
                            }
                        case "rallyLength":
                            if point.rallyLength==stat {
                                self.statCount1+=1
                            }
                            if point.rallyLength != "" {
                                total1+=1
                            }
                        default:
                            for add in point.additionalTrackers {
                                if add==stat {
                                    self.statCount1+=1
                                }
                                total1+=1
                            }
                        }
                        percent1=(statCount1/total1)
                        points1.append(PercentPoint(point: point.point, percent: percent1))
                    }
                    for point in results2 {
                        switch statType {
                        case "firstServe":
                            if point.firstServeIn==true{
                                if point.server==1 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                total1+=1
                            }
                            else {
                                total2+=1
                            }
                        case "breakPointConv":
                            if point.breakpcon==true{
                                if point.server==2 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                if point.breakp==true {total2+=1}
                            }
                            else {
                                if point.breakp==true {total1+=1}
                            }
                        case "keyShotType":
                            if point.keyShotType==stat {
                                self.statCount2+=1
                            }
                            if point.keyShotType != "" {
                                total2+=1
                            }
                        case "shotType":
                            if point.shotType==stat {
                                self.statCount2+=1
                            }
                            if point.shotType != "" {
                                total2+=1
                            }
                        case "stroke":
                            if point.stroke==stat {
                                self.statCount2+=1
                            }
                            if point.stroke != "" {
                                total2+=1
                            }
                        case "location":
                            if point.location==stat {
                                self.statCount2+=1
                            }
                            if point.location != "" {
                                total2+=1
                            }
                        case "cause":
                            if point.cause != "" {
                                if point.cause==stat {
                                    self.statCount2+=1
                                }
                                total2+=1
                            }
                        case "rallyLength":
                            if point.rallyLength==stat {
                                self.statCount2+=1
                            }
                            if point.rallyLength != "" {
                                total2+=1
                            }
                        default:
                            for add in point.additionalTrackers {
                                if add==stat {
                                    self.statCount2+=1
                                }
                                total2+=1
                            }
                        }
                        percent2=(statCount2/total2)
                        points2.append(PercentPoint(point: point.point, percent: percent2))
                    }
                    if graph==true {count+=1}
                    percent1=(statCount1/total1)
                    percent2=(statCount2/total2)
                } else {
                    for point in results1c {
                        switch statType {
                        case "firstServe":
                            if point.firstServeIn==true{
                                if point.server==1 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                total1+=1
                            }
                            else {
                                total2+=1
                            }
                        case "breakPointConv":
                            if point.breakpcon==true{
                                if point.server==2 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                if point.breakp==true {total2+=1}
                            }
                            else {
                                if point.breakp==true {total1+=1}
                            }
                        case "keyShotType":
                            if point.keyShotType==stat {
                                self.statCount1+=1
                            }
                            if point.keyShotType != "" {
                                total1+=1
                            }
                        case "shotType":
                            if point.shotType==stat {
                                self.statCount1+=1
                            }
                            if point.shotType != "" {
                                total1+=1
                            }
                        case "stroke":
                            if point.stroke==stat {
                                self.statCount1+=1
                            }
                            if point.stroke != "" {
                                total1+=1
                            }
                        case "location":
                            if point.location==stat {
                                self.statCount1+=1
                            }
                            if point.location != "" {
                                total1+=1
                            }
                        case "cause":
                            if point.cause != "" {
                                if point.cause==stat {
                                    self.statCount1+=1
                                }
                                total1+=1
                            }
                        case "rallyLength":
                            if point.rallyLength==stat {
                                self.statCount1+=1
                            }
                            if point.rallyLength != "" {
                                total1+=1
                            }
                        default:
                            for add in point.additionalTrackers {
                                if add==stat {
                                    self.statCount1+=1
                                }
                                total1+=1
                            }
                        }
                        percent1=(statCount1/total1)
                        points1.append(PercentPoint(point: point.point, percent: percent1))
                    }
                    for point in results2c {
                        switch statType {
                        case "firstServe":
                            if point.firstServeIn==true{
                                if point.server==1 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                total1+=1
                            }
                            else {
                                total2+=1
                            }
                        case "breakPointConv":
                            if point.breakpcon==true{
                                if point.server==2 {
                                    statCount1+=1
                                }
                                else {
                                    statCount2+=1
                                }
                            }
                            if point.server==1 {
                                if point.breakp==true {total2+=1}
                            }
                            else {
                                if point.breakp==true {total1+=1}
                            }
                        case "keyShotType":
                            if point.keyShotType==stat {
                                self.statCount2+=1
                            }
                            if point.keyShotType != "" {
                                total2+=1
                            }
                        case "shotType":
                            if point.shotType==stat {
                                self.statCount2+=1
                            }
                            if point.shotType != "" {
                                total2+=1
                            }
                        case "stroke":
                            if point.stroke==stat {
                                self.statCount2+=1
                            }
                            if point.stroke != "" {
                                total2+=1
                            }
                        case "location":
                            if point.location==stat {
                                self.statCount2+=1
                            }
                            if point.location != "" {
                                total2+=1
                            }
                        case "cause":
                            if point.cause != "" {
                                if point.cause==stat {
                                    self.statCount2+=1
                                }
                                total2+=1
                            }
                        case "rallyLength":
                            if point.rallyLength==stat {
                                self.statCount2+=1
                            }
                            if point.rallyLength != "" {
                                total2+=1
                            }
                        default:
                            for add in point.additionalTrackers {
                                if add==stat {
                                    self.statCount2+=1
                                }
                                total2+=1
                            }
                        }
                        percent2=(statCount2/total2)
                        points2.append(PercentPoint(point: point.point, percent: percent2))
                    }
                    if graph==true {count+=1}
                    percent1=(statCount1/total1)
                    percent2=(statCount2/total2)
                }
            })
        }
        .foregroundStyle(Color.white)
    }
}


struct statPView: View {
    var graph:Bool = false
    var name1: String
    var name2: String
    var results1: [Point]
    var results2: [Point]
    var addTrackers: [String]
    @State var setsFiltered = 0
    var body: some View {
        List {
            HStack {
                Spacer()
                Text(name1) .font(.title2)
                Text("")
                    .frame(width:(UIScreen.screenWidth/4))
                Text(name2) .font(.title2)
                Spacer()
            }
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Picker(selection: $setsFiltered) {
                Image(systemName: "line.3.horizontal.decrease.circle").tag(0)
                    .foregroundStyle(Color.accentColor)
                Text("First Set").tag(1)
                Text("Second Set").tag(2)
                Text("Third Set or Tiebreak").tag(3)
            } label: {
            }
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                RowSPView(graph: graph,results1: results1, results2: results2, statT: "First Serve", stat: "firstServe", statType: "firstServe",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Ace", stat: "Ace", statType: "keyShotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Double Faults", stat: "Double Fault", statType: "keyShotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Break Points Converted", stat: "breakPointCon", statType: "breakPointCon",setsFiltered: $setsFiltered)
            }, header: {
                Text("Serve and Return")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Winner", stat: "Winner", statType: "keyShotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Net Mistakes", stat: "Net Mistake", statType: "keyShotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Wide Mistakes", stat: "Wide Mistake", statType: "keyShotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Long Mistakes", stat: "Long Mistake", statType: "keyShotType",setsFiltered: $setsFiltered)
            }, header: {
                Text("Key Shots")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Normal Baseline", stat: "Normal Baseline", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Return", stat: "Return", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Inside-Outs", stat: "Inside-Out", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Inside-Ins", stat: "Inside-In", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Slices", stat: "Slice", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Drop Shots", stat: "Drop Shot", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Passing Shots", stat: "Passing Shot", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Lobs", stat: "Lob", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Approach Shots", stat: "Approach", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Volleys", stat: "Volley", statType: "shotType",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Smashes", stat: "Smash", statType: "shotType",setsFiltered: $setsFiltered)
            },header: {
                Text("Shot Types")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Forehand", stat: "Forehand", statType: "stroke",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Backhand", stat: "Backhand", statType: "stroke",setsFiltered: $setsFiltered)
            }, header: {
                Text("Forehands/Backhands")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Cross", stat: "Cross", statType: "location",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Middle", stat: "Middle", statType: "location",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Down the Line", stat: "Down Line", statType: "location",setsFiltered: $setsFiltered)
            }, header: {
                Text("Location")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Forced Error", stat: "Forced Error", statType: "cause",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "Unforced Error", stat: "Unforced Error", statType: "cause",setsFiltered: $setsFiltered)
            }, header: {
                Text("Cause")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "1-4 Shots", stat: "1-4", statType: "rallyLength",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "4-8 Shots", stat: "4-8", statType: "rallyLength",setsFiltered: $setsFiltered)
                RowSPView(graph: graph,results1: results1, results2: results2,statT: "8+ Shots", stat: "8+", statType: "rallyLength",setsFiltered: $setsFiltered)
            }, header: {
                Text("Rally Length")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                ForEach(addTrackers, id: \.self) { tracker in
                    RowSPView(graph: graph,results1: results1, results2: results2,statT: tracker, stat: tracker, statType: "add",setsFiltered: $setsFiltered)
                }
            }, header: {
                Text("Additonal")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
        }
        .foregroundStyle(Color.white)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.visible)
        .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
        .scrollIndicators(.automatic)
    }
}
#Preview {
    ContentView()
}
