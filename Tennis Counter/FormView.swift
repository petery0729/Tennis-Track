//
//  NameView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 6/19/24.
//

import Foundation
import SwiftUI

struct FormView: View {
    
    @Binding var name1: String
    @Binding var name2: String
    @State var name1f = ""
    @State var name2f = ""
    @Binding var server: String
    @Binding var isNamesInputed: Int
    @Binding var tiebreakThird: Bool
    
    @Binding var statMode1: Int
    @Binding var statMode2: Int
    @Binding var setLen: Int
    @Binding var matchLength: Int
    @Binding var additionalTrackers: [String]
    @Binding var ads: Bool
    @Binding var surface: Surface
    @Binding var date: Date
    
    @State var tracker = ""
    @State var ani = 1.0
    @State var trackerN = 1
    @State var showAlert = false

                
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Form {
                    Section {
                        TextField("", text: $name1f, prompt: Text("Player 1").foregroundColor(.gray))
                            .frame(height: 30,alignment: .topLeading)
                            .listRowBackground(Color(white: 0.2))
                            .foregroundStyle(Color.white)
                            .onChange(of: name1f) { oldValue, newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    name1=name1f
                                    name2=name2f
                                }
                            }
                        TextField("", text: $name2f, prompt: Text("Player 2").foregroundColor(.gray))
                            .frame(height: 30,alignment: .topLeading)
                            .listRowBackground(Color(white: 0.2))
                            .foregroundStyle(Color.white)
                            .onChange(of: name2f) { oldValue, newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    name1=name1f
                                    name2=name2f
                                }
                            }
                    }
                    header: {
                        Text("Enter Player Names")
                            .foregroundStyle(Color.white)
                    }
                    .listRowSeparatorTint(.white)
                    if name2.isEmpty != true {
                        Section { 
                            VStack {
                                Text("Server")
                                    .listRowBackground(Color(white: 0.1))
                                    .padding(.bottom)
                                if name2 != "" {
                                    Picker(selection: $server) {
                                        Text(name1).tag(name1)
                                            .foregroundStyle(Color.white)
                                        Text(name2).tag(name2)
                                            .foregroundStyle(Color.white)
                                    } label: {
                                        Text("Server?")
                                    }
                                    .listRowBackground(Color(white: 0.1))
                                    .pickerStyle(.segmented)
                                    .background(Color(white: 0.1))
                                    .frame(height: 30,alignment: .topLeading)
                                    .padding(.bottom)
                                }
                                Text("Match Length")
                                    .listRowBackground(Color(white: 0.1))
                                    .background(Color(white: 0.1))
                                    .padding(.bottom,5)
                                Picker(selection: $matchLength) {
                                    Text("Super Tiebreak").tag(0)
                                    Text("One Set").tag(1)
                                    Text("Full Match").tag(2)
                                } label: {
                                    Text("")
                                }
                                .listRowBackground(Color(white: 0.1))
                                .background(Color(white: 0.1))
                                .pickerStyle(.segmented)
                                .frame(height: 30,alignment: .topLeading)
                                if matchLength>0 {
                                    Text("Set Length")
                                        .listRowBackground(Color(white: 0.1))
                                        .background(Color(white: 0.1))
                                    Picker(selection: $setLen) {
                                        Text("4").tag(4)
                                        Text("6").tag(6)
                                        Text("8").tag(8)
                                    } label: {
                                        Text("")
                                    }
                                    .listRowBackground(Color(white: 0.1))
                                    .background(Color(white: 0.1))
                                    .pickerStyle(.segmented)
                                    .frame(height: 30,alignment: .topLeading)
                                    Picker(selection: $ads) {
                                        Text("Ad Scoring").tag(true)
                                        Text("No Ad").tag(false)
                                    } label: {
                                        Text("")
                                    }
                                    .listRowBackground(Color(white: 0.1))
                                    .background(Color(white: 0.1))
                                    .pickerStyle(.segmented)
                                    .frame(height: 30,alignment: .topLeading)
                                    if matchLength>1 {
                                        Picker(selection: $tiebreakThird) {
                                            Text("Tiebreak Third").tag(true)
                                            Text("Third Set").tag(false)
                                        } label: {
                                            Text("")
                                        }
                                        .listRowBackground(Color(white: 0.1))
                                        .background(Color(white: 0.1))
                                        .pickerStyle(.segmented)
                                        .frame(height: 30,alignment: .topLeading)
                                    }
                                }
                                Picker(selection: $surface) {
                                    Text("Hard").tag(Surface.Hard)
                                    Text("Clay").tag(Surface.Clay)
                                    Text("Grass").tag(Surface.Grass)
                                } label: {
                                    Text("")
                                }
                                .listRowBackground(Color(white: 0.1))
                                .background(Color(white: 0.1))
                                .pickerStyle(.segmented)
                                .frame(height: 30,alignment: .topLeading)
                                .padding(.bottom,5)
                                DatePicker("Date", selection: $date, displayedComponents: .date)
                                    .padding(.horizontal)
                                    .listRowBackground(Color(white: 0.1))
                                    .background(Color(white: 0.1))
                                    .frame(height: 30,alignment: .topLeading)
                                    .foregroundStyle(Color.white)
                                    .preferredColorScheme(.dark)
                            }
                            .listRowBackground(Color(white: 0.1))
                        } header: {
                            Text("Configure Match")
                        }
                        Section {
                            if name2 != "" {
                                Text(name1)
                                    .listRowBackground(Color(white: 0.1))
                                    .background(Color(white: 0.1))
                                Picker(selection: $statMode1) {
                                    Text("No Stats").tag(0)
                                    Text("Basic Stats").tag(1)
                                    Text("Full Stats").tag(2)
                                } label: {
                                    Text("")
                                }
                                .listRowBackground(Color(white: 0.1))
                                .background(Color(white: 0.1))
                                .pickerStyle(.segmented)
                                .frame(height: 30,alignment: .topLeading)
                                Text(name2)
                                    .listRowBackground(Color(white: 0.1))
                                    .background(Color(white: 0.1))
                                Picker(selection: $statMode2) {
                                    Text("No Stats").tag(0)
                                    Text("Basic Stats").tag(1)
                                    Text("Full Stats").tag(2)
                                } label: {
                                    Text("")
                                }
                                .listRowBackground(Color(white: 0.1))
                                .background(Color(white: 0.1))
                                .pickerStyle(.segmented)
                                .frame(height: 30,alignment: .topLeading)
                            }
                        }
                        header: {
                            Text("Stats")
                                .foregroundStyle(Color.white)
                        }
                        Section {
                            DisclosureGroup("Add Additional Stat Trackers") {
                                List {
                                    HStack {
                                        TextField("", text: $tracker, prompt: Text("Tracker").foregroundColor(.gray))
                                            .frame(height: 30,alignment: .topLeading)
                                            .padding(.vertical,2)
                                            .listRowBackground(Color(white: 0.1))
                                            .foregroundStyle(Color.white)
                                            .cornerRadius(10)
                                        Spacer()
                                        Button() {
                                            additionalTrackers.append(tracker)
                                            tracker=""
                                            ani=1.1
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                ani=1.0
                                            }
                                            
                                        } label: {
                                            Image(systemName: "plus")
                                        }
                                        .frame(width: 44,height: 44)
                                        .background(Color(white:0.05))
                                        .foregroundStyle(Color.accentColor)
                                        .listRowBackground(Color(white:0.1))
                                        .cornerRadius(10)
                                        .frame(alignment: .leading)
                                        .scaleEffect(ani)
                                        .animation(.bouncy, value: ani)
                                    }
                                    .listRowBackground(Color(white:0.1))
                                    if additionalTrackers.isEmpty == false {
                                        ForEach(additionalTrackers, id: \.self) { track in
                                            ForEach(1..<additionalTrackers.count+1) { i in
                                                if additionalTrackers[(i-1)]==track {
                                                    Text("\(i). \(track)")
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(alignment: .leading)
                            }
                            .listRowBackground(Color(white:0.1))
                        } header: {
                            Text("")
                        }
                        .foregroundStyle(Color.white)
                    }
                    
                }
                .foregroundStyle(Color.white)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.visible)
                .navigationTitle("Match Set Up")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if name2.isEmpty != true {
                            Button("Continue") {
                                if server != "" {
                                    isNamesInputed+=1
                                } else {
                                    showAlert=true
                                }
                            }
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .alert("You must enter a server name.", isPresented: $showAlert) {
                    Button("Ok", role: .cancel) {
                        
                    }
                }
//                .background(LinearGradient(colors: [Color(white:0.05),Color(white:0.1)], startPoint: .top, endPoint: .bottom))
            }
            .onAppear() {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                isNamesInputed = 0
            }
        }
    }
}
#Preview {
    ContentView()
}
