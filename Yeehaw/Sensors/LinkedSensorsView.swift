//
//  LinkedSensorsView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/30/21.
//

import SwiftUI
import CoreData

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
    
    @State var isShowingSettings = false
    @State var sensorsArray = [String]()
    var body: some View {
        
        VStack {
            
            VStack {
                
                
                //                    NavigationLink(destination: AddNewSensorView(bleManager: bleManager, rootIsActive: $rootIsActive), label: {
                //                        Text("Add New Sensor")
                //                            .foregroundColor(Color("Skyblue"))
                //                            .frame(minWidth: 0, maxWidth: .infinity)
                //                            .padding(15)
                //                            .background(Color("DarkElevated"))
                //                            .border(Color.gray.opacity(0.5))
                //                    })
                //                    .isDetailLink(false)
                //                    .padding(.horizontal)
                
                //                    HStack {
                //                        Image(systemName: "bicycle")
                //                            .font(.title3)
                //                        Text("Cycling".uppercased())
                //                            .font(Font.custom("RBNo2.1a-Bold", size: 20))
                //                        Spacer()
                //                    }
                //                    .padding(.vertical, 15)
                //                    .padding(.leading)
                //                    .background(Color("DarkElevated"))
                //                    .padding(.top,10)
                //
                
                
                List {
                    Section {
                        ForEach(sensors) { sensor in
                            
                            HStack {
                                Text("\(sensor.deviceName ?? "No Name")")
                                Spacer()
                                Text("Not Connected")
                                    .foregroundColor(.secondary)
                                Button(action: {
                                    isShowingSettings = true
                                    
                                }) {
                                    Image(systemName: "info.circle")
                                }
                                
                                
                                NavigationLink(destination: SensorSettings(sensor: sensor), isActive: $isShowingSettings) {
                                    EmptyView()
                                }.hidden()
                                    .frame(width: 0)
                            }
                            .onAppear(perform: getDeviceIDsFromCoreData)
                            
                            
                            
                        }
                        .onDelete(perform: deleteItems)
                        .buttonStyle(BorderlessButtonStyle())
                    } header: {
                        Text("My Devices")
                    }
                    
                    Section {
                        ForEach(bleManager.peripherals) { device in
                            HStack {
                                Text(device.name)
                                Spacer()
                                RSSISignalStrength(rssiSignal: device.rssi)
                            }
                            .onTapGesture {
                                withAnimation {
                                    addSensorToCoreData(name: device.name, id: device.uid)
                                    getDeviceIDsFromCoreData()
                                    for i in 0..<bleManager.peripherals.count {
                                        if bleManager.sensorsArrayDeviceID.contains(bleManager.peripherals[i].uid.description) {
                                            bleManager.peripherals.remove(at: i)
                                            print(bleManager.peripherals)
                                        }
                                    }
                                }
                            }
                        }
                    } header: {
                        HStack {
                            Text("Other Devices")
                            if bleManager.isScanning {
                                ProgressView()
                                    .padding(.leading, 4)
                            }
                        }
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear(perform: bleManager.startScanning)
                .onDisappear(perform: bleManager.stopScanning)
            }
            .padding(.top)
            
        }
        .navigationBarTitle("LINKED SENSORS")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        
    }
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { sensors[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func getDeviceIDsFromCoreData() {
        bleManager.sensorsArrayDeviceID.removeAll()
        for i in 0..<sensors.count {
            bleManager.sensorsArrayDeviceID.append(sensors[i].deviceID ?? "")
        }
    }
    
    private func addSensorToCoreData(name: String, id: UUID) {
        withAnimation {
            let newItem = SavedDevice(context: viewContext)
            newItem.deviceName = name
            newItem.deviceID = id.uuidString
            newItem.timestamp = Date()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
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

