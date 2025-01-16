//
//  NetworkConstant.swift
//  movietrending
//
//  Created by Ebrar Gunduz on 24.07.2024.
//


import Foundation

class NetworkConstants {
    
    public static var shared: NetworkConstants = NetworkConstants()
    
    public var apiKey: String {
        get {
            //https://www.themoviedb.org/
            //Put your own API key here
            return "a2808fe936ee607596786d126faebd67"
        }
    }
    
    public var serverAddress: String {
        get {
            return "https://api.themoviedb.org/3/"
        }
    }
    
    public var imageServerAddress: String {
        get {
            return "https://image.tmdb.org/t/p/w500/"
        }
    }
}
