//
//  CatxClasificacion.swift
//  Catenaxio
//
//  Created by Hugh on 28/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CatxClasificacion: UIViewController {

    @IBOutlet weak var indicatorWaiting: UIActivityIndicatorView!
    @IBOutlet weak var imageClasificacion: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        
        //barra de navegacion
        

        self.startDownload();
        
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //download
    func startDownload () -> Void {
        
        self.indicatorWaiting.startAnimating()
        self.indicatorWaiting.hidden = false
        // Points to the root reference
        let storageRef = FIRStorage.storage().referenceForURL("gs://catenaxio-dd230.appspot.com");
        // Create a reference from a Google Cloud Storage URI
        
        // Points to "images"
        let imagesRef = storageRef.child("clasificacion/clasificacion.png")
        
        // Points to "images/space.jpg"
        // Note that you can use variables to create child values
        let fileName = "clasificacion.png"
        let spaceRef = imagesRef.child(fileName)
        
        // Start the download (in this case writing to a file)
        // Create local filesystem URL
        let localURL: NSURL! = NSURL(string: "file:///local/images/island.jpg")
        let downloadTask = imagesRef.writeToFile(localURL)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imagesRef.dataWithMaxSize(5 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("error");
                
                self.indicatorWaiting.stopAnimating()
                self.indicatorWaiting.hidden = true;
            } else {
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
                print("tengo mi imagen");
                let imagenClasificacion : UIImage! = UIImage(data: data!);
                self.imageClasificacion.image = imagenClasificacion;
                
                self.indicatorWaiting.stopAnimating()
                self.indicatorWaiting.hidden = true;
            }
        }
        
        // Observe changes in status
        downloadTask.observeStatus(.Resume) { (snapshot) -> Void in
            // Download resumed, also fires when the download starts
            print("descargado correctamente imagen");
            
        }
        
        downloadTask.observeStatus(.Success) { (snapshot) -> Void in
            // Download completed successfully
            print("descargado suscessfuly imagen \(snapshot)");
            
        }
        
        // Errors only occur in the "Failure" case
        downloadTask.observeStatus(.Failure) { (snapshot) -> Void in
            guard let storageError = snapshot.error else { return }
            guard let errorCode = FIRStorageErrorCode(rawValue: storageError.code) else { return }
            switch errorCode {
            case .ObjectNotFound:
                // File doesn't exist
                print("nof found");
                
                
            case .Unauthorized:
                // User doesn't have permission to access file
                print("not unatorized");
             
                
            case .Cancelled:
                // User canceled the upload
                print("cancelled");
                
                
                //...
                
            case .Unknown:
                // Unknown error occurred, inspect the server response
                print("unknow");
               
                
            default:
                print("default");
                
            }
            
        }
    }
    
    
    // MARK: - Setup Color UI
    func setupUI () -> Void {
        self.tabBarController?.navigationItem.title = "Catenaxio"
        let buttonSinc:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(CatxClasificacion.pushSynData));
        self.tabBarController?.navigationItem.rightBarButtonItems = [buttonSinc];
        //self.tabBarController?.tabBar.translucent = false;
        //self.tabBarController?.tabBar.tintColor = UIColor(red: 48/255, green: 67/255, blue: 74/255, alpha: 1);
        //self.tabBarController?.tabBar.barTintColor = UIColor.whiteColor(); //fondo barra abajo
        self.tabBarController?.navigationController?.navigationBar.barTintColor = UIColor(red: 68/255, green: 146/255, blue: 132/255, alpha: 1);
        self.tabBarController?.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        self.tabBarController?.navigationController?.navigationBar.translucent = true;
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject];
        
        //gradient
        let vista : UIView = self.view;
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = vista.bounds
        
        let cor1 = UIColor(red: 17/255, green: 124/255, blue: 104/255, alpha: 1).CGColor;
        let cor2 = UIColor(red: 48/255, green: 67/255, blue: 74/255, alpha: 1).CGColor;
        let arrayColors = [cor1, cor2]
        
        gradient.colors = arrayColors
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func pushSynData () -> Void {
        self.startDownload();
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
