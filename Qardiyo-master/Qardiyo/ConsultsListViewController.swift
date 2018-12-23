//
//  ConsultsListViewController.swift
//  QardiyoHF_Patient
//
//  Created by Ravi on 15/07/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ConsultsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var documents = [DocumentsModel]()
    var titleString =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1)
        self.title = titleString
           self.tableView.reloadData()
        
//        Messages.getDoucments(documentType: "all") { (documents) in
//            DispatchQueue.main.async {
//                self.documents = documents
//                self.tableView.reloadData()
//            }
    //    }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    //MARK: TableViewDelegate and Datasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //       let documentViewer =  DocumentViewerViewController()
        //        documentViewer.documentURLString = documents[indexPath.row].fileurl
        //        self.navigationController?.pushViewController(documentViewer)
        downloadPDFFile(urlString: documents[indexPath.row].fileurl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        cell?.textLabel?.text = documents[indexPath.row].remarks
        return cell!
    }
    
    
    //MARK: download files and open on document preview
    func downloadPDFFile(urlString:String)
    {
        print("original URL==\(urlString)")
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.annularDeterminate
        hud.label.text = "Loading…"
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL:NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as    NSURL
            print("***documentURL: ",documentsURL)
         //   let PDF_name : String = "test.pdf"
            let   fileName = urlString.splitted(by: "/").last
            let fileURL = documentsURL.appendingPathComponent(fileName!)
            print("***fileURL: ",fileURL ?? "")
            return (fileURL!,[.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlString, to: destination).downloadProgress(closure: { (prog) in
            hud.progress = Float(prog.fractionCompleted)
        }).response { response in
            hud.hide(animated: true)
            if response.error == nil, let filePath = response.destinationURL?.path    {
                print("File Path",filePath)
                                //Open this filepath in Webview Object
                let fileURL = URL(fileURLWithPath: filePath)
                let documentInteractionController = UIDocumentInteractionController.init(url: fileURL)
                documentInteractionController.delegate = self
                documentInteractionController.presentPreview(animated: true)
            }
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }
}
