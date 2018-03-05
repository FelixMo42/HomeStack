import UIKit
import Material

class FindClassViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var enrolledClasses:[Class] = []
    var currentEnrolledClasses:[Class] = []
    
    
    //findToShow
    
    @objc func touchAdd(){
        self.performSegue(withIdentifier: "findToShow", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.titleLabel.text = "Find Class"
        navigationItem.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleLabel.textColor = Color.white
        
        
        let plus = IconButton(image: Icon.cm.add)
        plus.tintColor = Color.white
        navigationItem.rightViews = [plus]
        
        navigationItem.rightViews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAdd)))
        
        currentEnrolledClasses = self.enrolledClasses
        
        Class.loadAll( callback: {ret in
            self.enrolledClasses = ret
            self.currentEnrolledClasses = ret
            self.table.reloadData()
        } )

    }
    
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentEnrolledClasses = enrolledClasses
            table.reloadData()
            return

        }
        currentEnrolledClasses = enrolledClasses.filter({ (theClass) -> Bool in
            guard searchBar.text != nil else {return false}
            return theClass.name.lowercased().contains(searchBar.text!.lowercased())
        })
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentEnrolledClasses.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell
            else {
                return UITableViewCell()
        }
        
        cell.name.text = currentEnrolledClasses[indexPath.row].name
        cell.teacherName.text = currentEnrolledClasses[indexPath.row].teacher
        cell.period.text = String( currentEnrolledClasses[indexPath.row].period )
        cell.view?.backgroundColor = randomColor(seed: currentEnrolledClasses[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func addToClasses(c: Class) {
        User.addClass( name: c.name, teacher: c.teacher, period: c.period,  completion: { (suc: Bool) in
            if suc {
                self.navigationController?.popViewController(animated: true)
            }
        } )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var c: Class = currentEnrolledClasses[indexPath.row]
        let alert = UIAlertController(title: "Enroll In Class", message: "Do you want to enroll in \(currentEnrolledClasses[indexPath.row].name)?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,  handler:{ _ in
            self.addToClasses(c: c)
        } ))
            
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func randomColor(seed: String) -> UIColor {
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
