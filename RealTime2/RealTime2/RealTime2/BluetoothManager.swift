import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Central manager and peripherals
    var centralManager: CBCentralManager!
    var discoveredPeripherals: [CBPeripheral] = []
    var selectedPeripheral: CBPeripheral!
    var availableDevices: [String] = [] // Array to store the names of available devices
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Start scanning for peripherals
    func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // Stop scanning for peripherals
    func stopScanning() {
        centralManager.stopScan()
    }
    
    // Connect to a peripheral
    func connect(to peripheral: CBPeripheral) {
        if let selectedPeripheral = selectedPeripheral, selectedPeripheral == peripheral {
            // Already connected to the same peripheral
            return
        }
        
        selectedPeripheral = peripheral
        selectedPeripheral.delegate = self
        centralManager.connect(selectedPeripheral, options: nil)
    }
    
    // Disconnect from the connected peripheral
    func disconnect() {
        if let peripheral = selectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    // CBCentralManagerDelegate methods
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Check if Bluetooth is available and powered on
        if central.state == .poweredOn {
            // Start scanning for peripherals
            startScanning()
        } else {
            // Bluetooth is not available or powered off
            print("Bluetooth is not available.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Add the discovered peripheral to the array
        discoveredPeripherals.append(peripheral)
        // Call the displayAvailableDevices method
        displayAvailableDevices()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Peripheral connected, discover services
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // Peripheral disconnected, handle the disconnection
    }
    
    // CBPeripheralDelegate methods
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            // Found a service, discover characteristics
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            // Found a characteristic, subscribe for notifications
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            
            // Received data from the characteristic, handle it
            let data = String(bytes: value, encoding: .utf8)
            print("Received data: \(data ?? "")")
        }
    }
    
    // Display the list of available devices
    func displayAvailableDevices() {
        availableDevices = discoveredPeripherals.map { peripheral in
            return peripheral.name ?? "Unknown Device"
        }
    }
    
    // Get a peripheral with a specific name
    func getPeripheral(withName name: String) -> CBPeripheral? {
        for peripheral in discoveredPeripherals {
            if peripheral.name == name {
                return peripheral
            }
        }
        return nil
    }
    
}
