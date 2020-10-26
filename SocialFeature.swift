import UIKit
import Firebase
import FirebaseFirestore

class SocialFeature: UIViewController {
    
    struct Data {
        static var myFriends = [String()]
        static var myFriendsPoints = [String()]
        
        static var users = [String()]
    }
    
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var done = false
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        get()
        
        formatWindow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Data.myFriends = [""]
        Data.myFriendsPoints = [""]
        db.collection("user").document(HomePage.Data.myEmail).collection("friends").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(error!)")
                return
            }
            for document in snapshot.documents {
                let username = document.get("username") as! String
                let tempEmail = document.get("email") as! String //Getting a nil error

                self.db.collection("user").document(tempEmail).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data()
                        
                        let points = dataDescription!["points"] as! String
                        
                        SocialFeature.Data.myFriends.append(username)
                        SocialFeature.Data.myFriendsPoints.append(points)
                        
                        self.tableView.reloadData()
                    }
                    else {
                        print("Error retrieving booleans...")
                    }
                }
            }
        }
        
        Data.myFriends.remove(at: 0)
        Data.myFriendsPoints.remove(at: 0)
    }
    
    func formatWindow() {
        let nib = UINib(nibName: "FriendCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 80
        friendsButton.layer.cornerRadius = 10.0
    }
    
    func get() {
        let userCollection = db.collection("user")
        
        userCollection.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("\(String(describing: error))")
                return
            }
            
            for document in snapshot.documents {
                let documentId = document.documentID
                Data.users.append(documentId)
            }
        }
    }
    
    @IBAction func friendsTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddFriends", sender: self)
    }
}

extension SocialFeature: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SocialFeature.Data.myFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
        cell.username.text = Data.myFriends[indexPath.row]
        cell.points.text = Data.myFriendsPoints[indexPath.row]
        
        let userPoint = Int(Data.myFriendsPoints[indexPath.row])!
        let yourPoint = Int(HomePage.Data.myPoints)!
        
        if Data.myFriends[indexPath.row] == "You" {
            cell.status.alpha = 0
        }

        if yourPoint > userPoint {
            cell.status.text = "WINNING"
            cell.status.textColor = UIColor.white
        }

        if yourPoint < userPoint {
            cell.status.text = "LOSING"
            cell.status.textColor = UIColor.systemRed
        }

        if yourPoint == userPoint {
            cell.status.text = "TIED"
            cell.status.textColor = UIColor.systemYellow
        }
        
        return cell
    }
}
