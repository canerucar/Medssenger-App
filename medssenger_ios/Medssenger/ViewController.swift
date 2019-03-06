import UIKit
import Firebase
import FirebaseAuth



class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var kullaniciAdiText: UITextField!
    @IBOutlet weak var parolaText: UITextField!
    
   
    override func viewDidLoad() {

        kullaniciAdiText.delegate = self
        parolaText.delegate = self
        
        super.viewDidLoad()
        
 

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        kullaniciAdiText.inputAccessoryView = toolBar
        parolaText.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    
    @IBAction func girisYapAction(_ sender: Any) {
    
        if kullaniciAdiText.text != "" && parolaText.text != "" {
            Auth.auth().signIn(withEmail: kullaniciAdiText.text!, password: parolaText.text!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert,animated: true,completion: nil)
                    //error?.localizedDescription çıkan hatası aynen bastırmak için
                }
                else {
                    UserDefaults.standard.set(user!.email, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
                    //self.performSegue(withIdentifier: "girisYap", sender: nil)
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Hata", message: "Kullanıcı Adı ve Parola Gerekli", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert,animated: true,completion: nil)
        }
    }
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == kullaniciAdiText {
            parolaText.becomeFirstResponder()
        }
        else if textField == parolaText {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    
    
}
