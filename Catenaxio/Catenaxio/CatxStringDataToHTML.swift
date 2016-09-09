//
//  CatxStringDataToHTML.swift
//  Catenaxio
//
//  Created by Hugh on 12/08/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import Foundation

class CatxStringDataToHTML: NSObject {
    
    
    
    func getStringToHTML(listaJugadores:[EstadisticasModel],tipoPuntuacion:String) -> NSString {
        
        var puntosAbelG:Int = 0;
        var puntosAbelD:Int = 0;
        var puntosAnton:Int = 0;
        var puntosCano:Int = 0;
        var puntosJordan:Int = 0;
        var puntosHugo:Int = 0;
        var puntosJuanma:Int = 0;
        var puntosJuanito:Int = 0;
        var puntosMeri:Int = 0;
        var puntosFer:Int = 0;
        var puntosInvitado:Int = 0;
        
        
        
        for jugador:EstadisticasModel in listaJugadores{
            
            var puntuacion:Int = 0;
            if tipoPuntuacion == "goles" {
                puntuacion = Int(jugador.goles)!;
            }
            else{ //asistencia
                puntuacion = Int(jugador.asistencias)!;
            }
            
            if jugador.nombre == "Abel" {
                puntosAbelG = puntuacion;
            }
            else if jugador.nombre == "AbelD" {
                puntosAbelD = puntuacion;
            }
            else if jugador.nombre == "Anton" {
                puntosAnton = puntuacion;
            }
            else if jugador.nombre == "Hector" {
                puntosCano = puntuacion;
            }
            else if jugador.nombre == "Hugo" {
                puntosHugo = puntuacion;
            }
            else if jugador.nombre == "Jordan" {
                puntosJordan = puntuacion;
            }
            else if jugador.nombre == "Juanito" {
                puntosJuanito = puntuacion;
            }
            else if jugador.nombre == "Juanma" {
                puntosJuanma = puntuacion;
            }
            else if jugador.nombre == "Meri" {
                puntosMeri = puntuacion;
            }
            else if jugador.nombre == "Fer" {
                puntosFer = puntuacion;
            }
            else if jugador.nombre == "Invitado" {
                puntosInvitado = puntuacion;
            }
            
        }
        
        var tipoPuntuacionString:String = "";
        if tipoPuntuacion == "goles" {
            tipoPuntuacionString = "Goles";
        }
        else{
            tipoPuntuacionString = "Asistencias"
        }
       
        let stringToTHML:NSString = NSString(format: "drawChart(%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,'%@')",puntosAbelG,puntosAbelD,puntosJordan,puntosAnton,puntosCano,puntosMeri,puntosHugo,puntosJuanma,puntosJuanito,puntosFer,puntosInvitado,tipoPuntuacionString);
        return stringToTHML;
        
        
    }
    
    
    
    
    
}