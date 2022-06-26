//
//  Cell.swift
//  Campfire
//
//  Created by Jamal Benamor on 11/06/2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import AVFAudio
import AVFoundation
import FDWaveformView


let audioCache = NSCache<NSString, NSURL>()

class PostCell: UICollectionViewCell {
    
    var homeViewController: HomeViewController?
//    var player = AVPlayer()
    var audioPlayer:AVAudioPlayer!
    var isPlaying = false
    var recordingSession:AVAudioSession!
    var meterTimer:Timer!
    var fileDuration: Int?
    var animator: UIViewPropertyAnimator!
    
    var post: Post? {
        didSet {
            
            print("didSet post for user: ", post!.uid)
            if Profile.profile.posted_today {
                hideBlur()
            } else {
                showBlur()
            }

            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            if uid == post!.uid {
                // setup if its my post
                
                nameLabel.text = "Me"
                
                if post?.responses == 0 {
                    self.hearResponsesButton.setTitle("You have no voice messages", for: .normal)
                } else if post?.responses == 1 {
                    self.hearResponsesButton.setTitle("Listen to 1 voice message ➤", for: .normal)
                } else {
                    self.hearResponsesButton.setTitle("Listen to all"+String(post!.responses)+"voice messages ➤", for: .normal)
                    
                }
                
                recordButton.isEnabled = false
                recordButton.isHidden = true
                hearResponsesButton.isEnabled = true
                hearResponsesButton.isHidden = false
                responsesButton.isHidden = false
                
                self.downloadAudio(url: post!.recording_url)//last_recording)
                
            } else {
                
                nameLabel.isHidden = false
                moreButton.isHidden = false
                spinner.isHidden = false
                recordButton.isEnabled = true
                recordButton.isHidden = false
                
                hearResponsesButton.isEnabled = false
                hearResponsesButton.isHidden = true
                
                responsesButton.isHidden = true
                
                
                
//                spinner.animate()
//                usernameLabel.text = user!.username //@
                nameLabel.text = post?.name
                self.downloadAudio(url: post!.recording_url)//last_recording)
                
                // set profile images
//                let profile_image = user?.profile_image
//                let profile_image_url = user?.profile_image_url
//
//                if profile_image == UIImage(systemName: "person.circle.fill") {
//                    print("no contact image profile picture")
//
//                    if profile_image_url != "" {
//                        // stored profile image in db
//                        print("stored profile image in db, image url: ", profile_image_url!)
//                        self.profileImageLabel.text = ""
//                        self.profileImageLabel.isHidden = true
//                        self.profileColorView.isHidden = true
//                        self.profileImageView.isHidden = false
//                        self.loadImage(urlString: profile_image_url!)
//                    } else {
//                        // no stored profile image in db
//                        print("no stored profile image in db")
//                        self.profileImageLabel.text = String(user!.name.prefix(1))
//                        self.profileColorView.backgroundColor = .random
//                        self.profileImageView.isHidden = true
//                        self.profileColorView.isHidden = false
//                        self.profileImageLabel.isHidden = false
//                        self.spinner.isHidden = true
//                    }
//                } else {
//                    print("contact image set")
//                    profileImageView.image = profile_image
//                    self.profileImageLabel.isHidden = true
//                    self.profileColorView.isHidden = true
//                    self.profileImageView.isHidden = false
//                    self.spinner.isHidden = true
//                }
            }
        }
    }
    
    let cellView: UIView = {
        let iv = UIView()
        iv.backgroundColor = Varibles.foregroundBlack//.white
        iv.layer.borderWidth = 1
        iv.layer.borderColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.clipsToBounds = true
        return iv
    }()
    
    let profileColorView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .random
        iv.clipsToBounds = true
        return iv
    }()
    
    let profileImageLabel: UILabel = {
        let label = UILabel()
        label.text = "K"
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25) //UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
        let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
//        button.isHidden = true
        return button
    }()
    
//    let shareButton: UIButton = {
//        let button = UIButton()
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
//        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: largeConfig)
//        button.setImage(image, for: .normal)
//        button.tintColor = .black
//        button.backgroundColor = .white
//        button.layer.masksToBounds = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
////        button.isEnabled = false
////        button.isHidden = true
//        return button
//    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
        let image = UIImage(systemName: "mic.fill", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(recordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
     
    
    
    let hearResponsesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Listen to received voice messages ➤", for: .normal)
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.setTitleColor(.lightGray, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.textAlignment = .right
//        label.backgroundColor = .red
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.borderless()
            config.buttonSize = .small
            config.cornerStyle = .medium
            button.configuration = config
            button.showsMenuAsPrimaryAction = true
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .heavy, scale: .large)
            let image = UIImage(systemName: "ellipsis", withConfiguration: largeConfig)
            button.setImage(image, for: .normal)
             
        } else {
            // Fallback on earlier versions
            print("not ios 15")
        }
        return button
      
    }()
    
    
    let waveform: FDWaveformView = {
        let wave = FDWaveformView()
        
        wave.doesAllowScrubbing = false
        wave.doesAllowStretch = false
        wave.doesAllowScroll = false
        
        wave.wavesColor = .white
        wave.progressColor = .gray
        wave.clipsToBounds = true
        return wave
    }()
    
    
    
    private func beginSampleScrolling() {
        let totalSamples = waveform.totalSamples
        guard audioPlayer != nil else { return }
        
        animator = UIViewPropertyAnimator(duration: TimeInterval(audioPlayer.duration), curve: .linear) { [waveform] in //.truncatingRemainder(dividingBy: 60)
            waveform.highlightedSamples = 0..<totalSamples
        }
        
        animator.startAnimation()
        
    }
    
    private func resetSamplesScrolling() {
        animator.stopAnimation(true)
        waveform.highlightedSamples = 0..<1
    }
    
    let yourRecordingLabel: UILabel = {
        let label = UILabel()
        label.text = "Your recording"
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let responsesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Hear all responses", for: .normal)
        button.layer.masksToBounds = true
        button.setTitleColor(.gray, for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(responsesButtonPressed), for: .touchUpInside)
//        button.isEnabled = false
//        button.isHidden = true
        return button
    }()
    
    
    @objc func playPressed() {
        print("play pressed")
        
        
        if isPlaying {
            
            pauseAudio()
            resetTimeLabel()
            
            self.isPlaying = false
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
            let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
            playButton.setImage(image, for: .normal)

            
        } else {
                
            playAudio()
            
//                print("gets 3")
            self.isPlaying = true
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
            let image = UIImage(systemName: "pause.fill", withConfiguration: largeConfig)
            playButton.setImage(image, for: .normal)
          
        }
        
        
    }
    
    func resetTimeLabel() {
        let duration = Int(audioPlayer.duration)//.truncatingRemainder(dividingBy: 60))
        let durationString = String(duration)//.prefix(3)
        self.timeLabel.text = durationString+"s"//String((durationString).prefix(3))+"s"
    }
    
    
    
    
    let spinner: SpinnerView = {
        let spinner = SpinnerView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.animate()
        return spinner
        
    }()
    
    let playSpinner: SpinnerView = {
        let spinner = SpinnerView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.animate()
        return spinner
        
    }()
    
    
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.backgroundColor = .clear//UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.effect = UIBlurEffect(style: .dark)
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    
    let blurTitleIcon: UIImageView = {
        let image = UIImageView()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy, scale: .large)
        image.image = UIImage(systemName: "speaker.slash.fill", withConfiguration: largeConfig)
        image.backgroundColor = .clear
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.isHidden = true
        return image
    }()
    
    let blurTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Post to hear"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
//        label.centerVerticalText()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isEditable = false
//        label.isSelectable = false
//        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    let blurLabel: UILabel = {
        let label = UILabel()
        label.text = "To hear your friends' Campfire, share yours with them."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
//        label.centerVerticalText()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isEditable = false
//        label.isSelectable = false
//        label.isScrollEnabled = false
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = false
        label.isHidden = true
        return label
    }()
    
    let blurButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post Campfire", for: .normal)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
//        button.addTarget(self, action: #selector(recordResponse), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    func setupBlurView() {
        print("setupBlurView, Varibles.postedToday: ", Profile.profile.posted_today)
        addSubview(blurView)
        blurView.anchor(top: cellView.topAnchor, left: leftAnchor, bottom: cellView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(blurTitleLabel)
        blurTitleLabel.anchor(top: nil, left: leftAnchor, bottom: blurView.centerYAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 35)

        addSubview(blurLabel)
        blurLabel.anchor(top: blurTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 30)
        blurLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(blurButton)
        blurButton.anchor(top: blurLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 45)
        blurButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(blurTitleIcon)
        blurTitleIcon.anchor(top: nil, left: nil, bottom: blurTitleLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        blurTitleIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        
        if Profile.profile.posted_today {
            hideBlur()
        } else {
            showBlur()
        }
    }
    
    func showBlur() {
        blurView.isHidden = false
        blurLabel.isHidden = false
        blurTitleLabel.isHidden = false
        blurTitleIcon.isHidden = false
        blurButton.isHidden = false
    }
    
    func hideBlur() {
        blurView.isHidden = true
        blurLabel.isHidden = true
        blurTitleLabel.isHidden = true
        blurTitleIcon.isHidden = true
        blurButton.isHidden = true
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        let separatorView2 = UIView()
//        separatorView2.backgroundColor = .green//UIColor(white: 255, alpha: 0.5)
//        addSubview(separatorView2)
//        separatorView2.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupPostUI()
        
        
        
        setupBlurView()
        
        
    }
    
    var cellViewTopConstraintToTop: NSLayoutConstraint?
    var cellViewTopConstraintToProfileImage: NSLayoutConstraint?
    
    func setupPostUI() {
        
        addSubview(cellView)
        addSubview(nameLabel)
        addSubview(moreButton)
        addSubview(playButton)
        addSubview(recordButton)
        addSubview(hearResponsesButton)
        addSubview(waveform)
        addSubview(playSpinner)
        addSubview(timeLabel)
        
        cellView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        cellView.layer.cornerRadius = 20
        
        
        nameLabel.anchor(top: cellView.topAnchor, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        moreButton.anchor(top: nameLabel.topAnchor, left: nil, bottom: nameLabel.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 50, height: 0)
        
        
        
        
        playButton.anchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        playButton.layer.cornerRadius = 40 / 2
        playButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        playSpinner.anchor(top: playButton.topAnchor, left: playButton.leftAnchor, bottom: playButton.bottomAnchor, right: playButton.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        
        
        timeLabel.anchor(top: nil, left: nil, bottom: nil, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 32, width: 30, height: 0)
        timeLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        waveform.anchor(top: nil, left: playButton.rightAnchor, bottom: nil, right: timeLabel.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 70)
        waveform.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true

        
        
        
        recordButton.anchor(top: nil, left: nil, bottom: cellView.bottomAnchor, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 50, height: 50)
        recordButton.layer.cornerRadius = 50 / 2
        
        hearResponsesButton.anchor(top: recordButton.topAnchor, left: cellView.leftAnchor, bottom: recordButton.bottomAnchor, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        
        
        
         
    }
    
    func actionSheet(username: String) {
        let data = "Add @\(username) on Campfire https://apple.co/3xoYygf"
//        guard let data = URL(string: "https://www.zoho.com") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func actionSheetDownloadAudio(url: String) {
        let data = "Add @\(url) on Campfire https://apple.co/3xoYygf"
        
        if let audioUrl = URL(string: url) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                let av = UIActivityViewController(activityItems: [destinationUrl], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(urlString: String) {
        
        profileImageView.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            profileImageView.image = cachedImage
            self.spinner.isHidden = true
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }

            DispatchQueue.main.async(execute: {

                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)

                    self.profileImageView.image = downloadedImage
                    self.spinner.isHidden = true
                }
            })
        }).resume()
    }
    
    func downloadAudio(url: String) {
        print("downloadaudio")
        
        self.playSpinner.animate()
        self.playSpinner.isHidden = false
        
        if let audioUrl = URL(string: url) {
                    
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                print(destinationUrl)
                
                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                    self.playSpinner.isHidden = true
                    
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                        self.waveform.audioURL = destinationUrl
                        
//                        self.waveform.progressSamples = self.waveform.totalSamples / 2
                        self.resetTimeLabel()
                         
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                    
                    
                    // if the file doesn't exist
                } else {
                    
                    // you can use NSURLSession.sharedSession to download the data asynchronously
                    URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                        guard let location = location, error == nil else { return }
                        do {
                            do
                            {
                                // after downloading your file you need to move it to your destination url
                                try FileManager.default.moveItem(at: location, to: destinationUrl)
                                print("File moved to documents folder")
                                
                                self.audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                                
                                DispatchQueue.main.async {
                                    self.playSpinner.isHidden = true
                                    self.waveform.audioURL = destinationUrl
                                    
//                                    self.waveform.progressSamples = self.waveform.totalSamples / 2
                                    self.resetTimeLabel()
                                    
                                }
                                
                                
                            }
                            catch
                            {
                                
                            }
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                self.playSpinner.isHidden = true
                            }
                        }
                    }).resume()
                }
            }
    }
    
    func playAudio() {
        let url = (post?.recording_url)//last_recording)
        if let audioUrl = URL(string: url!) {
                    
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
     
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                guard let player = audioPlayer else { return }
                try AVAudioSession.sharedInstance().setCategory(.playback)
//                try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//                player.volume = 100.0
                player.prepareToPlay()
                player.play()
                self.beginSampleScrolling()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                 
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func pauseAudio() {
        print("pause audio")
        let url = (post?.recording_url)//last_recording)
        if let audioUrl = URL(string: url!) {
                    
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
     
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
            
            do {
                
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                guard let player = audioPlayer else { return }
                self.resetSamplesScrolling()
                player.pause()
                
                
//                player = nil
                meterTimer.invalidate()
                
                
//                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
//                guard let player = audioPlayer else { return }
//                try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//
//                player.volume = 100.0
//                player.prepareToPlay()
//                player.play()
                 
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ audioPlayer: AVAudioPlayer, successfully flag: Bool) {
        
        print("audioPlayerDidFinishPlaying")
        
        if flag {
            // After successfully finish song playing will stop audio player and remove from memory
            print("Audio player finished playing")
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            
            self.isPlaying = false
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
            let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
            self.playButton.setImage(image, for: .normal)
            
            // Write code to play next audio.
        }
    }
    
    
    
    var lastTime = Float(0.0)
    
    @objc func updateAudioMeter(timer: Timer) {
        if self.isPlaying {
            
            let maxRecordingLength = 60.0
//            shapeLayer.strokeEnd = 0
            
            let percentage = CGFloat(audioPlayer.currentTime.truncatingRemainder(dividingBy: TimeInterval(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60)))) / CGFloat(audioPlayer.duration.truncatingRemainder(dividingBy: 60))
            
//            DispatchQueue.main.async {
//            self.percentageLabel.text = "\(Int(percentage * 100))%"
//            self.shapeLayer.strokeEnd = percentage
//            }
            
//            print(percentage)
            
            
            
//            let hr = Int((audioPlayer.currentTime / 60) / 60)
//            let min = Int((CGFloat(maxRecordingLength) - audioPlayer.currentTime) / 60)
            let sec = Float(audioPlayer.currentTime)//.truncatingRemainder(dividingBy: 60))
            let duration = Float(audioPlayer.duration.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d", sec) //String(format: "%02d:%02d:%02d", hr, min, sec)
//            timeLabel.text = totalTimeString
            
//            self.percentageLabel.text = totalTimeString//"\(Int(percentage * 100))%"
            
             
            
            
            if sec == 0.0 {
                self.playPressed()
            } else {
//                print(totalTimeString, sec, duration, audioPlayer.currentTime, audioPlayer.duration)
                self.timeLabel.text = String(Int(sec))+"s"//.prefix(3)+"/"+String(duration).prefix(3)+"s"
            }
            
            
            audioPlayer.updateMeters()
            
        } else {
            pauseAudio()
        }
    }
    
    
    // delete friend
     
    
    func deleteFriend(post: Post) {
        // delete from both user's friends lists
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(uid).child("friends").child(post.uid).removeValue() {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data deleted from my friends successfully!")
            
            var newRef: DatabaseReference!
            newRef = Database.database().reference()
            newRef.child("users").child(post.uid).child("friends").child(uid).removeValue() {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data deleted in ex friend's friends successfully!")
                    
                    HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()).updatePostsCoreData()
                }
            }
          }
        }
    }
     
    
    
    
    
    
//    @objc func playResponse() {
//        print("play")
//        
//        
////        let path = getDirectory().appendingPathComponent("qwertyuiop123456789.m4a")
//        
//        
//        
//        let fileName = (randomString)+".m4a"
//        let fileRef = Storage.storage().reference().child("recordings").child(fileName)
//        let metadata = StorageMetadata()
//        metadata.contentType = "audio/m4a"
//        
//        do {
//            let audioData = try Data(contentsOf: getFileUrl())
//            
//            fileRef.putData(audioData, metadata: metadata){ (data, error) in
//                if error == nil {
//                    debugPrint("audio has saved")
//                    fileRef.downloadURL {url, error in
//                        guard let downloadURL = url else { return }
//                        debugPrint("downloadURL: ", downloadURL)
//                        
//                        let stringURL = downloadURL.absoluteString //+ downloadURL.path
//                        
//                        self.saveAudioURL(url: (stringURL))
//                        
//
//                    }
//                } else {
//                    print("beginUploadingFile: ", error)
//                }
//            }
//        } catch {
//            debugPrint(error.localizedDescription)
//        }
//        
//        
//        
//        
//        
//        if isPlaying {
//            do
//            {
////                audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
//                audioPlayer.pause()
//                self.isPlaying = false
//                let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
//                let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
//                playButton.setImage(image, for: .normal)
//            }
//            catch
//            {
//                
//            }
//        } else {
//            do
//            {
//                print("gets 1")
//                try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//                print("gets 2")
//                
//                
////                audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
//                audioPlayer.volume = 100.0
//                audioPlayer.prepareToPlay()
//                audioPlayer.play()
//                
//                print("gets 3")
//                self.isPlaying = true
//                let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
//                let image = UIImage(systemName: "pause.fill", withConfiguration: largeConfig)
//                playButton.setImage(image, for: .normal)
//            }
//            catch
//            {
//                
//            }
//        }
//        
//    }
    
    
    
    
    
    
    
    
}
