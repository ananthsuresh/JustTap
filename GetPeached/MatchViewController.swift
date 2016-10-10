//
//  MatchViewController.swift
//  GetPeached
//
//  Created by Ananth Suresh on 10/8/16.
//  Copyright © 2016 Fkboinc. All rights reserved.
//

import UIKit
import AudioToolbox
import MultipeerConnectivity
var sent = false
var pinged = false
var possibleMatch = ""


class MatchViewController: UIViewController{
    let cameraService = CameraServiceManager()
    @IBOutlet var matchRequest: UILongPressGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = UserDefaults.standard.array(forKey: "matches") as? [String]{
            prevMatches = name
        }
        UIApplication.shared.isIdleTimerDisabled = true
        cameraService.delegate = self
        // Do any additional setup after loading the view.
        cameraService.startSearching()
    }
    var tapped = false

    @IBAction func downReset(_ sender: AnyObject) {
        sent = false
        cameraService.stopSearching()
    }
    
    @IBAction func longTap(_ sender: AnyObject) {
        if tapped == false{
            sent = true
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            cameraService.takePhoto(sendPhoto: true)
            tapped = true
            print(pinged)
            if pinged{
                prevMatches.append(possibleMatch)
                UserDefaults.standard.set(prevMatches, forKey: "matches")
                self.performSegue(withIdentifier: "congrats", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MatchViewController: CameraServiceManagerDelegate{
    func connectedDevicesChanged(_ manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String]) {
    }
    func colorChanged(manager: CameraServiceManager, colorString: String){
        print("does this even run")
        OperationQueue.main.addOperation { () -> Void in
        switch colorString {
        case "true":
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        case "false": break
            
        default:
            NSLog("%@", "Unknown color value received: \(colorString)")
        }
        }
    }
}



