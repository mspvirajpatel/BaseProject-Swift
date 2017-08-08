//
//  SpeakerListView.swift
//  WMTSwiftDemo
//
//  Created by Viraj Patel on 12/08/16.
//  Copyright @ 2017 Viraj Patel All rights reserved.
//

import UIKit
import GRDB

class DatabaseView: BaseView, UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Attributes -
    var testView : UIView!
    
    var personListTableView : UITableView!

    var persons: [Person]!
    
   // var person: Person!
    
    private let personsSortedByScore = Person.order(Column("score").desc, Column("name"))
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
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
        personListTableView = nil
    }
    
    // MARK: - Layout - 
    
    override func loadViewControls(){
        super.loadViewControls()
        
        
        testView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = UIColor.red
        testView.layer.setValue("testView", forKey: ControlLayout.name)
        self.addSubview(testView)
        
        
        personListTableView = UITableView(frame: CGRect.zero, style: .grouped)
        personListTableView.translatesAutoresizingMaskIntoConstraints = false
    personListTableView.layer.setValue("personListTableView", forKey: ControlLayout.name)
        
        personListTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifire.defaultCell)
        
        personListTableView.backgroundColor = UIColor.clear
        personListTableView.separatorStyle = .singleLine
        
        personListTableView.separatorColor = Color.buttonSecondaryBG.value
        
        personListTableView.clipsToBounds = true
        
        personListTableView.tableHeaderView = UIView(frame: CGRect.zero)
        personListTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        personListTableView.rowHeight = UITableViewAutomaticDimension
        self.addSubview(personListTableView)
        
        personListTableView.delegate = self
        personListTableView.dataSource = self
        
        self.loadPersons()

        self.personListTableView.reloadData()
        
//        let directory: String = FileManager.getDocumentsDirectoryForFile(file: "db.sqlite")
//        NSLog("Database Directory: \(directory)")

    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlLayout.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlLayout.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[testView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[testView(200)][personListTableView]-|", options:[.alignAllLeading,.alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        
        generateDiagonal(view: testView)
        
        self.layoutSubviews()
        
        
        
       // baseLayout.expandView(personListTableView, insideView: self)
        
    }
    
    func generateDiagonal(view: UIView?) {
        let maskLayer : CAShapeLayer = CAShapeLayer()
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.frame = (view?.bounds)!
        
        UIGraphicsBeginImageContext((view?.bounds.size)!);
        let path = UIBezierPath()
        
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: (view?.bounds.size.width)!, y: 0))
            
            
        path.addLine(to: CGPoint.init(x: (view?.bounds.size.width)!, y: (view?.bounds.size.height)! / 2))
        
        path.addLine(to: CGPoint.init(x: 0, y: (view?.bounds.size.height)!))
        
        path.close()
        path.fill()
        
        maskLayer.path = path.cgPath;
        UIGraphicsEndImageContext();
        view!.layer.mask = maskLayer;
    }
    
    // MARK: - Public Interface -
    
    public func reloadList(){

        AppUtility.executeTaskInMainQueueWithCompletion {
            self.persons.removeAll()
            self.loadPersons()
            self.personListTableView.reloadData()
        }
    }
    
    public func addNewPerson()
    {
        for _ in 0..<1 {
            let person = Person(name: Person.randomName(), score: Person.randomScore(),email: Person.randomName())
            if !person.name.isEmpty {
                try! dbQueue.inDatabase { db in
                    try person.save(db)
                }
            }
        }
        
        self.reloadList()
    }
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
    private func loadPersons() {
        do{
            persons = try dbQueue.inDatabase { db in
                
                try Person.order().fetchAll(db)
                
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    
    // MARK: - Server Request -
    
    
        
    // MARK: - UITableView DataSource Methods -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return persons.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.defaultCell) as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifire.defaultCell)
        }
        
        let person = persons[indexPath.row]
        cell?.textLabel?.text = person.name
        cell?.detailTextLabel?.text = abs(person.score) > 1 ? "\(person.score) points" : "0 point"
        
        return cell!
    }
    
    // MARK: - UITableView Delegate Methods -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let cellHeight : CGFloat = 90.0
        
        return cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Delete the person
        let person = persons[indexPath.row]
        try! dbQueue.inDatabase { db in
            _ = try person.delete(db)
          // self.persons.remove(at: indexPath)
            self.reloadList()
            
           //self.personListTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
