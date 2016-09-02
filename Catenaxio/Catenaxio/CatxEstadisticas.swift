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
    
    var partidosJugados:String = "0";
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var listCalendario:[String : AnyObject] = [String : AnyObject]();
    var listCalendarioData:[EstadisticasModel] = [EstadisticasModel]();
    var listCalendarioDataFirebase:[EstadisticasModel] = [EstadisticasModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);

        //barra de navegacion
        
        
        listCalendario = [String : AnyObject]();
        listCalendarioData = [EstadisticasModel]();
        listCalendarioDataFirebase = [EstadisticasModel]();
        
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            self.downloadFireBaseData();
        } else {
            print("Internet connection FAILED")
            
            self.setup();
            self.loadData();
            self.downloadFireBaseData();
        }
        
        
        //self.setup();
        //self.loadData();
        
        
        
    }
    
    func startDownload () -> Void {
        
        
        self.ref = FIRDatabase.database().reference()
        
        if let refUnwrapped1 = self.ref {
            let refEstadisticas : FIRDatabaseReference? = refUnwrapped1.child("Estadisticas");
            
            if let refUnwrapped = refEstadisticas {
                
                refUnwrapped.observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot.value)
                    
                    let valorPartidosTotales:AnyObject = (snapshot.value?.valueForKey("PJ"))!;
                    self.partidosJugados = String(valorPartidosTotales);
                    let listaJugadores:[AnyObject] = snapshot.value?.valueForKey("Jugadores") as! [AnyObject];
                    
                    for jugador:AnyObject in listaJugadores {
                        print("mis jugador \(jugador)");
                        
                        let miJugador:EstadisticasModel = EstadisticasModel();
                        miJugador.nombre = jugador.valueForKey("Nombre") as! String;
                        miJugador.asistencias = String(jugador.valueForKey("Asistencias")!);
                        miJugador.goles = String(jugador.valueForKey("Goles")!);
                        miJugador.partidosGanados = String(jugador.valueForKey("PG")!);
                        miJugador.partidosJugados = String(jugador.valueForKey("PJ")!);
                        let imagenJugador : CatxImagenJugador = CatxImagenJugador();
                        miJugador.urlImagenJugador = imagenJugador.getURLImageForName(miJugador.nombre);
                        self.listCalendarioDataFirebase.append(miJugador);
                        
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
    
    func downloadFireBaseData () -> Void {
        
        
        self.startDownload();
        

    }
    
    // MARK: - Setup Color UI
    func setupUI () -> Void {
        self.tabBarController?.navigationItem.title = "Catenaxio"
        let buttonSinc:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(CatxEstadisticas.pushSynData));
        let buttonShowGraph:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(CatxEstadisticas.pushShowGraph));
        self.tabBarController?.navigationItem.rightBarButtonItems = [buttonShowGraph,buttonSinc];
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
    
    // MARK: - Setup Table
    func setup () -> Void {
        self.tableView.registerNib(UINib(nibName: "CatxCeldaEstadisticas", bundle: nil), forCellReuseIdentifier: CatxCeldaEstadisticas.cellId);
        self.tableView.registerNib(UINib(nibName: "CatxHeaderEstadisticas", bundle: nil), forCellReuseIdentifier: CatxHeaderEstadisticas.cellId);
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        
        //self.tableView.registerNib(UINib(nibName: "HeaderCeldaPanelAdministrador", bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderCeldaPanelAdministrador.cellId);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.allowsSelection = false;
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    // MARK: - Push Button
    
    func pushSynData () -> Void{
        self.startDownload();
    }
    
    func pushShowGraph () -> Void {
        print("push grahp");
        let graficas:CatxWebGrafica = CatxWebGrafica(arrayEstadisticas: self.listCalendarioData)!;
        self.navigationController?.pushViewController(graficas, animated: true);
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(CatxCeldaEstadisticas.cellId, forIndexPath: indexPath) as! CatxCeldaEstadisticas;
        
        let modeloCalendario:EstadisticasModel = self.listCalendarioData[indexPath.row];
        
        cell.partidosJugadosCeldaEstadistica.text = modeloCalendario.partidosJugados;
        cell.partidosGanadosCeldaEstadisticas.text = modeloCalendario.partidosGanados;
        cell.asistenciasCeldaEstadisticas.text = modeloCalendario.asistencias;
        cell.golesCeldaEstadisticas.text = modeloCalendario.goles;
        //foto
        let crearFoto:FotosNombre = FotosNombre();
        let imagenJugador:UIImage = crearFoto.getImageWithName(modeloCalendario.nombre);
        cell.imageCeldaEstadisticas.image = imagenJugador;
        cell.imageCeldaEstadisticas.roundImage();
        
       
        
        cell.backgroundColor = UIColor.clearColor();
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     //let header = (tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderCeldaPanelAdministrador.cellId)) as! HeaderCeldaPanelAdministrador;
     let header = (tableView.dequeueReusableCellWithIdentifier(CatxHeaderEstadisticas.cellId)) as! CatxHeaderEstadisticas;
     
        header.contentView.backgroundColor = UIColor(red: 68/255, green: 146/255, blue: 132/255, alpha: 1);
        header.labelPartidosTotales.text = self.partidosJugados;
     
     return header.contentView;
     
     
     }
   
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        
        print("Pinto celda");
        
        
        
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85;
    }
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return 100;
     }*/
    
}
