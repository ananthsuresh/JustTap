//
//  CameraServiceManager.swift
//  GetPeached
//
//  Created by Ananth Suresh on 10/8/16.
//  Copyright © 2016 Fkboinc. All rights reserved.
//



import Foundation
import MultipeerConnectivity
import AssetsLibrary
import AudioToolbox
var prevMatches = [String]()


class CameraServiceManager : NSObject {
    
    fileprivate let ServiceType = "camera-service"
    
    fileprivate let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    
    let serviceBrowser : MCNearbyServiceBrowser
    

    
    var delegate : CameraServiceManagerDelegate?
    
    override init() {
        if let name = UserDefaults.standard.array(forKey: "matches") as? [String]{
            prevMatches = name
        }
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ServiceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        //        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.delegate = self
        //        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        return session
    }()
    
    func startSearching() {
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func stopSearching() {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    

    
    func acceptInvitation() {
        // TO DO: Send string with device name for better security
        do {
            let dataString = "acceptInvitation"
            // ATTEMPT TO SEND DATA TO CAMERA
            try self.session.send((dataString.data(using: String.Encoding.utf8))!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        }
        catch {
            print("SOMETHING WENT WRONG IN CameraServiceManager.toggleFlash()")
        }
    }
    
    
    
    func takePhoto(sendPhoto: Bool) {
        do {
            var boolString = ""
            
            if (sendPhoto) {
                boolString += "true"
                boolString += "\t"
                boolString += finalName
                boolString += "\t"
                boolString += finalNumber
                boolString += "\t" 
                boolString += finalSex
      
                
            } else {
                boolString = "false"
            }
            // ATTEMPT TO SEND DATA TO CAMERA
            try self.session.send((boolString.data(using: String.Encoding.utf8))!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        }
        catch {
            print(error)
            print("SOMETHING WENT WRONG IN CameraServiceManager.takePhoto()")
        }
    }
}

extension CameraServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
}

extension CameraServiceManager : MCNearbyServiceBrowserDelegate {

    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}

extension MCSessionState {
    func stringValue() -> String {
        switch(self) {
        case .notConnected: return "NotConnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        }
    }
}

extension CameraServiceManager : MCSessionDelegate {
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let photoDestinationURL = URL(fileURLWithPath: documentsPath + "/photo.jpg")
        //        let videoDestinationURL = NSURL.fileURLWithPath(documentsPath + "/movie.mov")
        
        do {
            let fileHandle : FileHandle = try FileHandle(forReadingFrom: localURL)
            let data : Data = fileHandle.readDataToEndOfFile()
            let image = UIImage(data: data)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

        }
        catch {
            print("PROBLEM IN CameraServiceManager extension > didFinishReceivingResourceWithName")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        // CHECK DATA STRING AND ACT ACCORDINGLY
        if (dataString?.length)! > 6 && sent {
            print(dataString)
            prevMatches.append(dataString as! String)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            UserDefaults.standard.set(prevMatches, forKey: "matches")
            sent = false
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    DispatchQueue.main.async {
                        topController.performSegue(withIdentifier: "congrats", sender: nil)
                    }
                }
                // topController should now be your topmost view controller
            }
            
        }
        else {
            print("pinged!")
            print("Balls")
            possibleMatch = (dataString as! String)
            pinged = true;
        }

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
        self.delegate!.connectedDevicesChanged(self, state: state, connectedDevices:
            session.connectedPeers.map({$0.displayName}))
    }
}

// TO DO: MAKE THIS AN @objc PROTOCOL AND MAKE SOME OF THESE FUNCTIONS OPTIONAL
protocol CameraServiceManagerDelegate {
    func connectedDevicesChanged(_ manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String])
    func colorChanged(manager: CameraServiceManager, colorString: String)
    

}

