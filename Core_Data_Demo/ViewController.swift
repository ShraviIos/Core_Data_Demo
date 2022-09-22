

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    //refrence to manage context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // data for table
    var items:[Person]?
    
    @IBOutlet var btnAdd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      fetchData()
    }
    
    func fetchData(){
        // fetch the data from data to display table view
        do{
            self.items =  try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    @IBAction func btnAddAction(_ sender: UIButton) {
        //create an alert
        let alert = UIAlertController(title: "Add person", message: "what is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        //configure the btn hanlder
        let submitButton = UIAlertAction(title: "Add", style: .default){ [self] (action) in
            
            //get textfield from alert
            let textfield = alert.textFields![0]
            
            // create new person object
            let newPerson = Person(context: context)
            newPerson.name = textfield.text
            newPerson.age = 20
            newPerson.gender = "male"
            
            //save data
            do{
                try self.context.save()
            }
            catch{
                
            }
            // refetch data
            fetchData()
        }
        //add button
        alert.addAction(submitButton)
        
        //show alert
        self.present(alert, animated: true)
        
    }
 
}
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        // get peron from array and set lbl
        let person = self.items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selected person
        let person = self.self.items![indexPath.row]
        
        //create alert
        let alert = UIAlertController(title: "Edit person", message: "do you want change name?", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        //configure the btn hanlder
        let savebutton = UIAlertAction(title: "Save", style: .default){ [self] (action) in
            
            //get textfield from alert
            let textfield = alert.textFields![0]
            
            // edit name property of person objet
            person.name = textfield.text
            
            //save data
            do{
                try self.context.save()
            }
            catch{
                
            }
            // refetch data
            fetchData()
            
    }
        //add action
        alert.addAction(savebutton)
        
        //present alert
        self.present(alert, animated: true)
        
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            //which person to remove
            let personRemove = self.items?[indexPath.row]
            
            //remove person
            self.context.delete(personRemove!)
            
            //save data
            do{
                try self.context.save()
            }
            catch{
                
            }
            //refetch data
            self.fetchData()
         }
        //swipe action configuration
        return UISwipeActionsConfiguration(actions: [action])
    }
}
