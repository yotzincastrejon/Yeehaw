//
//  Home.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 3/17/21.
//

import SwiftUI
import CoreLocation

struct FullScreenMap: View {
    
    @ObservedObject var mapData: MapViewModel
    // Location Manager....
    @State var locationManager = CLLocationManager()
    @State var manager = CLLocationManager()
    @State var alert = false
    var body: some View {
        
        ZStack{
            
            // MapView...
            MapView(manager: $manager, alert: $alert).alert(isPresented: $alert) {
            
                Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                    
                    // Redireting User To Settings...
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenMap(mapData: MapViewModel())
    }
}
