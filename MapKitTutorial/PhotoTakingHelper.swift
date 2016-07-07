//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Thong Tran on 6/28/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

typealias photoTakingHelperCallBack = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    
    
    var callback : photoTakingHelperCallBack
    
    weak var viewController : UIViewController!
    
    var imagePickerController: UIImagePickerController?
    
    init(viewCol : UIViewController, callBack: photoTakingHelperCallBack)
    {
        self.viewController = viewCol
        self.callback = callBack
        
        super.init()
        
        shouldShowCamera()
    }
    
    
    func shouldShowCamera(){
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to take a picture?", preferredStyle: .ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        let takePictureFromPhoto = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (action) in
            
            self.whichCameraToDo(.PhotoLibrary)
        }
        
        alertController.addAction(takePictureFromPhoto)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
        let takePictureFromCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) in
            self.whichCameraToDo(.Camera)
        }
            alertController.addAction(takePictureFromCamera)
        }
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func whichCameraToDo(sourceType : UIImagePickerControllerSourceType)
    {
        imagePickerController = UIImagePickerController()
        imagePickerController?.sourceType = sourceType
        imagePickerController?.allowsEditing = true
        imagePickerController?.delegate = self
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
        
    }
    
}

extension PhotoTakingHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        viewController.dismissViewControllerAnimated(false, completion: nil)
        callback(image)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
     viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
