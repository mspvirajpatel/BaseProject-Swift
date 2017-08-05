//
//  FileManagerView.swift
//  BaseProjectSwift
//
//  Created by WebMob on 05/04/17.
//  Copyright © 2017 WMT. All rights reserved.
//

import UIKit

class FileManagerView: BaseView {

    // MARK: - Attribute -
    private final let folderName : String = "BaseFile"
    internal var folderPath : String!
    
    var arrFiles : [String] = []{
        didSet{
            if tblList != nil{
                tblList.reloadData()
            }
        }
    }
    
    var tblList : UITableView!
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        self.createFolder()
        self.createTestFile()
        self.getFilelist()
        tblList = UITableView(frame: CGRect.zero, style: .grouped)
        tblList .register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblList.translatesAutoresizingMaskIntoConstraints = false
        tblList.delegate = self
        tblList.dataSource = self
        self.addSubview(tblList)
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        tblList.edgeToSuperView(top: 10, left: 10, bottom: -10, right: -10)
        self.layoutIfNeeded()
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    private func createFolder(){
        
        folderPath = AppUtility.getDocumentDirectoryPath() + "/\(folderName)"
        print("Folder Path :- \(folderPath)")
        
        do{
            if !FileManager.default.fileExists(atPath: folderPath){
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func getFilelist(){
        
        do{
            arrFiles = try FileManager.default.contentsOfDirectory(atPath: folderPath)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func createTestFile(){
        do{
            let string : String = try ["Hello" : "Hello World","Nice Work" : "Byyy"].dictionaryToJSON()
            let testFile : String = folderPath + "/test.txt"
            
            if !FileManager.default.fileExists(atPath: testFile){
                try string.write(toFile: testFile, atomically: true, encoding: String.Encoding.utf8)
            }
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
}

extension FileManagerView : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            cell.selectionStyle = .none
        }
        
        cell.selectionStyle = .none
        
        cell.textLabel?.text = arrFiles[indexPath.row]
        return cell
    }
}

extension FileManagerView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fileURL : URL = URL(fileURLWithPath: folderPath + "/\(arrFiles[indexPath.row])")
        
        let doucmentControl : UIDocumentInteractionController = UIDocumentInteractionController(url: fileURL)
        doucmentControl.delegate = self
        doucmentControl.presentPreview(animated: true)
    }
}

extension FileManagerView : UIDocumentInteractionControllerDelegate{
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.getViewControllerFromSubView()!
    }
    
}

