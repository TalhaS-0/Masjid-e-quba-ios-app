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
import ScalingCarousel
import CenteredCollectionView
import WidgetKit


class HomeVC: BaseVC {
    
    //MARK: - Outlets variables
    @IBOutlet weak var newsCV: ScalingCarouselView!
    @IBOutlet weak var lblTodayDate: UILabel!
    @IBOutlet weak var lblTodayHijriDate: UILabel!
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var todayBtnView: UIView!

    @IBOutlet weak var namazTimeCV: UICollectionView!
    
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
    var months: [String] = []
    var days: [String] = []
    
    let cellPercentWidth: CGFloat = 1.0
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    //MARK: - Call when view intialized and load in frame
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ref = Database.database().reference()
        self.initView()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        newsCV.deviceRotated()
    }
    
    //MARK: - Intialize the view objects
    private func initView() {
        
        namazTimeCV.delegate = self
        namazTimeCV.dataSource = self
        
        centeredCollectionViewFlowLayout = (namazTimeCV.collectionViewLayout as! CenteredCollectionViewFlowLayout)

        // Modify the collectionView's decelerationRate (REQURED)
        namazTimeCV.decelerationRate = UIScrollView.DecelerationRate.fast
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.frame.width,
            height: namazTimeCV.frame.height
        )
        // Configure the optional inter item spacing (OPTIONAL)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20
        
        navigationController?.navigationBar.prefersLargeTitles = true

        lblTodayDate.text = getCurrentDate_Month_Year()
        lblTodayHijriDate.text = getCurrentHijriDate()
        currentDate = getCurrentDate()
        currentMonth = getCurrentMonth()
        currentYear = getCurrentYear()
        self.fetchNamazData()
        self.fetchNewsFeed()
        
        
        todayBtnView.layer.borderColor = UIColor.black.cgColor
        todayBtnView.layer.borderWidth = 2
        todayBtnView.layer.cornerRadius = todayBtnView.frame.height/2
        
        for i in 1...9{
            months.append("0\(i)")
            days.append("0\(i)")
        }
        months.append("10")
        months.append("11")
        months.append("12")
        
        for i in 10...31{
            days.append("\(i)")
        }

        print("Months ", months)
        print("Days ", days)
    }
    
    fileprivate func scrollToTodayTimings(){
        self.namazTimeCV.isPagingEnabled = false

        self.namazTimeCV.scrollToItem(at: IndexPath(item: (Int(self.currentDate)! - 1), section: (Int(self.currentMonth)! - 1)), at: .centeredHorizontally, animated: false)

//        self.namazTimeCV.reloadItems(at: [IndexPath.init(row: Int(self.currentDate)!, section: Int(self.currentMonth)!)])
//

        self.namazTimeCV.scrollToItem(at: IndexPath(item: (Int(self.currentDate)! - 1), section: (Int(self.currentMonth)! - 1)), at: .centeredHorizontally, animated: false)

    }
    @IBAction func actionTodayTime(_ sender: Any) {
        DispatchQueue.main.async {
            self.scrollToTodayTimings()

        }
        
//        fetchNamazData()
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
        RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: .date, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            
            let date = selectedDate
            print(date)
            print("Picked the date \(dateFormatter.string(from: date))")
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            self?.selectedDate_Month_year = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "yyyy"
            self?.selectedYear =   dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MM"
            self?.selectedMonth = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "dd"
            self?.selectedDate = dateFormatter.string(from: date)
            debugPrint(selectedDate)
            debugPrint(self?.selectedMonth! ?? "")
            debugPrint(self?.selectedYear! ?? "")
            
            if self?.selectedYear != self?.currentYear {
                self?.showAlert(title: ERROR, message: "Please select current year only")
            } else {
                
                self?.namazTimeCV.isPagingEnabled = false
                self?.namazTimeCV.scrollToItem(at: IndexPath(item: Int((self?.selectedDate!)!)! - 1, section: Int((self?.selectedMonth!)!)! - 1), at: .centeredHorizontally, animated: false)
                self?.namazTimeCV.scrollToItem(at: IndexPath(item: Int((self?.selectedDate!)!)! - 1, section: Int((self?.selectedMonth!)!)! - 1), at: .centeredHorizontally, animated: false)

//                let selectedMonth = self?.CalendarDict[self?.selectedMonth!] as! NSDictionary
//                debugPrint(selectedMonth)
//                let selectedDate = selectedMonth[self?.selectedDate!] as! NSDictionary
//                debugPrint(selectedDate)
//                SetUpNamazTimings(selectedDate)
                self?.lblTodayDate.text = self?.selectedDate_Month_year
                self?.lblTodayHijriDate.text = self?.getHijriDate(fromDate: date)
            }
        })
    }
    
    
    //MARK: - Fetch namaz data from firebase
    private func fetchNamazData() {
      //  ActivityIndicatorShow()
        showIndicator()
        ref.child("calender").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
           // self.ActivityIndicatorDismiss()
            if let value = snapshot.value as? NSDictionary {
                print("CalendarDict", value)
                self.CalendarDict = value
                print("allKeysMonths", self.CalendarDict.allKeys)

                let currentMonth = value[self.currentMonth!] as? NSDictionary
//                debugPrint("currentMonth ", currentMonth?["32"])
                print("allKeysDays", currentMonth?.allKeys ?? 0)
                let currentDate = currentMonth![self.currentDate!] as? NSDictionary
//                debugPrint("currentDate ",self.currentDate!)
                print("allKeysADay", currentDate?.allKeys ?? 0)

//                self.TodayTiming = currentDate!
//                self.SetUpNamazTimings(self.TodayTiming)
                //update widget
                if let userDefaults = UserDefaults(suiteName: "group.com.ATSO.Masjid-e-Quba"){
                    let currentHour = Calendar.current.component(.hour, from: Date())
                    print("currentHour", currentHour)
                    let fajarStart = (currentDate?[Namaz.fajarStart.rawValue] as! String)
                    let fajarJamat = (currentDate?[Namaz.fajar.rawValue] as! String)
                    let zhrStart = (currentDate?[Namaz.zuharStart.rawValue] as! String)
                    let zhrJamat = (currentDate?[Namaz.zuhar.rawValue] as! String)

                    let asrStart = (currentDate?[Namaz.asarStart.rawValue] as! String)
                    let asarJamat = (currentDate?[Namaz.asar.rawValue] as! String)

                    let magribStart = (currentDate?[Namaz.maghribStart.rawValue] as! String)
                    let magribJamat = (currentDate?[Namaz.maghrib.rawValue] as! String)

                    let ishaStart = (currentDate?[Namaz.ishaStart.rawValue] as! String)
                    let ishaJamat = (currentDate?[Namaz.isha.rawValue] as! String)
                    
                    let fajarHour = Int(String(fajarStart.prefix(2))) ?? 0
                    let zuharHour = Int(String(zhrStart.prefix(2))) ?? 0
                    let asarHour = Int(String(asrStart.prefix(2))) ?? 0
                    let magribHour = Int(String(magribStart.prefix(2))) ?? 0
                    let ishaHour = Int(String(ishaStart.prefix(2))) ?? 0

                    if fajarHour > currentHour{
                        userDefaults.setValue("Fajar", forKey: "NamazName")
                        userDefaults.setValue(fajarStart, forKey: "StartTime")
                        userDefaults.setValue(fajarJamat, forKey: "JamatTime")
                    }else if zuharHour > currentHour{
                        userDefaults.setValue("Zuhar", forKey: "NamazName")
                        userDefaults.setValue(zhrStart, forKey: "StartTime")
                        userDefaults.setValue(zhrJamat, forKey: "JamatTime")
                    }else if asarHour > currentHour{
                        userDefaults.setValue("Asar", forKey: "NamazName")
                        userDefaults.setValue(asrStart, forKey: "StartTime")
                        userDefaults.setValue(asarJamat, forKey: "JamatTime")
                    }else if magribHour > currentHour{
                        userDefaults.setValue("Magrib", forKey: "NamazName")
                        userDefaults.setValue(magribStart, forKey: "StartTime")
                        userDefaults.setValue(magribJamat, forKey: "JamatTime")
                    }else if ishaHour > currentHour{
                        userDefaults.setValue("Isha", forKey: "NamazName")
                        userDefaults.setValue(ishaStart, forKey: "StartTime")
                        userDefaults.setValue(ishaJamat, forKey: "JamatTime")
                    }else{
                        let nextDate = Int(self.currentDate!)! + 1
                        let nextDay = currentMonth![nextDate] as? NSDictionary
                        let fajarStart = (nextDay?[Namaz.fajarStart.rawValue] as! String)
                        let fajarJamat = (nextDay?[Namaz.fajar.rawValue] as! String)
                        userDefaults.setValue("Fajar", forKey: "NamazName")
                        userDefaults.setValue(fajarStart, forKey: "StartTime")
                        userDefaults.setValue(fajarJamat, forKey: "JamatTime")
                        
                    }
                    print("NamazName",userDefaults.value(forKey: "NamazName") as? String ?? "No Name")
                    
                    if #available(iOS 14.0, *) {
                        WidgetCenter.shared.reloadAllTimelines()
                    } else {
                        print("Older version of ios")
                    }
                }else{
                    print("Update widget error")
                }
                    
                
                DispatchQueue.main.async {
                    self.namazTimeCV.reloadData()
                    self.scrollToTodayTimings()
                    self.hideIndicator()

                }

                
                
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
//    private func SetUpNamazTimings(_ schedule: NSDictionary) {
//        lblFajrStart.text = (schedule[Namaz.fajarStart.rawValue] as! String)
//        lblFajrJamat.text = (schedule[Namaz.fajar.rawValue] as! String)
//        lblSunriseTime.text = (schedule[Namaz.sunRise.rawValue] as! String)
//        lblZhrStart.text = (schedule[Namaz.zuharStart.rawValue] as! String)
//        lblZhrJamat.text = (schedule[Namaz.zuhar.rawValue] as! String)
//        lblAsrStart.text = (schedule[Namaz.asarStart.rawValue] as! String)
//        lblAsrJamat.text = (schedule[Namaz.asar.rawValue] as! String)
//        lblMaghribStart.text = (schedule[Namaz.maghribStart.rawValue] as! String)
//        lblMaghribJamat.text = (schedule[Namaz.maghrib.rawValue] as! String)
//        lblIshaStart.text = (schedule[Namaz.ishaStart.rawValue] as! String)
//        lblIshaJamat.text = (schedule[Namaz.isha.rawValue] as! String)
//    }
    
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
                self.newsCV.reloadData()
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
    fileprivate func getNoOfDaysInMonth(year: Int, month: Int) -> Int{
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == newsCV{
            return 1
        }else{
            return months.count
        }
    }
    // MARK: - Number of Items in section Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newsCV{
            return newsModel.count
        }else{
            return getNoOfDaysInMonth(year: 2022, month: Int(months[section])!)
        }
    }
    
    // MARK: - Cell for Item on indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newsCV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCollectionViewCell
            let obj = newsModel[indexPath.row]
            cell.lblTitle.text = obj.title?.rendered
            cell.lblDescription.text = obj.excerpt?.rendered?.stripOutHtml()
            cell.lblDate.text = obj.date
            
            //give shadow
            cell.shadowView.layer.shadowColor = UIColor.black.cgColor
            cell.shadowView.layer.shadowOpacity = 0.2
            cell.shadowView.layer.shadowOffset = .zero
            cell.shadowView.layer.shadowRadius = 4
            cell.shadowView.layer.cornerRadius = 4
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCVC", for: indexPath) as! TimeCVC
            
            if let currentMonth = CalendarDict[months[indexPath.section]] as? NSDictionary{
                debugPrint("currentMonthhh ", indexPath.section + 1)
                if let currentDate = currentMonth[days[indexPath.row]] as? NSDictionary{
                    debugPrint("currentDateee ", indexPath.row + 1)

                    //set date
                    let dateString = "\(days[indexPath.row])/\(months[indexPath.section])/\(2022)"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yy"
                    let date = dateFormatter.date(from: dateString)
                    dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
                    self.lblTodayDate.text = dateFormatter.string(from: date ?? Date())
                    self.lblTodayHijriDate.text = self.getHijriDate(fromDate: date ?? Date())


                    cell.lblFajrStart.text = (currentDate[Namaz.fajarStart.rawValue] as! String)
                    cell.lblFajrJamat.text = (currentDate[Namaz.fajar.rawValue] as! String)
                    cell.lblSunriseTime.text = (currentDate[Namaz.sunRise.rawValue] as! String)
                    cell.lblZhrStart.text = (currentDate[Namaz.zuharStart.rawValue] as! String)
                    cell.lblZhrJamat.text = (currentDate[Namaz.zuhar.rawValue] as! String)
                    cell.lblAsrStart.text = (currentDate[Namaz.asarStart.rawValue] as! String)
                    cell.lblAsrJamat.text = (currentDate[Namaz.asar.rawValue] as! String)
                    cell.lblMaghribStart.text = (currentDate[Namaz.maghribStart.rawValue] as! String)
                    cell.lblMaghribJamat.text = (currentDate[Namaz.maghrib.rawValue] as! String)
                    cell.lblIshaStart.text = (currentDate[Namaz.ishaStart.rawValue] as! String)
                    cell.lblIshaJamat.text = (currentDate[Namaz.isha.rawValue] as! String)

                    
                }else{
                    print("Date Error")
                }
                
            }else{
                print("Month Error")
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newsCV{
            let obj = newsModel[indexPath.row]
            guard let url = URL(string: obj.link ?? "http://www.mequba.com") else { return }
            UIApplication.shared.open(url)

        }else{
            print("calender tapped")
        }
    }
    
    // MARK: - Flowlayout delegate to set size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = namazTimeCV.frame.width
        let height = namazTimeCV.frame.height
        // in case you you want the cell to be 40% of your controllers view
        // If you want to horizontal scroll and show as slider to view items
        if collectionView == newsCV{

            return CGSize(width: width , height: newsCV.frame.height);
        }else{
            return CGSize(width: width, height: height)
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        newsCV.didScroll()
//    }
}
