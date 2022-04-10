//
//  LinkedSensorsView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/30/21.
//

import SwiftUI

struct LinkedSensorsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavedDevice.timestamp, ascending: false)], animation: .default)
    private var sensors: FetchedResults<SavedDevice>
    @ObservedObject var bleManager: BLEManager
    @Binding var rootIsActive: Bool
    init(bleManager: BLEManager, rootIsActive: Binding<Bool>) {
        self.bleManager = bleManager
        self._rootIsActive = rootIsActive
        //Navigation bar appearance attributes since you can't customize it in SwiftUI
        UINavigationBar.appearance().barTintColor = UIColor(Color("DarkElevated"))
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "RBNo2.1a-Bold", size: 30)!]
    }
    
    var body: some View {
        
        VStack {
            
                VStack {
                    
                                
                    NavigationLink(destination: AddNewSensorView(bleManager: bleManager, rootIsActive: $rootIsActive), label: {
                        Text("Add New Sensor")
                            .foregroundColor(Color("Skyblue"))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(15)
                            .background(Color("DarkElevated"))
                            .border(Color.gray.opacity(0.5))
                    })
                    .isDetailLink(false)
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "bicycle")
                            .font(.title3)
                        Text("Cycling".uppercased())
                            .font(Font.custom("RBNo2.1a-Bold", size: 20))
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    .padding(.leading)
                    .background(Color("DarkElevated"))
                    .padding(.top,10)
                    
                    List {
                        ForEach(sensors) { sensor in
                            HStack {
                                Text("\(sensor.deviceName ?? "No Name")")
                                Spacer()
                                Text("Not Connected")
                                    .foregroundColor(.secondary)
                                Button(action: {
                                    // Do Something
                                }) {
                                Image(systemName: "info.circle")
                                }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.background(Color("DarkElevated"))
                        .listStyle(InsetGroupedListStyle())
                    
                    
                    
                }
                .padding(.top)
                
            
        }
        .navigationBarTitle("Linked Sensors".uppercased())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        
    }
    
}

struct LinkedSensorsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        LinkedSensorsView(bleManager: BLEManager(), rootIsActive: .constant(true))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
        }
    }
}

