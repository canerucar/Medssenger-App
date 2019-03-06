import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var kullaniciAdiText: UITextField!
    @IBOutlet weak var parolaText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kullaniciAdiText.delegate = self
        parolaText.delegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Geri"
        
        //self.hideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func registerAction(_ sender: Any) {
        SVProgressHUD.show()
        if kullaniciAdiText.text != "" && parolaText.text != "" { //Kullanıcı boş kayıt yapmasın
            Auth.auth().createUser(withEmail: kullaniciAdiText.text!, password: parolaText.text!) { (user, error) in
                
                if error != nil {   //hata boş değilse
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert,animated: true,completion: nil)
                    //error?.localizedDescription çıkan hatası aynen bastırmak için
                }
                else {    //eğer hata yoksa
                    
                    self.accountSuccess(title: "Bilgi", message: "Hesabınız başarılı bir şekilde oluşturuldu.")
                    
                    UserDefaults.standard.set(user!.email, forKey: "user")
                    UserDefaults.standard.synchronize()

                }
            }
            
            
        }
        else
        {
            let alert = UIAlertController(title: "Hata", message: "Kullanıcı Adı ve Parola", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func accountSuccess(title: String, message: String) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            delegate.rememberLogin()
            
        }))
        
        self.present(alert, animated: true, completion: nil) 
    }
    
}
