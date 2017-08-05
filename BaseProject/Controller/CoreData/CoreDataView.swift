//
//  SpeakerListView.swift
//  WMTSwiftDemo
//
//  Created by SamSol on 12/08/16.
//  Copyright © 2016 WMT. All rights reserved.
//

import UIKit
import GRDB

struct TaskDescription {
    static var text = ""
    static var notificationDate: Date?
}

class CoreDataView: BaseView, UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Attributes -
    var testView : UIView!
    
    var taskListTableView : UITableView!
    var selectedCategory = 0
    var tasks : [Task] =  [Task]()
    
   // var task: task!
    
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
        taskListTableView = nil
    }
    
    // MARK: - Layout - 
    
    override func loadViewControls(){
        super.loadViewControls()
        
        
        testView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = UIColor.red
        testView.layer.setValue("testView", forKey: ControlLayout.name)
        self.addSubview(testView)
        
        
        taskListTableView = UITableView(frame: CGRect.zero, style: .grouped)
        taskListTableView.translatesAutoresizingMaskIntoConstraints = false
    taskListTableView.layer.setValue("taskListTableView", forKey: ControlLayout.name)
        
        taskListTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifire.defaultCell)
        
        taskListTableView.backgroundColor = UIColor.clear
        taskListTableView.separatorStyle = .singleLine
        
        taskListTableView.separatorColor = Color.buttonSecondaryBG.value
        
        taskListTableView.clipsToBounds = true
        
        taskListTableView.tableHeaderView = UIView(frame: CGRect.zero)
        taskListTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        taskListTableView.rowHeight = UITableViewAutomaticDimension
        self.addSubview(taskListTableView)
        
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        
        self.loadtasks()

        self.taskListTableView.reloadData()
        
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
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[testView(200)][taskListTableView]-|", options:[.alignAllLeading,.alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        
        generateDiagonal(view: testView)
        
        self.layoutSubviews()
        
        
        
       // baseLayout.expandView(taskListTableView, insideView: self)
        
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
            self.tasks.removeAll()
            self.loadtasks()
            self.taskListTableView.reloadData()
        }
    }
    
    public func searchtask()
    {
        if let tasks = Tasks.sharedInstance.searchTask(withTask: "Test")
        {
            if self.tasks.count != 0{
                self.tasks.removeAll()
                self.tasks = tasks
                self.taskListTableView.reloadData()
            }
        }
    }
    
    public func addNewtask()
    {
        let date = Date()
        TaskDescription.notificationDate = date
        
        let uuid = UUID().uuidString
        // Creat and save new task
        
        Tasks.sharedInstance.addTask(description: "New Data", date: TaskDescription.notificationDate!, finished: false, category: selectedCategory, uuid: uuid)
        
        self.reloadList()
    }
    
    // MARK: - User Interaction -
    
   
    private func loadtasks() {
       
        // get task data
        tasks = Tasks.sharedInstance.tasksData()
        
        // Setting sorted by
        
        SettingsData.sharedInstance.getSettingsData()
        
        if SettingsData.sharedInstance.settings[0].sortedBy == "name" {
            
            tasks = tasks.sorted { $0.taskDescription! < $1.taskDescription! }
            
        } else if SettingsData.sharedInstance.settings[0].sortedBy == "date" {
            tasks = tasks.sorted { $0.uuid! < $1.uuid! }
        }
        
        // get categories data
        _ = Categories.sharedInstance.getCategories()
        
        self.taskListTableView.reloadData()
//        if (DataStore.defaultLocalDB.checkUserAvailability() != nil){
//            tasks = DataStore.defaultLocalDB.checkUserAvailability()
//        }
        
    }
    
    // MARK: - Server Request -
    
    
        
    // MARK: - UITableView DataSource Methods -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tasks.count == 0 {
            
            let noDataLabel: UILabel     =  UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text             = "Captain's Log, Stardate 43125.8. My tasks for today are..."
            noDataLabel.textColor        = UIColor.gray
            noDataLabel.textAlignment    = .center
            noDataLabel.numberOfLines    = 3
            tableView.backgroundView = noDataLabel
           
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tasks.count

    }
    
    func dateString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, hh:mm"
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      
        var cell : UITableViewCell!
        
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifire.defaultCell)
        }
        
        cell?.textLabel?.text = tasks[indexPath.row].taskDescription
        cell?.detailTextLabel?.text = dateString(date: tasks[indexPath.row].date)
        
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
        // Delete the task
        let task = tasks[indexPath.row]
        Tasks.sharedInstance.removeTask(withUUID: task.uuid!)
        
        //animation
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.loadtasks()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        Tasks.sharedInstance.updateTask(uuid:tasks[indexPath.row].uuid!, desc: "Test")
        
        self.reloadList()
        
    }
    
}
