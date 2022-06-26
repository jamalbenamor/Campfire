//
//  ResponseCell.swift
//  Campfire
//
//  Created by Jamal Benamor on 19/06/2022.
//

import Foundation


import Foundation
import UIKit
import Firebase
import FirebaseStorage
import AVFAudio
import AVFoundation
import FDWaveformView


class ResponseCell: UICollectionViewCell {
    
    var homeViewController: HomeViewController?
//    var player = AVPlayer()
    var audioPlayer:AVAudioPlayer!
    var isPlaying = false
    var recordingSession:AVAudioSession!
    var meterTimer:Timer!
    var fileDuration: Int?
    var animator: UIViewPropertyAnimator!
    
    var response: Response? {
        didSet {
            
            print("timestamp: ", response?.timestamp)
            postedLabel.text = Date().timeAgoDisplay(timestamp: response!.timestamp)
            nameLabel.text = response?.name
            self.downloadAudio(url: response!.url)
            
            
        }
    }
    
    let cellView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .black//Varibles.foregroundBlack//.white
        iv.layer.borderWidth = 1
        iv.layer.borderColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
  
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15) //UIFont.boldSystemFont(ofSize: 15)
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
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = Varibles.foregroundBlack//UIColor.rgb(red: 235, green: 95, blue: 91)
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postedLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.textAlignment = .right
//        label.backgroundColor = .red
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    @objc func playPressed() {
        print("play pressed")
//        print(user)
//        HomeViewController().miniPlayerCancelPressed()
//        HomeViewController().showMiniPlayerForUser(user: user!)
        
//        let cachedAudio = audioCache.object(forKey: user!.todays_recording as AnyObject) as? NSURL
//        self.player = AVPlayer(url: cachedAudio!)
//        player.play()
//        playAudio()
//        loadAudio(uid: user!.uid)
        
        if isPlaying {
//            do
//            {
//                audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
//                audioPlayer.pause()
            pauseAudio()
            resetTimeLabel()
            
            self.isPlaying = false
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
            let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
            playButton.setImage(image, for: .normal)
//            }
//            catch
//            {
//
//            }
        } else {
//            do
//            {
//                try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//
//
//                audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
//                audioPlayer.volume = 100.0
//                audioPlayer.prepareToPlay()
//                audioPlayer.play()
                
            playAudio()
            
//                print("gets 3")
            self.isPlaying = true
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy, scale: .large)
            let image = UIImage(systemName: "pause.fill", withConfiguration: largeConfig)
            playButton.setImage(image, for: .normal)
                
//            }
//            catch
//            {
//
//            }
        }
        
        
    }
    
    func resetTimeLabel() {
        let duration = Int(audioPlayer.duration)//.truncatingRemainder(dividingBy: 60))
        let durationString = String(duration)//.prefix(3)
        self.timeLabel.text = durationString+"s"//String((durationString).prefix(3))+"s"
    }
    
  
    
    
    let playSpinner: SpinnerView = {
        let spinner = SpinnerView()
//        spinner.color = .white
//        spinner.backgroundColor = .red
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.animate()
//        spinner.layer.cornerRadius = 25
//        spinner.isHidden = true
        
        return spinner
        
    }()
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupPostUI()
        
        
        
        
    }
    
    var cellViewTopConstraintToTop: NSLayoutConstraint?
    var cellViewTopConstraintToProfileImage: NSLayoutConstraint?
    
    func setupPostUI() {
        
        addSubview(cellView)
        addSubview(nameLabel)
        addSubview(playButton)
        addSubview(playSpinner)
        addSubview(timeLabel)
        addSubview(postedLabel)
     
        cellView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        playButton.anchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        playButton.layer.cornerRadius = 50 / 2
        playButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        
        nameLabel.anchor(top: playButton.topAnchor, left: playButton.rightAnchor, bottom: cellView.centerYAnchor, right: nil, paddingTop: 2, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        playSpinner.anchor(top: playButton.topAnchor, left: playButton.leftAnchor, bottom: playButton.bottomAnchor, right: playButton.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        
        
        
        
        postedLabel.anchor(top: nil, left: nil, bottom: nil, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        postedLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        timeLabel.anchor(top: nil, left: playButton.rightAnchor, bottom: playButton.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 2, paddingRight: 0, width: 40, height: 20)
        timeLabel.layer.cornerRadius = 10
         
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadAudio(url: String) {
        print("downloadaudio")
        
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
//                        self.waveform.audioURL = destinationUrl
                        
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
        let url = (response?.url)
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
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                 
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func pauseAudio() {
        print("pause audio")
        let url = (response?.url)
        if let audioUrl = URL(string: url!) {
                    
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
     
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
            
            do {
                
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                guard let player = audioPlayer else { return }
                
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
    
    
    
    
    
    
    
    
    
}
