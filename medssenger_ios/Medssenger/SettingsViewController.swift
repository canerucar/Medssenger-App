import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func logOutAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user") //kullanıcı silinip giriş yap ekranına gitsin
        UserDefaults.standard.synchronize()
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        delegate.rememberLogin()
    }
    
    @IBAction func logOutActionButton(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "user") //kullanıcı silinip giriş yap ekranına gitsin
        UserDefaults.standard.synchronize()
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        delegate.rememberLogin()
     
    }
    
    
}
