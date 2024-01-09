//
//  FileManagerService.swift
//  FileManagerTestProj
//
//  Created by Максим Жуин on 08.01.2024.
//

import Foundation


protocol FileManagerServiceProtocol {

    func createDirectory(name: String)
    func createFile(name: String, content: String)
    func removeContent(at index: Int)
    func isDirectoryAtIndex(_ index: Int) -> Bool
    func getPath(at index: Int) -> String

}

class FilemanagerService: FileManagerServiceProtocol {

    var items: [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: pathForFolder)) ?? []
    }

    let pathForFolder: String

    init() {
        self.pathForFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    init(pathForFolder: String) {
        self.pathForFolder = pathForFolder
    }

    func createDirectory(name: String) {
        let pathToSave = pathForFolder + "/" + name
        do {
            try FileManager.default.createDirectory(atPath: pathToSave, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createFile(name: String, content: String) {
        let pathToSave = pathForFolder + "/" + name
        FileManager.default.createFile(atPath: pathToSave, contents: content.data(using: .utf8))

    }
    
    func removeContent(at index: Int) {
        let path = pathForFolder + "/" + items[index]
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print(error.localizedDescription)
        }
    }

    func getPath(at index: Int) -> String {
          pathForFolder + "/" + items[index]
    }

    func isDirectoryAtIndex(_ index: Int) -> Bool {
        let item = items[index]
        let path = pathForFolder + "/" + item
        var objcBool: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &objcBool)
        return objcBool.boolValue
    }

}
