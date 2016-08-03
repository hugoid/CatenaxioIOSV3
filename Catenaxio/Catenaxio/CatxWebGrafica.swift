//
//  CatxWebGrafica.swift
//  Catenaxio
//
//  Created by Hugo Izquierdo on 7/31/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit

class CatxWebGrafica: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var web: UIWebView!
    var listaEstadisticas:[EstadisticasModel] = [EstadisticasModel]();
    
    init? (arrayEstadisticas:[EstadisticasModel]) {
        super.init(nibName: "CatxWebGrafica", bundle: nil);
        self.listaEstadisticas = arrayEstadisticas;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mostrarGrafica();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mostrarGrafica () ->Void {
        print("muestro grafica con datos \(self.listaEstadisticas)");
        
        
        let thisBundle = NSBundle.mainBundle();
        let path = thisBundle.pathForResource("ejemplo3", ofType: "html");
        let instructionsURL = NSURL.fileURLWithPath(path!);
        self.web.loadRequest(NSURLRequest(URL: instructionsURL));
        
        self.web.delegate = self;
        self.web.scalesPageToFit = true;
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let valor:Int = 5;
        let titulo:String = "xx";
        
        for jugador:EstadisticasModel in self.listaEstadisticas{
            print("Mi jugador es \(jugador.nombre)");
        }
        
        let peticionEjemploString:NSString = NSString(format: "drawChart(%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,'%@')",valor,valor,valor,valor,valor,valor,valor,valor,valor,valor,titulo);
        self.web.stringByEvaluatingJavaScriptFromString(peticionEjemploString as String);
       
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
