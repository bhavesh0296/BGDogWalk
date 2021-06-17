//
//  ViewController.swift
//  BGDogWalk
//
//  Created by bhavesh on 17/06/21.
//  Copyright © 2021 Bhavesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // MARK: - Properties
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()

    var currentDog: Dog!
    var managedContext: NSManagedObjectContext!

    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!


    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    fileprivate func saveWalk(){
        let walk = Walk(context: managedContext)
        walk.date = Date()
        currentDog.addToWalks(walk)

        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }

    }

    fileprivate func initialSetup() {
        let dogName = "Figo"
        let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
        dogFetch.predicate = NSPredicate(format: "%K==%@", argumentArray: [#keyPath(Dog.name), dogName])
        do {
            let results = try managedContext.fetch(dogFetch)
            if results.count > 0 {
                currentDog = results.first
            } else {
                currentDog = Dog(context: managedContext)
                currentDog.name = dogName
                try managedContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - IBActions
extension ViewController {

    @IBAction func add(_ sender: UIBarButtonItem) {
        saveWalk()
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDog.walks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let walk = currentDog.walks?[indexPath.row] as? Walk,
            let date = walk.date else {
                return cell
        }
        cell.textLabel?.text = dateFormatter.string(from: date)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of Walks"
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard currentDog.walks?.count ?? 0 > indexPath.row,
            let walkToRemove = currentDog.walks?[indexPath.row] as? Walk,
            editingStyle == .delete else{
                return
        }

        managedContext.delete(walkToRemove)

        do {
            try managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print(error.localizedDescription)
        }

    }
}
