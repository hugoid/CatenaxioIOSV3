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

class CatxEstadisticas: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var ref : FIRDatabaseReference?
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var listCalendario:[String : AnyObject] = [String : AnyObject]();
    var listCalendarioData:[EstadisticasModel] = [EstadisticasModel]();
    var listCalendarioDataFirebase:[EstadisticasModel] = [EstadisticasModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendario";
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        /*if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            self.downloadFireBaseData();
        } else {
            print("Internet connection FAILED")
            
            self.setup();
            self.loadData();
            self.downloadFireBaseData();
        }*/
        
        
        self.setup();
        self.loadData();
        
        
        
    }
    
    func downloadFireBaseData () -> Void {
        self.ref = FIRDatabase.database().reference()
        
        if let refUnwrapped1 = self.ref {
            let refEstadisticas : FIRDatabaseReference? = refUnwrapped1.child("Estadisticas");
            
            if let refUnwrapped = refEstadisticas {
                
                refUnwrapped.observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot.value)
                    
                    
                    let listaJugadores:[AnyObject] = snapshot.value?.valueForKey("Jugadores") as! [AnyObject];
                    
                    for jugador:AnyObject in listaJugadores {
                        print("mis jugador \(jugador)");
                        
                        let miJugador:EstadisticasModel = EstadisticasModel();
                        miJugador.nombre = jugador.valueForKey("Nombre") as! String;
                        miJugador.asistencias = jugador.valueForKey("Asistencias") as! String;
                        miJugador.goles = jugador.valueForKey("Goles") as! String;
                        miJugador.partidosGanados = jugador.valueForKey("PG") as! String;
                        miJugador.partidosJugados = jugador.valueForKey("PJ") as! String;
                        miJugador.urlImagenJugador = "xx";
                        
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
        self.listCalendarioData = [EstadisticasModel]();
        
        
        if (listCalendarioDataFirebase.count != 0) {
            
            for numJornada:Int in 1...self.listCalendarioDataFirebase.count {
                
                
                
                
                let jugadorModel:EstadisticasModel = EstadisticasModel();
                
                jugadorModel.nombre = listCalendarioDataFirebase[numJornada - 1].nombre;
                jugadorModel.asistencias = listCalendarioDataFirebase[numJornada - 1].asistencias;
                
                
                jugadorModel.partidosJugados = listCalendarioDataFirebase[numJornada - 1].partidosJugados;
                
                
                jugadorModel.partidosGanados = listCalendarioDataFirebase[numJornada - 1].partidosGanados;
                
                
                jugadorModel.goles = listCalendarioDataFirebase[numJornada - 1].goles;
                
                
                listCalendarioData.append(jugadorModel);
                
                
                
            }
            
        }
        else{
            if let path = NSBundle.mainBundle().pathForResource("Estadisticas", ofType: "plist") {
                self.listCalendario = NSDictionary(contentsOfFile:path) as! [String : AnyObject];
                
            }
            
            if let listCalendarioUnwrapped:[String:AnyObject]  = self.listCalendario {
                
                
                let jugador:AnyObject = listCalendarioUnwrapped["Hugo"]!;
                let jugadorModel:EstadisticasModel = EstadisticasModel();
                jugadorModel.nombre = "Hugo";
                jugadorModel.goles = jugador["Goles"] as! String;
                jugadorModel.asistencias = jugador["Asistencia"] as! String;
                jugadorModel.partidosGanados = jugador["PG"] as! String;
                jugadorModel.partidosJugados = jugador["PJ"] as! String;
                
                listCalendarioData.append(jugadorModel);
                
                print("mi valor estadistica es \(listCalendarioUnwrapped)");
                
                /*for numJornada:Int in 1...self.listCalendario.count {
                    
                    
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
                    
                    
                }*/
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
        if let listValurJornada:[EstadisticasModel] = self.listCalendarioData {
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
        
        let modeloCalendario:EstadisticasModel = self.listCalendarioData[indexPath.row];
        
        
        
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
