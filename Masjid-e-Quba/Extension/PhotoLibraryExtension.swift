//
//  PhotoLibraryExtension.swift
//  iyziliOSApp
//
//  Created by Ali Waseem on 12/23/21.
//

import Photos
import UIKit

public extension PHPhotoLibrary {

   static func execute(controller: UIViewController,
                       onAccessHasBeenGranted: @escaping () -> Void,
                       onAccessHasBeenDenied: (() -> Void)? = nil) {

      let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
       //   DispatchQueue.main.async {
          var alertStyle = UIAlertController.Style.actionSheet
          if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
          }
              let alert = UIAlertController(
                 title: "We were unable to load your album groups. Sorry!",
                 message: "You can enable access in Privacy Settings",
                 preferredStyle: alertStyle)
              alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
              alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                 if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                 }
              }))
          DispatchQueue.main.async {
              controller.present(alert, animated: true)
          }
      }

      let status = PHPhotoLibrary.authorizationStatus()
      switch status {
      case .notDetermined:
         onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)
      case .denied, .restricted, .limited:
         onDeniedOrRestricted()
      case .authorized:
          DispatchQueue.main.async {
         onAccessHasBeenGranted()
          }
      @unknown default:
         fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
      }
   }

}

private func onNotDetermined(_ onDeniedOrRestricted: @escaping (()->Void), _ onAuthorized: @escaping (()->Void)) {
   PHPhotoLibrary.requestAuthorization({ status in
      switch status {
      case .notDetermined:
         onNotDetermined(onDeniedOrRestricted, onAuthorized)
      case .denied, .restricted, .limited:
         onDeniedOrRestricted()
      case .authorized:
          DispatchQueue.main.async {
         onAuthorized()
          }
      @unknown default:
         fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
      }
   })
}
