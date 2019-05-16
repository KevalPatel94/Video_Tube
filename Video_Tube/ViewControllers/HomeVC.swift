//
//  ViewController.swift
//  Video_Tube
//
//  Created by Keval Patel on 5/13/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//
//KEy: AIzaSyCRMQfgxj1-97JcnljYGC9O6P7hkG3ceyY
import UIKit
import YouTubePlayer
import RxSwift
class HomeVC: UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tblVideos: UITableView!
    //Floating Window
    @IBOutlet weak var floatingWindow: YouTubePlayerView!
    //AlertController for Filter Sheet
    var alertView: UIAlertController?
    //Picker View inside Filter Sheet
    var pickerView: UIPickerView?
    //VideosViewModel that passes the value to View from VideoModel
    var videosViewModel = [VideoViewModel]()
    //Array that contains different Filter Categories
    var filterList = [constants.latest.rawValue,constants.oldest.rawValue]
    let utilityQueue = DispatchQueue.global(qos: .utility)
    let mainQueue = DispatchQueue.main
    //Next page token to make api call
    var nextPageToken = ""
    //Value that indicates whether the api call is under process, to avoid unnecessary api calls
    var isFetching = false
    //variable for size of current array
    var currentSize = 0
    //last cell number which is played to stop later
    var lastPlayedCell = 0
    //Origin for floating windiw
    var playerViewOrigin : CGPoint!
    //variable that stores filter category which is latest by default
    var didselectedFilter = constants.latest.rawValue
    
    
    /* RxSwift variabhles for filtering functionality*/
    var disposeBag = DisposeBag()
    private var selectedFilter = Variable(constants.latest.rawValue)
    var observableForFilter:Observable<String>{
        return selectedFilter.asObservable()
    }
    /* RxSwift variabhles for filtering functionality*/

    enum constants : String{
        case latest = "Latest"
        case oldest = "Oldest"
        case titleSelect = "Select Filter Category"
        case select = "Select"
        case titleCancel = "Cancel"

    }
    enum urlStrings : String{
        case getVideos = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&pageToken=??&maxResults=10&playlistId=PLujWGHP4XolrvPGbwHI9XsC_4-_9sJncK&key=AIzaSyCRMQfgxj1-97JcnljYGC9O6P7hkG3ceyY"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Show Activity indicotor
        showActivityIndicator()
        //Floating Window Configuration
        configureFloatinWindow()
        //TableView Configuration
        tableviewConfiguration()
        //WebService Call to get Data
        getChannelData()
        //Subscriber Configuration
        //Function represents RxSwift Demo: Sunction subscribed on currentSelected FilterCategory
        subscriberToSelectedFilter()

        
    }
    //MARK: - getData BY calling Web Service
    func getChannelData() {
        //Check For Internet Connectivity and Notify User
        guard InternetConnectivity.isConnectedToNetwork() == true else {
            //End Refreshing and pop up noInternet Alert
            self.isFetching = false
            hideActivityIndicator()
            self.noInternetAlert()
            return
        }
        //Call WebService
        WebService.shared.fetchVideos(urlStrings.getVideos.rawValue.replacingOccurrences(of: "??", with: nextPageToken), utilityQueue, mainQueue) { (videos, error,token)  in
            //Use guard
            //Check For Error
            guard error == nil else{
                //Pop Up Error Alert
                self.errorAlert("Couldn't Find Data", error?.localizedDescription ?? "")
                return
            }
            //Store token for next page in nextPageToken variable
            self.nextPageToken = token ?? "Not Found"
            //Check for nil value in videos
            guard videos != nil else{return}
            //Append New elements in Ayyar
            self.videosViewModel.append(contentsOf: videos?.map({return VideoViewModel($0)}) ?? [])
            self.hideActivityIndicator()
            /* We have two different types of animation here*/
            //Animation option_1: - method refreshViewByInsertingRows()
            //This method will refresh view by inserting only new cells
            //If wants to use : refreshViewByInsertingRows()
            //Then uncomment the animations of tableview delegate method willDisplayCell
            self.refreshViewByInsertingRows()
            
            //Animation option_2: - method refreshViewByInsertingRows()
            //This method will refresh view by reloading whole tableview
            //If wants to use : refreshViewByInsertingRows()
            //Donot use tableview delegate method willDisplayCell
            //self.reloadViewWithAnimation()
            /* We have two different types of animation here*/

            self.isFetching = false
        }
    }
    //MARK: - animate tableview with animation
    func reloadViewWithAnimation(){
        UIView.transition(with: tblVideos, duration: 0.65, options: .transitionCrossDissolve, animations: {
            self.tblVideos.reloadData()
        }, completion: nil)
    }
    //MARK: - refreshViewByInsertingRows
    func refreshViewByInsertingRows(){
        /*This module helps avoid heavy tasks*/
        //Check for the length of current videoViewModel array, if the data is getting feeded from first time then the whole table will be reloaded otherwise new entries will be inserted after the last row
        if self.videosViewModel.count >= 1 {
            //This block will executed if the api call is not for first time
            //currentSize indicates the size of array before WebService Call
            let indexPaths = (self.currentSize - 1 ..< self.videosViewModel.count - 1).map { IndexPath(row: $0, section: 0) }
            self.tblVideos.beginUpdates()
            self.tblVideos.insertRows(at: indexPaths, with: .bottom)
            self.tblVideos.endUpdates()
        }
        else{
            //First Data Feed
            self.tblVideos.reloadData()
        }
        /*This module helps avoid heavy tasks*/
    }
    //MARK: - tableviewConfiguration
    func tableviewConfiguration(){
        tblVideos.delegate = self
        tblVideos.dataSource = self
        tblVideos.accessibilityIdentifier = "table--VideosTableView"
        tblVideos.tableFooterView = UIView()
    }
    //MARK: - hideActivityIndicator
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    //MARK: - showActivityIndicator
    func showActivityIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    //MARK: - configureFloatinWindow
    func configureFloatinWindow(){
        floatingWindow.delegate = self
        //Sets the initial origin for floating window
        playerViewOrigin = floatingWindow.frame.origin
        //By setting up this property floatingwindow will be able to play videos with out fullScreen mode
        floatingWindow.playerVars = ["playsinline" : 1] as YouTubePlayerView.YouTubePlayerParameters
        floatingWindow.isHidden = true
    }
    //MARK: - loadVideo
    /**
     This method load the video in]side the floatinWindow and will play after loading it
     
     - Parameter : *videoViewModel*
     */
    func loadVideo(_ videoViewModel: VideoViewModel) {
        floatingWindow.loadVideoID("\(videoViewModel.videoId)")
        floatingWindow.isHidden = false
        videoViewModel.isPlaying = true
        floatingWindow.play()
    }
    
    //MARK: - filterButton Action
    @IBAction func selBtnFilter(_ sender: Any) {
        //Constructs the Filter Sheet Alert
        self.constructAlertView(constants.titleSelect.rawValue)
    }
    //MARK: - FloatingWindow Pangesture action
    @IBAction func selPanGesture(_ sender: UIPanGestureRecognizer) {
        //Gets the view of floating window from sender
        let playerView = sender.view
        //initialize the translation for floating window
        let translation = sender.translation(in: view)
        //Checks for the states for rloating window
        switch sender.state {
        case .began, .changed:
            //This guard will check whether neew position of floating window is inside the bounds of superview
            guard (view.superview!.bounds.contains(sender.view!.frame)) else{
                //view is completely out of bounds of its super view.
                UIView.animate(withDuration: 0.5) {
                  //Sets the center of flotingWindow to the center of SuperView with animation
                  playerView?.center = self.view.superview!.center
                  sender.setTranslation(CGPoint.zero, in: self.view)
                }
                return
            }
            //If new position of floating window is inside the bounds of superview then update to new position
            playerView?.center = CGPoint(x: (playerView?.center.x)! + translation.x, y: (playerView?.center.y)! + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        default:
            break
        }
    }
    
}




//MARK: - UITableViewDelegate & UITableViewDataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosViewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVideos.dequeueReusableCell(withIdentifier: "VideoCell") as? VideoCell
        cell?.videoViewModel = videosViewModel[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard lastPlayedCell != indexPath.row else {
            return
        }
        //When new cell is selected to play video
        //stop the last video whic is being played and set the isplaying property to false for previous video
        //previous cell index will be avialble from *lastPlayedCell*
        floatingWindow.stop()
        videosViewModel[lastPlayedCell].isPlaying = false
        floatingWindow.isHidden = true
        //Get the new selected cell
        let cell = tblVideos.cellForRow(at: indexPath) as? VideoCell
        //Update lastplayedCell value
        lastPlayedCell = indexPath.row
        //Play New cell
        cell?.playVideo()
    }
    /**
     This method responsible for all the animations of cell before each cell is being displayed
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity,0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.45) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    //this delegate method will get called when any cell will be disappear
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tblVideos.cellForRow(at: indexPath) as? VideoCell
       // Check whether the last cell which is being disappear was playing video
        if videosViewModel[indexPath.row].isPlaying ?? false && cell?.viewYTPlayer.playerState == YouTubePlayerState.Playing{
            //load and play that video in floating window
            loadVideo(videosViewModel[indexPath.row])
        }
    }
   
    //MARK: - Implementation of Api call for infinite scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contenHeight = scrollView.contentSize.height
        //Check for offset to make api call
        if offSetY > contenHeight - scrollView.frame.height * 1{
            //Check whether last api call is completed
            if !isFetching{
                // Check Whether the next page is available or not
                if nextPageToken != "Not Found"{
                    //Store size of array to currentSize property to insert new rows after last row
                    self.isFetching = true
                    currentSize = videosViewModel.count
                    showActivityIndicator()
                    getChannelData()
                }
            }
        }
    }
}


//MARK: - PickerView Delegate for DJList ActionSheet
extension HomeVC: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (filterList.count)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(filterList[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didselectedFilter = filterList[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = filterList[row]
        return pickerLabel!
    }
    
}

//MARK: - Extension Filter Module implemented using RxSwift
extension HomeVC{
    //MARK:- Construct AlertView
    func constructAlertView(_ title: String){
        didselectedFilter = constants.latest.rawValue
        alertView = UIAlertController(
            title: title,
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .actionSheet)
        
        // Add alert Actions
        let action = UIAlertAction(title: constants.select.rawValue, style: UIAlertAction.Style.default) { (action) in
            self.selectedFilter.value = self.didselectedFilter
        }
        let anotheraction = UIAlertAction(title: constants.titleCancel.rawValue, style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alertView?.addAction(action)
        alertView?.addAction(anotheraction)
        
        // Add Picker View
        pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView?.dataSource = self
        pickerView?.delegate = self
        alertView?.view.addSubview(pickerView!)
        
        // Present Alert
        self.present(alertView!, animated: true) {
            self.pickerView?.frame.size.width = (self.alertView?.view.frame.size.width)!
        }
        
    }
    
    //MARK: - Configure subscriber
    func subscriberToSelectedFilter(){
        //Subscribe on observableForDJ
        observableForFilter.subscribe(onNext: { [weak self] (nameOfFilter) in
            //Will get execute every time selectedFilter will get change
            guard self?.videosViewModel.count ?? 0 >= 1 else{return}
            self?.configureFilteredViewModel(nameOfFilter)
            }, onError: { (error) in
                print(error)
        }, onCompleted: {
        }) {
            //Memory Management
            // Most Important part to Dispose using disposeBag
            }.disposed(by: disposeBag)
    }
    
    //Function that configure the filtered Array
    func configureFilteredViewModel(_ filter:String){
        if filter == constants.latest.rawValue{
            //Sort array for latest post
            videosViewModel = videosViewModel.sorted{$0.timeStamp > $1.timeStamp}
        }else{
            //Sort array for oldest post
            videosViewModel = videosViewModel.sorted{$0.timeStamp < $1.timeStamp}
        }
        //reload tableview and scroll to top
        tblVideos.reloadData()
        self.tblVideos.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

//MARK: - YouTubePlayerDelegate
extension HomeVC: YouTubePlayerDelegate{
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        floatingWindow.play()
    }
}


