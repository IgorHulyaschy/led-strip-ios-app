//
//  ContentView.swift
//  Bedroom-leds
//
//  Created by Ігор Гулящий on 06.05.2024.
//

import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    
    // Replace the placeholder UUIDs with the actual UUIDs from the JSON
    let serviceUUID = CBUUID(string: "ABCE") // Device Information Service UUID
    let characteristicUUID = CBUUID(string: "FFE1") // Custom Characteristic UUID
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            print("Bluetooth is not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            print(services)
            for service in services {
                print(service.uuid)
                if service.uuid == serviceUUID {
                    peripheral.discoverCharacteristics([characteristicUUID], for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == characteristicUUID {
                    self.characteristic = characteristic
                }
            }
        }
    }
    
    func sendCommand(command: String) {
        
        if(peripheral == nil || characteristic == nil) {
            return
        } else {
            guard let data = command.data(using: .utf8), let characteristic = characteristic else { return }
            peripheral?.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
}

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack {
            Button(action: {
                bluetoothManager.sendCommand(command: "1")
            }) {
                Text("White")
            }
            .padding()
            
            Button(action: {
                bluetoothManager.sendCommand(command: "2")
            }) {
                Text("Red")
            }
            .padding()
            
            Button(action: {
                bluetoothManager.sendCommand(command: "3")
            }) {
                Text("Yellow")
            }
            .padding()
            
            Button(action: {
                bluetoothManager.sendCommand(command: "4")
            }) {
                Text("Magenta")
            }
            .padding()
            Button(action: {
                bluetoothManager.sendCommand(command: "5")
            }) {
                Text("Green")
            }
            .padding()
            
            Button(action: {
                bluetoothManager.sendCommand(command: "6")
            }) {
                Text("Phioletoviy")
            }
            .padding()

            Button(action: {
                bluetoothManager.sendCommand(command: "7")
            }) {
                Text("Blue")
            }
            
            
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
