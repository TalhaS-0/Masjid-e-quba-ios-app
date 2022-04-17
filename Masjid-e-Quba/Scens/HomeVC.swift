//
//  ViewController.swift
//  Masjid-e-Quba
//
//  Created by Ali Waseem on 1/25/22.
//

import UIKit
import Alamofire
import Firebase
import ANActivityIndicator


class HomeVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets variables
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTodayDate: UILabel!
    @IBOutlet weak var lblTodayHijriDate: UILabel!
    @IBOutlet weak var lblFajrStart: UILabel!
    @IBOutlet weak var lblFajrJamat: UILabel!
    @IBOutlet weak var lblSunriseTime: UILabel!
    @IBOutlet weak var lblZhrStart: UILabel!
    @IBOutlet weak var lblZhrJamat: UILabel!
    @IBOutlet weak var lblAsrStart: UILabel!
    @IBOutlet weak var lblAsrJamat: UILabel!
    @IBOutlet weak var lblMaghribStart: UILabel!
    @IBOutlet weak var lblMaghribJamat: UILabel!
    @IBOutlet weak var lblIshaStart: UILabel!
    @IBOutlet weak var lblIshaJamat: UILabel!
    
    //MARK: - Local variables
    var CalendarDict = NSDictionary()
    var MonthDict = NSDictionary()
    var TodayTiming = NSDictionary()
    var currentMonth: String!
    var currentDate: String!
    var currentYear: String!
    var selectedDate: String!
    var selectedMonth: String!
    var selectedYear: String!
    var selectedDate_Month_year: String!
    var calendarModel = CalenderModel()
    var newsModel: [NewsFeed] = []
    var ref: DatabaseReference!
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    
    //MARK: - Call when view intialized and load in frame
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ref = Database.database().reference()
        self.initView()
    }
    
    //MARK: - Intialize the view objects
    private func initView() {
        lblTodayDate.text = getCurrentDate_Month_Year()
        lblTodayHijriDate.text = getCurrentHijriDate()
        currentDate = getCurrentDate()
        currentMonth = getCurrentMonth()
        currentYear = getCurrentYear()
        self.fetchNamazData()
        self.fetchNewsFeed()
    }
    
    // MARK: - Number of Items in section Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsModel.count
    }
    
    // MARK: - Cell for Item on indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCollectionViewCell
        let obj = newsModel[indexPath.row]
        cell.lblTitle.text = obj.title?.rendered
        cell.lblDescription.text = obj.excerpt?.rendered?.stripOutHtml()
        cell.lblDate.text = obj.date
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = newsModel[indexPath.row]
        guard let url = URL(string: obj.link ?? "http://www.mequba.com") else { return }
        UIApplication.shared.open(url)
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsVC") as? NewsVC else { return }
//        vc.url = obj.link
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Flowlayout delegate to set size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width;
        // in case you you want the cell to be 40% of your controllers view
        // If you want to horizontal scroll and show as slider to view items
        return CGSize(width:width * 0.85 , height: width * 0.30);
    }
    
    @IBAction func actionTodayTime(_ sender: Any) {
        fetchNamazData()
    }
    
    @IBAction func actionLiveStream(_ sender: Any) {
        NavigateToNextView(LiveStreamVC.self)
    }
    
    @IBAction func acctionMore(_ sender: Any) {
        showActionSheet(title: "App Data", message: "") {
            self.showAlert(title: "About", message: "Masjid-e-Quba version \(self.getAppVersion()) \n Developed by ATSO \n \n All rights resirved")
        } emailCallback: {
            self.showAlert(title: "Masjid Details", message: "Masjid-e-Quba \n 70-72 Cazenove Road \n London \n N16 6AA \n \n 020 8806 6540 \n www.mequba.com \n info@mequba.com \n \n Live Streaming \n http://www.mequba.com/live-streaming/ \n \n Radio: 454.025")
        }
    }
    
    
    
    //MARK: - Action on label date using button
    @IBAction func actionDatePicker(_ sender: Any) {
        datePicker = UIDatePicker.init()
        datePicker.date = Date()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .white
    
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(datePicker)
                   
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.black
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
            
        if let date = sender?.date {
            print(date)
            print("Picked the date \(dateFormatter.string(from: date))")
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            selectedDate_Month_year = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "yyyy"
            selectedYear = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MM"
            selectedMonth = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "dd"
            selectedDate = dateFormatter.string(from: date)
            debugPrint(selectedDate!)
            debugPrint(selectedMonth!)
            debugPrint(selectedYear!)
        }
    }

    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        if selectedYear != currentYear {
            self.showAlert(title: ERROR, message: "Please select current year only")
        } else {
            debugPrint(selectedMonth!)
            debugPrint(selectedDate!)
            let selectedMonth = CalendarDict[selectedMonth!] as! NSDictionary
            debugPrint(selectedMonth)
            let selectedDate = selectedMonth[selectedDate!] as! NSDictionary
            debugPrint(selectedDate)
            SetUpNamazTimings(selectedDate)
            lblTodayDate.text = selectedDate_Month_year
        }
    }
    
    
    //MARK: - Fetch namaz data from firebase
    private func fetchNamazData() {
      //  ActivityIndicatorShow()
        showIndicator()
        ref.child("calender").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
           // self.ActivityIndicatorDismiss()
            self.hideIndicator()
            if let value = snapshot.value as? NSDictionary {
                print(value)
                self.CalendarDict = value
                let currentMonth = value[self.currentMonth!] as? NSDictionary
                debugPrint(currentMonth!)
                let currentDate = currentMonth![self.currentDate!] as? NSDictionary
                debugPrint(currentDate!)
                self.TodayTiming = currentDate!
                self.SetUpNamazTimings(self.TodayTiming)
//                for eachSnap in value {
//                    guard let eachUserDict = eachSnap.value as? Dictionary<String,AnyObject> else { return }
//                    debugPrint(eachUserDict)
//                 // eachUserDict is an object/ dictionary representation for each user
//
//               }
            }
            
              
//            if let userDict = snapshot.value as? [String:AnyObject]{
//               print(userDict)
//
//            }
            
//             if  snapshot.exists() {
//                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
//                 debugPrint(snapshot)
             
            DispatchQueue.main.async {
                 self.ActivityIndicatorDismiss()
            }
        }) { error in
            
           DispatchQueue.main.async {
          self.ActivityIndicatorDismiss()
           }
          print(error.localizedDescription)
        }
}
    
    
    //MARK: - SetupData in field
    private func SetUpNamazTimings(_ schedule: NSDictionary) {
        lblFajrStart.text = (schedule[Namaz.fajarStart.rawValue] as! String)
        lblFajrJamat.text = (schedule[Namaz.fajar.rawValue] as! String)
        lblSunriseTime.text = (schedule[Namaz.sunRise.rawValue] as! String)
        lblZhrStart.text = (schedule[Namaz.zuharStart.rawValue] as! String)
        lblZhrJamat.text = (schedule[Namaz.zuhar.rawValue] as! String)
        lblAsrStart.text = (schedule[Namaz.asarStart.rawValue] as! String)
        lblAsrJamat.text = (schedule[Namaz.asar.rawValue] as! String)
        lblMaghribStart.text = (schedule[Namaz.maghribStart.rawValue] as! String)
        lblMaghribJamat.text = (schedule[Namaz.maghrib.rawValue] as! String)
        lblIshaStart.text = (schedule[Namaz.ishaStart.rawValue] as! String)
        lblIshaJamat.text = (schedule[Namaz.isha.rawValue] as! String)
    }
    
    private func fetchNewsFeed() {
        showIndicator()
        ApiManager.shared.GetRequest(urlString: BASE_URL + GET_NEWS, isAlertShow: false, parameters: [:], header: [:]) { response in
            self.hideIndicator()
            let decoder = JSONDecoder()
            let JSONData = try? decoder.decode([NewsFeed].self, from: response)
            debugPrint(JSONData!)
            if JSONData!.count > 0 {
                self.newsModel = JSONData!
                dump(self.newsModel)
                self.collectionView.reloadData()
            } else {
                self.showAlert(title: ERROR, message: "No data found")
            }
        } errorCallBack: { error in
            self.showAlert(title: ERROR, message: error)
        }
    }
    
    //MARK: - Download the file is old now use firebase
//    private func DownloadFile() {
//        ApiManager.shared.DownloadFile { path in
//            self.saveFilePath(path)
//            debugPrint(self.getFilePath())
//        } errorCallBack: { error in
//            self.showAlert(title: ERROR, message: error)
//        }
//    }
    
}

