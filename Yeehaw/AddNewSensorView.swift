//
//  AddNewSensorView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/30/21.
//

import SwiftUI


struct AddNewSensorView: View {
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
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().sectionIndexBackgroundColor = .clear
    }
    
    var body: some View {
        
        ZStack {
            Color(#colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1))
            AddNewSensorAnimation()
            List(bleManager.peripherals) { peripheral in
                NavigationLink(destination: SaveSensorView(bleManager: bleManager, id: peripheral.uid, name: peripheral.name, shouldPopToRootView: self.$rootIsActive)) {
                    HStack {
                        Text(peripheral.name)
                        Spacer()
                        Text(String(peripheral.rssi))
                    }
                    
                }.isDetailLink(false)
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Add new sensor".uppercased())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
            .onAppear {
                print("Initialized Scanning for peripherals")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    bleManager.startScanning()
                }
            }
            .onDisappear {
                bleManager.stopScanning()
        }
                
        }
        
    }
    
}

struct AddNewSensorView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewSensorView(bleManager: BLEManager(), rootIsActive: .constant(true))
            .preferredColorScheme(.dark)
    }
}
