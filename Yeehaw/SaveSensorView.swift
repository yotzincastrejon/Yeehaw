//
//  SaveSensorView.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/1/21.
//

import SwiftUI

struct SaveSensorView: View {
    @ObservedObject var bleManager: BLEManager
    @State var id: UUID
    @State var name: String
    @Binding var shouldPopToRootView: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "gearshape")
                    .font(.title3)
                VStack(alignment: .leading) {
                    Text(name)
                        .fontWeight(.bold)
                    
                }
                Spacer()
            }
            .padding()
            .background(Color("DarkElevated"))
            Divider()
            Button(action: {
                    print("Save Sensor Tapped")
                if bleManager.saved.isEmpty {
                    bleManager.saved.append(Saved(id: id, name: name))
                } else {
                    //write a for loop that will go through the entire array to find out whether or not the current peripheral.uid matches any existing one. If it doesn't already exists, you can add it to the saved array.
                    for i in 0...bleManager.saved.count - 1 {
                        //We check if the current device's UUID matches any of our array saved UUID
                        if compare(lhs: id, rhs: bleManager.saved[i].id) {
                            print("yes it exists don't add to list")
                            //Since we found it, we won't add it to our saved list.
                            break
                        } else {
                            //We check if we have traversed the entire array
                            if i == bleManager.saved.count - 1 {
                            print("No it doesn't exist yet")
                                //The device didn't exist yet so we add it!
                                bleManager.saved.append(Saved(id: id, name: name))
                            }
                        }
                    }
                }
                print("LOOK AT WHAT YOU SAVED!!!! WAY TO GO BUBS!")
                print(bleManager.saved)
                saveInformation()
                self.shouldPopToRootView = false
                
            }) {
                Text("Save Sensor".uppercased())
                    .font(Font.custom("RBNo2.1a-Bold", size: 25))
                    .foregroundColor(Color.black)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(10)
                    .background(Color("Skyblue"))
            }
            .padding(.horizontal)
            .padding()
            .background(Color("DarkElevated"))
            Spacer()
        }.navigationBarTitle("Save Sensor".uppercased())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        
    }
    
    func compare(lhs: UUID, rhs: UUID) -> Bool {
        return lhs == rhs
    }
    
    func saveInformation() {
        do {
            let data = try JSONEncoder().encode(bleManager.saved)
            UserDefaults.standard.set(data, forKey: "savedArray")
        } catch  {
            print(error)
        }
    }
    
}

struct SaveSensorView_Previews: PreviewProvider {
    static var previews: some View {
        SaveSensorView(bleManager: BLEManager(), id: UUID(), name: "Tickr", shouldPopToRootView: .constant(true) )
            .preferredColorScheme(.dark)
    }
}
