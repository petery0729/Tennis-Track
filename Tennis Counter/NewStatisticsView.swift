//
//  NewStatisticsView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 7/24/24.
//

import SwiftUI
import Charts

struct NewStatisticsView: View {
    
    @Binding var name1: String
    @Binding var name2: String
    
    @Binding var results1: [Point]
    @Binding var results2: [Point]
    
    @State var tab = 0
    @Binding var selection: Int
    @Binding var addTrackers: [String]
    @Binding var surface: Surface
    @Binding var matchLength: Int
    @Binding var setLen: Int
    @Binding var time: String
    @Binding var date: Date
    @Binding var ads: Bool
    @Binding var tiebreakThird: Bool 
    
    @State var first = true
    @State var pointMom = [PercentPoint]()
    @State var gameMom = [PercentPoint]()
    @State var sortedPoints = [sortedPoint]()
    @State var matchLengthStr = ""
    
    func formattedDate(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy" // Format as day/month/year
            return formatter.string(from: date)
        }

    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .all)
            VStack {
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
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.visible)
                    .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
                    .scrollIndicators(.automatic)
                }
                if tab==1 {
                    statView(graph: false, name1: $name1, name2: $name2, results1: $results1, results2: $results2, addTrackers: $addTrackers)
                }
                if tab==2 {
                    statView(graph: true, name1: $name1, name2: $name2, results1: $results1, results2: $results2, addTrackers: $addTrackers)
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
                            .preferredColorScheme(.dark)
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
                        .preferredColorScheme(.dark)
                        
                    }
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
                                    HStack {
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
                                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                                    }
                                    HStack {
                                        Text("Rally Length")
                                            .foregroundStyle(Color.accentColor)
                                        Text("\(point.point.rallyLength)")
                                            .frame(maxWidth: .infinity)
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
                            .padding(.horizontal,10)
                            .listRowBackground(Color(white: 0.1))
                            .foregroundStyle(.white)
                        }
                    }
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
                if first==true {selection=1;first=false}
                switch matchLength {
                case 1:
                    matchLengthStr="One set"
                case 2:
                    matchLengthStr="Three sets"
                default:
                    matchLengthStr="Tiebreak"
                }
            }
        }
    }
}


struct RowSView: View {
    
    var graph: Bool
    @Binding var results1: [Point]
    @Binding var results2: [Point]
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
                            .preferredColorScheme(.dark)
                            .padding()
                            .cornerRadius(10)
                        }
                    } else {
                        if graph==false {
                            Gauge(value: 0, label: {
                                Text("0%")
                            }
                            )
                        } else if statCount1==0.0 {
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
                        } else if statCount1==0.0 {
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
    }
}


struct statView: View {
    var graph:Bool = false
    @Binding var name1: String
    @Binding var name2: String
    @Binding var results1: [Point]
    @Binding var results2: [Point]
    @Binding var addTrackers: [String]
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
                RowSView(graph: graph,results1: $results1, results2: $results2,statT: "1-4 Shots", stat: "1-4", statType: "rallyLength",setsFiltered: $setsFiltered)
                RowSView(graph: graph,results1: $results1, results2: $results2,statT: "4-8 Shots", stat: "4-8", statType: "rallyLength",setsFiltered: $setsFiltered)
                RowSView(graph: graph,results1: $results1, results2: $results2,statT: "8+ Shots", stat: "8+", statType: "rallyLength",setsFiltered: $setsFiltered)
            }, header: {
                Text("Rally Length")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
            Section(content: {
                ForEach(addTrackers, id: \.self) { tracker in
                    RowSView(graph: graph,results1: $results1, results2: $results2,statT: tracker, stat: tracker, statType: "add",setsFiltered: $setsFiltered)
                }
            }, header: {
                Text("Additonal")
            })
            .padding(.horizontal,10)
            .listRowBackground(Color(white: 0.1))
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.visible)
        .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
        .scrollIndicators(.automatic)
    }
}

#Preview {
    ContentView()
}
