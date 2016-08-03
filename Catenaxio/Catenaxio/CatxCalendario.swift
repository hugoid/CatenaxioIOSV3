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
        self.title = "Calendario";
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        self.setup();
        
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
        
        
        
        
        
        
    }
    
    func downloadFireBaseData () -> Void {
        self.ref = FIRDatabase.database().reference().child("Calendario");
        print("mi self.ref es \(self.ref)");
        print("ok");
        
        if let refUnwrapped = self.ref {
            
            refUnwrapped.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot.value)
                
                
                for numJornada:Int in 1...5 {
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
        self.tableView.registerNib(UINib(nibName: "CatxCeldaCalendario", bundle: nil), forCellReuseIdentifier: CatxCeldaCalendario.cellId);
      
        //self.tableView.registerNib(UINib(nibName: "HeaderCeldaPanelAdministrador", bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderCeldaPanelAdministrador.cellId);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
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
        cell.lugarLabel.text = modeloCalendario.lugar;
        cell.resultadoLabel.text = modeloCalendario.resultado;
        cell.rivalLabel.text = modeloCalendario.rival;
        
        
        return cell
        
    }
    
    /*func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let header = (tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderCeldaPanelAdministrador.cellId)) as! HeaderCeldaPanelAdministrador;
        let header = (tableView.dequeueReusableCellWithIdentifier(HeaderCeldaPanelAdministrador.cellId)) as! HeaderCeldaPanelAdministrador;
        
        
        
        if let fetchUnwrapped = fetchedResultsController {
            if let sectionUnwrapped = fetchUnwrapped.sections {
                let currentSection:NSFetchedResultsSectionInfo = sectionUnwrapped[section];
                header.nombreSection.text = currentSection.name;
                
            }
        }
        
        
        
        return header.contentView;
        
        
    } */
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        
        print("Pinto celda");
        
        
        
        
        
    }
    
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return 100;
     }*/

}
