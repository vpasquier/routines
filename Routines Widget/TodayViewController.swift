//
//  TodayViewController.swift
//  Routines Widget
//
//  Created by V on 6/8/20.
//  Copyright © 2020 V. All rights reserved.
//

import UIKit
import SwiftUI
import NotificationCenter
import routines
import CoreData

@objc(TodayViewController)

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @State private var routines: [Routine]? = [];
    
    func fetchRoutines() -> [Routine]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Routine>(entityName: "Routine")
        var routines: [Routine]? = []
        do {
            routines = try managedContext.fetch(fetchRequest)
        } catch{
            print(error)
        }
        return routines;
    }
    var body: some View {
            VStack {
                List(routines ?? [], id: \.id) { routine in
                    RoutineRow(routine: routine);
                }
        }.onAppear(perform: {
            self.routines = self.fetchRoutines()
        })
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320.0, height: 200)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    override func loadView()
    {
        view = UIView(frame:CGRect(x:0.0, y:0, width:320.0, height:200.0))
    }
    
}
