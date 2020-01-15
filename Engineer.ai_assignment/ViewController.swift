//
//  ViewController.swift
//  Engineer.ai_assignment
//
//  Created by Ranjeet on 15/01/20.
//  Copyright © 2020 Ranjeet. All rights reserved.
//

import UIKit
import NVActivityIndicatorView;

class ViewController: UIViewController {
    
    @IBOutlet var tbldata: UITableView!
    var arrdata = [tableDataDS]();
    var pageIndex: Int = 1
    var isloadingrequest:Bool = false;

    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.Call API
        self.getresult_fromAPI()
        
        //2. Add RefreshControl
        refreshControl.addTarget(self, action: #selector(refreshFromPullRequest), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string:"Pull to refresh")
        if #available(iOS 10.0, *) {
            tbldata.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            tbldata.addSubview(refreshControl)
        }

        // Do any additional setup after loading the view.
    }

    // Refresh table
    @objc func refreshFromPullRequest(sender:AnyObject)
    {
        self.title = ""
        pageIndex = 1
        self.arrdata.removeAll()
        self.getresult_fromAPI()
    }
    
    // Change Date Format
    func getdate(dateString:String) -> String {
        let len1 = dateString.lengthOfBytes(using: .utf8)
        guard len1 > 0 else {return dateString}
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if dateFormater.date(from:dateString) == nil{
            dateFormater.dateFormat = "yyyy-MM-dd"
        }
        let currentDate = dateFormater.date(from: dateString)
        let dateFormater2 = DateFormatter()
        dateFormater2.dateFormat = "dd-MMM-yyyy"
        return dateFormater2.string(from: currentDate!)
    }

    
    // API Call
    func getresult_fromAPI(){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(), nil)
        let urlstr = String(format:"https://hn.algolia.com/api/v1/search_by_date?tags=story&page=%@","\(pageIndex)")
        let url = URL(string:urlstr)!
        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let result = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                if let result = result  as? NSDictionary{
                    if let arrydata = result.object(forKey:"hits") as? NSArray
                    {
                        for each in arrydata{
                            if let jsonData: Data = try? JSONSerialization.data(withJSONObject: each){
                                if let dataObject = try? JSONDecoder().decode(tableDataDS.self, from: jsonData){
                                    self.arrdata.append(dataObject)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.isloadingrequest = false
                            self.refreshControl.endRefreshing()
                            self.tbldata.reloadData()
                        }
                    }
                    
                }
                
            } catch {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self.refreshControl.endRefreshing()
                print("json error: \(error)")
            }
        }
        task.resume()
        
    }

}

extension ViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrdata.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableDataCell = tableView.dequeueReusableCell(withIdentifier: "TableDataCell", for: indexPath) as! TableDataCell
        cell.selectionStyle = .none
        guard arrdata.count > 0 else {
            return cell
        }
        
        let ds = arrdata[indexPath.row]
        cell.lbltitle.text = ds.title
        cell.lblcreated.text = "created at: \(self.getdate(dateString: ds.created_at))"
        cell.btnSwitch.tag = indexPath.row
        cell.btnSwitch.setOn(ds.status, animated: true)
        cell.delegate = self
        cell.isSelected = ds.status
        cell.viewback.backgroundColor = ds.status == true ? UIColor.lightGray:UIColor.white

        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ds = arrdata[indexPath.row]
        ds.status = !ds.status
        let filterarray = arrdata.filter{ ($0.status == true)}
        tbldata.reloadData()
        guard filterarray.count > 0 else {
            return
        }
        self.title = "Tota selected post = \(filterarray.count)"


    }
    
}
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            if  !isloadingrequest{
                pageIndex = pageIndex + 1
                self.getresult_fromAPI()
                isloadingrequest = true
            }
        }
    }
}
extension ViewController: tableCellDelegate {
    func change_switch(index:Int,status:Bool)
    {
        let ds = arrdata[index]
        ds.status = status
        let filterarray = arrdata.filter{ ($0.status == true)}
        tbldata.reloadData()
        guard filterarray.count > 0 else {
            return
        }
        self.title = "Tota selected post = \(filterarray.count)"
    }

}


