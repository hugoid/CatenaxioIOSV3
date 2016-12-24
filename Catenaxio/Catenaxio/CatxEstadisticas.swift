//
//  CatxCalendario.swift
//  Catenaxio
//
//  Created by Hugh on 19/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit

import FirebaseDatabase

class CatxEstadisticas: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
    
    var ref : FIRDatabaseReference?
    
    var partidosJugados:String = "0";
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var listCalendario:[String : AnyObject] = [String : AnyObject]();
    var listCalendarioData:[EstadisticasModel] = [EstadisticasModel]();
    var listCalendarioDataFirebase:[EstadisticasModel] = [EstadisticasModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);

        //barra de navegacion
        self.setupUI();
        
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
                
                refUnwrapped.observe(.value, with: { snapshot in
                    print(snapshot.value)
                    
                    let valorPartidosTotales:Any = ((snapshot.value as AnyObject).value(forKey: "PJ"))!;
                    self.partidosJugados = String(describing: valorPartidosTotales);
                    let listaJugadores:[AnyObject] = (snapshot.value as AnyObject).value(forKey: "Jugadores") as! [AnyObject];
                    
                    for jugador:AnyObject in listaJugadores {
                        print("mis jugador \(jugador)");
                        
                        let miJugador:EstadisticasModel = EstadisticasModel();
                        miJugador.nombre = jugador.value(forKey: "Nombre") as! String;
                        miJugador.asistencias = String(describing: jugador.value(forKey: "Asistencias")!);
                        miJugador.goles = String(describing: jugador.value(forKey: "Goles")!);
                        miJugador.partidosGanados = String(describing: jugador.value(forKey: "PG")!);
                        miJugador.partidosJugados = String(describing: jugador.value(forKey: "PJ")!);
                        let imagenJugador : CatxImagenJugador = CatxImagenJugador();
                        miJugador.urlImagenJugador = imagenJugador.getURLImageForName(miJugador.nombre);
                        self.listCalendarioDataFirebase.append(miJugador);
                        
                    }
                    
                    
                    
                    print("termino");
                    
                    self.setup();
                    self.loadData();
                    
                    }, withCancel: { error in
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
        let buttonSinc:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(CatxEstadisticas.pushSynData));
        let buttonShowGraph:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(CatxEstadisticas.pushShowGraph));
        self.tabBarController?.navigationItem.rightBarButtonItems = [buttonShowGraph,buttonSinc];
        //self.tabBarController?.tabBar.translucent = false;
        //self.tabBarController?.tabBar.tintColor = UIColor(red: 48/255, green: 67/255, blue: 74/255, alpha: 1);
        //self.tabBarController?.tabBar.barTintColor = UIColor.whiteColor(); //fondo barra abajo
        self.tabBarController?.navigationController?.navigationBar.barTintColor = UIColor(red: 68/255, green: 146/255, blue: 132/255, alpha: 1);
        self.tabBarController?.navigationController?.navigationBar.tintColor = UIColor.white;
        self.tabBarController?.navigationController?.navigationBar.isTranslucent = true;
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white];
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject];
    
        //gradient
        let vista : UIView = self.view;
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = vista.bounds
        
        let cor1 = UIColor(red: 17/255, green: 124/255, blue: 104/255, alpha: 1).cgColor;
        let cor2 = UIColor(red: 48/255, green: 67/255, blue: 74/255, alpha: 1).cgColor;
        let arrayColors = [cor1, cor2]
        
        gradient.colors = arrayColors
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Setup Table
    func setup () -> Void {
        self.tableView.register(UINib(nibName: "CatxCeldaEstadisticas", bundle: nil), forCellReuseIdentifier: CatxCeldaEstadisticas.cellId);
        self.tableView.register(UINib(nibName: "CatxHeaderEstadisticas", bundle: nil), forCellReuseIdentifier: CatxHeaderEstadisticas.cellId);
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
        
        
        let actionSheet = UIActionSheet(title: "Opciones", delegate: self, cancelButtonTitle: "Cancelar", destructiveButtonTitle: nil, otherButtonTitles: "Goles", "Asistencias")
        
        actionSheet.show(in: self.view)
        
    }
    
    //MARK: Delegate Action Sheet
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print("\(buttonIndex)")
        switch (buttonIndex){
            
        case 0:
            print("Cancelar")
        case 1:
            print("Goles")
             let graficas:CatxWebGrafica = CatxWebGrafica(arrayEstadisticas: self.listCalendarioData,tipoDato: "goles")!;
             self.navigationController?.pushViewController(graficas, animated: true);
        case 2:
            print("Asistencia")
             let graficas:CatxWebGrafica = CatxWebGrafica(arrayEstadisticas: self.listCalendarioData,tipoDato: "asistencias")!;
             self.navigationController?.pushViewController(graficas, animated: true);
        default:
            print("Default")
            //Some code here..
            
        }
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
        /*else{
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
            
            
            
        }*/
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listValurJornada:[EstadisticasModel] = self.listCalendarioData {
            return listValurJornada.count;
        }
        else {
            return 0;
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1;
        
        
        
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatxCeldaEstadisticas.cellId, for: indexPath) as! CatxCeldaEstadisticas;
        
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
        
       
        
        cell.backgroundColor = UIColor.clear;
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     //let header = (tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderCeldaPanelAdministrador.cellId)) as! HeaderCeldaPanelAdministrador;
     let header = (tableView.dequeueReusableCell(withIdentifier: CatxHeaderEstadisticas.cellId)) as! CatxHeaderEstadisticas;
     
        header.contentView.backgroundColor = UIColor(red: 68/255, green: 146/255, blue: 132/255, alpha: 1);
        header.labelPartidosTotales.text = self.partidosJugados;
     
     return header.contentView;
     
     
     }
   
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        
        
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85;
    }
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return 100;
     }*/
    
}
