//
//  FileManagerService.swift
//  FileManagerTestProj
//
//  Created by Максим Жуин on 08.01.2024.
//

import Foundation


protocol FileManagerServiceProtocol {

    func createDirectory(name: String)
    func createFile(name: String, content: Data)
    func removeContent(at index: Int)
    func isDirectoryAtIndex(_ index: Int) -> Bool
    func getPath(at index: Int) -> String

}

class FilemanagerService: FileManagerServiceProtocol {

    var items: [String]?
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

    func fetchInfo() {
        do {
            let retrivedArray =  try FileManager.default.contentsOfDirectory(atPath: pathForFolder)
            items = retrivedArray

        } catch {
            items = []
        }
    }

    func createFile(name: String, content: Data) {
        let pathToSave = URL(filePath: pathForFolder + "/" + name)
        do {
            try content.write(to: pathToSave)
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeContent(at index: Int) {
        if let items = items {
            let path = pathForFolder + "/" + items[index]
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getPath(at index: Int) -> String {
        if let items = items {
            return pathForFolder + "/" + items[index]
        }
        return ""
    }

    func isDirectoryAtIndex(_ index: Int) -> Bool {
        if let items = items {
            let item = items[index]
            let path = pathForFolder + "/" + item
            var objcBool: ObjCBool = false
            FileManager.default.fileExists(atPath: path, isDirectory: &objcBool)
            return objcBool.boolValue
        }
        return false
    }

}
