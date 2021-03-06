//
//  CatxCalendario.swift
//  Catenaxio
//
//  Created by Hugh on 19/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CatxCalendario: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var ref : FIRDatabaseReference?
    
    

    
    
    @IBOutlet weak var tableView: UITableView!
    var listCalendario:[String : AnyObject] = [String : AnyObject]();
    var listCalendarioData:[CalendarioModel] = [CalendarioModel]();
    var listCalendarioDataFirebase:[CalendarioModel] = [CalendarioModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        self.startDownload();
        
        
        
        
    }
    
    func startDownload () -> Void {
        
        listCalendario = [String : AnyObject]();
        listCalendarioData = [CalendarioModel]();
        listCalendarioDataFirebase = [CalendarioModel]();
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            self.downloadFireBaseData();
        } else {
            print("Internet connection FAILED")
            
            
            self.loadData();
            self.downloadFireBaseData();
        }
        
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
            // Ipad
        }
        else
        {
            // Iphone
        }
        
    }
    
    func downloadFireBaseData () -> Void {
        self.ref = FIRDatabase.database().reference().child("Calendario");
        print("mi self.ref es \(self.ref)");
        print("ok");
        
        if let refUnwrapped = self.ref {
            
            refUnwrapped.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot.value)
                
                
                for numJornada:Int in 1...21 {
                    let itemsRef = snapshot.value?.valueForKey("Jornada" +  String(numJornada));
                    let calendarioModelFireBase:CalendarioModel = CalendarioModel();
                    print("Mi jornada 1 es \(snapshot.value?.valueForKey("Jornada" +  String(numJornada)))");
                    calendarioModelFireBase.resultado = itemsRef!.valueForKey("Resultado") as! String;
                    calendarioModelFireBase.keyResultado = itemsRef!.valueForKey("KeyResultado") as! String;
                    calendarioModelFireBase.lugar = itemsRef!.valueForKey("Lugar") as! String;
                    calendarioModelFireBase.rival = itemsRef!.valueForKey("Rival") as! String;
                    calendarioModelFireBase.hora = itemsRef!.valueForKey("Hora") as! String;
                    self.listCalendarioDataFirebase.append(calendarioModelFireBase);
                    
                }
                
                print("termino");
                
                self.setup();
                self.loadData();
                
                }, withCancelBlock: { error in
                    print(error.description)
                    print("nooooo");
                    self.setup();
                    self.loadData();
            })
            
            
        }
        else{
            print("no online");
        }
        
        
    }
    
    func setup () -> Void {
        
        self.tabBarController?.navigationItem.title = "Catenaxio"
        let buttonSinc:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(CatxCalendario.pushSynData));
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
        
        
        self.tableView.registerNib(UINib(nibName: "CatxCeldaCalendario", bundle: nil), forCellReuseIdentifier: CatxCeldaCalendario.cellId);
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0);
        //self.tableView.registerNib(UINib(nibName: "HeaderCeldaPanelAdministrador", bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderCeldaPanelAdministrador.cellId);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.allowsSelection = false;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 160
    }
    
    
    
    // MARK: - Cargar Modelo
    func loadData () -> Void {
        self.listCalendarioData = [CalendarioModel]();
        
        
        if (listCalendarioDataFirebase.count != 0) {
            
            for numJornada:Int in 1...self.listCalendarioDataFirebase.count {
                
                
               
                
                    let calendarioModel:CalendarioModel = CalendarioModel();
                    
                    calendarioModel.hora = listCalendarioDataFirebase[numJornada - 1].hora;
                    calendarioModel.rival = listCalendarioDataFirebase[numJornada - 1].rival;
                    
                    
                    calendarioModel.resultado = listCalendarioDataFirebase[numJornada - 1].resultado;
                    
                    
                    calendarioModel.lugar = listCalendarioDataFirebase[numJornada - 1].lugar;
                    
                    
                    calendarioModel.keyResultado = listCalendarioDataFirebase[numJornada - 1].keyResultado;
                    
                    
                    listCalendarioData.append(calendarioModel);
                
                
                
            }
            
        }
        else{
            if let path = NSBundle.mainBundle().pathForResource("Calendario", ofType: "plist") {
                self.listCalendario = NSDictionary(contentsOfFile:path) as! [String : AnyObject];
                
            }
            
            if let listCalendarioUnwrapped:[String:AnyObject]  = self.listCalendario {
                
                print("mi valor calendario es \(listCalendarioUnwrapped)");
                
                for numJornada:Int in 1...self.listCalendario.count {
                    
                    
                    if let valorJornadaUnwrapped:AnyObject = listCalendarioUnwrapped["Jornada" + String(numJornada)] {
                        print("mi valor es \(valorJornadaUnwrapped)");
                        let calendarioModel:CalendarioModel = CalendarioModel();
                        
                        calendarioModel.hora = valorJornadaUnwrapped["Hora"] as! String;
                        calendarioModel.rival = valorJornadaUnwrapped["Rival"] as! String;
                        
                        
                        calendarioModel.resultado = valorJornadaUnwrapped["Resultado"] as! String;
                        
                        
                        calendarioModel.lugar = valorJornadaUnwrapped["Lugar"] as! String;
                        
                        
                        calendarioModel.keyResultado = "X";
                        
                        
                        listCalendarioData.append(calendarioModel);
                    }
                    
                    
                }
        }
        
            
            
        }
        //calendarioModel.resultado = listCalendarioDataFirebase[numJornada - 1].resultado;
       print("termino");
        self.tableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pushSynData () -> Void {
        self.startDownload();
    }
    
    
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listValurJornada:[CalendarioModel] = self.listCalendarioData {
            return listValurJornada.count;
        }
        else {
            return 0;
        }
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1;
        
        
        
    }
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CatxCeldaCalendario.cellId, forIndexPath: indexPath) as! CatxCeldaCalendario;
        
        let modeloCalendario:CalendarioModel = self.listCalendarioData[indexPath.row];
        cell.horaLabel.text = modeloCalendario.hora;
        //cell.lugarLabel.text = modeloCalendario.lugar;
        cell.resultadoLabel.text = modeloCalendario.resultado;
        cell.rivalLabel.text = modeloCalendario.rival;
        let fotosEstadio : FotosEstadio = FotosEstadio()
        cell.imagenEstadio.image = fotosEstadio.getImageWithName(modeloCalendario.lugar);
        cell.imagenEstadio.roundImage();
        let colorResultado:FotosResultados = FotosResultados();
        cell.imagenResultado.backgroundColor = colorResultado.getImageColorWithName(modeloCalendario.keyResultado);
        cell.imagenResultado.roundImage();
        cell.backgroundColor = UIColor.clearColor();
        cell.estadioLabel.text = modeloCalendario.lugar;
        
        
        return cell
        
    }
    
   
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        
        
        
        
    }
    
    
  
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160;
    }

}
