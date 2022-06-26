//
//  RecordViewController.swift
//  Campfire
//
//  Created by Jamal Benamor on 08/06/2022.
//



import UIKit
import Firebase
import Foundation
import AVFAudio
import SwiftUI
import FirebaseStorage


class RecordViewController: UIViewController, AVAudioRecorderDelegate, URLSessionDelegate {

    var maxRecordingLength:Int = 60
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var meterTimer:Timer!
    var playerTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording: Bool!
    var isPlaying:Bool = false
    var randomString = UUID().uuidString.lowercased()
    var isReadyToUpload:Bool = false
    var isUploading:Bool = false
    
    let campfireTitle: UILabel = {
        let label = UILabel()
        label.text = "Campfire"
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy, scale: .large)
        let image = UIImage(systemName: "arrow.left", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        
        button.backgroundColor = .black
        button.tintColor = .white
        
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        let vc = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.modalPresentationStyle = .fullScreen
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    let questionLabel: UITextView = {
        let label = UITextView()
        label.text = Profile.profile.todays_question//"What do you fear most?"
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        label.isScrollEnabled = false
        return label
    }()
    
    
    let rerecordButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy, scale: .large)
        let image = UIImage(systemName: "arrow.counterclockwise", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(rerecordResponse), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    
    let uploadButton: UIButton = {
        let button = UIButton()
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
//        let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
//        button.setImage(image, for: .normal)
        button.setTitle("SEND➤", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(upload), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
     
    
    @objc func updateAudioPlayerMeter(timer: Timer) {
        if audioPlayer.isPlaying {
            let percentage = CGFloat(audioPlayer.currentTime.truncatingRemainder(dividingBy: TimeInterval(audioPlayer.duration))) / CGFloat(audioPlayer.duration)
            
            self.shapeLayer.strokeEnd = percentage
            
            print(percentage)
            
        } else {
            self.playResponse()
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
            shapeLayer.strokeEnd = 0
            let percentage = CGFloat(audioRecorder.currentTime.truncatingRemainder(dividingBy: TimeInterval(maxRecordingLength))) / CGFloat(maxRecordingLength)
            self.shapeLayer.strokeEnd = percentage
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int((CGFloat(maxRecordingLength) - audioRecorder.currentTime) / 60)
            let sec = Int(60-(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60)))
            
            let totalTimeString = String(format: "%02d", sec) //String(format: "%02d:%02d:%02d", hr, min, sec)
            self.percentageLabel.text = totalTimeString//"\(Int(percentage * 100))%"
            audioRecorder.updateMeters()
            
            print(Int(audioRecorder.currentTime), " : ", maxRecordingLength)
            if Int(audioRecorder.currentTime) >= maxRecordingLength {
                print("123 finish recording")
                finishAudioRecording(success: true)
            }
            
        } else {
            finishAudioRecording(success: true)
        }
    }
    
     // setup animations
    
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var pulsatingLayer2: CAShapeLayer!
    var pulsatingLayer3: CAShapeLayer!
    var pulsatingLayer4: CAShapeLayer!
    var pulsatingLayer5: CAShapeLayer!
    var pulsatingLayer6: CAShapeLayer!
    var pulsatingLayer7: CAShapeLayer!
    var pulsatingLayer8: CAShapeLayer!
    var pulsatingLayer9: CAShapeLayer!
    var pulsatingLayer10: CAShapeLayer!
    var pulsatingLayer11: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    
    
    let recordButton: UIButton = {
        let label = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large)
        let image = UIImage(systemName: "mic.fill", withConfiguration: largeConfig)
        label.setImage(image, for: .normal)
        label.tintColor = .white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    
    
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    
    private func setupPercentageLabel() {
        view.addSubview(percentageLabel)
//        percentageLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        percentageLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        percentageLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        percentageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        percentageLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    //.bottomAnchor = view.bottomAnchor
        
        view.addSubview(recordButton)
        recordButton.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        recordButton.center = view.center
        
    }
    
    private func setupCircleLayers() {
        animatePulsatingLayer()
    }
    
    
    private func animatePulsatingLayer() {
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        
        
        
        print("pulsate")
         
//        animatePulsatingLayer2()
        let animation = CABasicAnimation(keyPath: "transform.scale")


        animation.toValue = 2.0//1.5
        animation.duration = 4.0//0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = false

        animation.repeatCount = Float.infinity

        
        
        
        
        pulsatingLayer2 = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer2)

        pulsatingLayer3 = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer3)
        
        pulsatingLayer4 = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer4)
        
//        pulsatingLayer5 = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
//        view.layer.addSublayer(pulsatingLayer5)
//
//        pulsatingLayer6 = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
//        view.layer.addSublayer(pulsatingLayer6)
//
//        pulsatingLayer7 = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
//        view.layer.addSublayer(pulsatingLayer7)


        let trackLayer = createCircleShapeLayer(strokeColor: Varibles.trackStrokeColor, fillColor: Varibles.backgroundColor)
        view.layer.addSublayer(trackLayer)

        shapeLayer = createCircleShapeLayer(strokeColor: Varibles.outlineStrokeColor, fillColor: .clear)

        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        setupPercentageLabel()
        startAnimation()
        
//        pulsatingLayer.add(animation, forKey: "pulsing") //   scale
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.pulsatingLayer2.add(animation, forKey: "pulsing")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                self.pulsatingLayer3.add(animation, forKey: "pulsing")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                    self.pulsatingLayer4.add(animation, forKey: "pulsing")
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
////                        self.pulsatingLayer5.add(animation, forKey: "pulsing")
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
////                            self.pulsatingLayer6.add(animation, forKey: "pulsing")
////                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
////                                self.pulsatingLayer7.add(animation, forKey: "pulsing")
////                            })
////                        })
////                    })
//                })
//            })
//        })
        
    }
    
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 2.0//1.5
        animation.duration = 4.0//0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = false
        animation.repeatCount = Float.infinity
        self.pulsatingLayer.isHidden = false
        pulsatingLayer.add(animation, forKey: "pulsing") //   scale
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.pulsatingLayer2.add(animation, forKey: "pulsing")
            self.pulsatingLayer2.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.pulsatingLayer3.isHidden = false
                self.pulsatingLayer3.add(animation, forKey: "pulsing")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.pulsatingLayer4.isHidden = false
                    self.pulsatingLayer4.add(animation, forKey: "pulsing")
                })
            })
        })
        
    }
    
    
    func stopAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 2.0
        animation.toValue = 1.0//1.5
        animation.duration = 1.0//0.8
        animation.repeatCount = 0.0
        
        self.pulsatingLayer4.isHidden = true//.add(animation, forKey: "pulsing") //   scale
        self.pulsatingLayer3.isHidden = true
        self.pulsatingLayer2.isHidden = true
        self.pulsatingLayer.add(animation, forKey: "pulsing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.pulsatingLayer.isHidden = true

        })
    }
    
    
    
    // old pulses
    var pulseArray = [CAShapeLayer]()
    
    func createPulse() {
        
        
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * .pi , clockwise: true)
            let pulsatingLayer = CAShapeLayer()
            pulsatingLayer.path = circularPath.cgPath
            pulsatingLayer.lineWidth = 2.5
            pulsatingLayer.fillColor = UIColor.red.cgColor
            pulsatingLayer.lineCap = CAShapeLayerLineCap.round
            pulsatingLayer.position = CGPoint(x: 100, y: 100)
            percentageLabel.layer.addSublayer(pulsatingLayer)
            pulseArray.append(pulsatingLayer)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.animatePulsatingLayerAt(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.animatePulsatingLayerAt(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.animatePulsatingLayerAt(index: 2)
                    
//                    self.animatePulsatingLayer()
//                    self.setupPercentageLabel()
                    
                })
            })
        })
        
    }
    
    func animatePulsatingLayerAt(index:Int) {
            
        //Giving color to the layer
        pulseArray[index].strokeColor = UIColor.blue.cgColor
        
        //Creating scale animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 2.0
        
        //Creating opacity animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 2.0
       
      // Grouping both animations and giving animation duration, animation repat count
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 2.3
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        //adding groupanimation to the layer
        pulseArray[index].add(groupAnimation, forKey: "groupanimation")
        
        if index == 2 {
            self.animatePulsatingLayer()
            self.setupPercentageLabel()
            
        }
    }
    
    private func animatePulsatingLayerFast() {
//        pulsatingLayer2 = createCircleShapeLayer(strokeColor: .clear, fillColor: Varibles.pulsatingFillColor)
//        view.layer.addSublayer(pulsatingLayer2)
        
        print("speed pulsate")
//        animatePulsatingLayer2()
        let animation = CABasicAnimation(keyPath: "transform.scale")


        animation.toValue = 2.0//1.5
        animation.duration = 2.0//0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = false

        animation.repeatCount = Float.infinity

        pulsatingLayer2.add(animation, forKey: "pulsing") //   scale
        
        
        
        
    }
    
    func animatePulsatingLayer2() {
        //Giving color to the layer
//        pulsatingLayer[index].strokeColor = UIColor.darkGray.cgColor
        
        //Creating scale animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        
        //Creating opacity animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
       
       //Grouping both animations and giving animation duration, animation repat count
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 2.3
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        //adding groupanimation to the layer
        pulsatingLayer.add(groupAnimation, forKey: "groupanimation")
    }
    
   
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @objc private func handleTap() {
        print("Attempting to animate stroke")
        recordResponse()
        
//        beginDownloadingFile()
//        animateCircle()
    }
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload login")
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = .blue
        view.backgroundColor = .black
        
        view.addSubview(campfireTitle)
        campfireTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        campfireTitle.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        campfireTitle.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        campfireTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(rerecordButton)
        rerecordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        rerecordButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        rerecordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rerecordButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(questionLabel)
        questionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        questionLabel.topAnchor.constraint(equalTo: campfireTitle.bottomAnchor, constant: 4).isActive = true
//        questionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(uploadButton)
        uploadButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44).isActive = true
        uploadButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -44).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        recordingSession = AVAudioSession.sharedInstance()
        checkPermissions()
        self.navigationItem.setHidesBackButton(true, animated:true)
        setupNotificationObservers()
        setupCircleLayers()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//        setupPercentageLabel()
        
    }
    
    // called every time the view disappears
    override func viewDidDisappear(_ animated: Bool) {
        self.randomString = UUID().uuidString.lowercased()
    }
    
    // called every time the view appears
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    func checkPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("ACCEPTED")
                self.isAudioRecordingGranted = true
            } else {
                print("show warning to allow audio")
                self.display_alert(msg_title: "Error", msg_desc: "We don't have access to use your microphone.", action_title: "OK")
                self.isAudioRecordingGranted = false
            }
        }
    }
    
    func setup_recorder() {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }

    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func getFileUrl() -> URL {
        let filename = (randomString)+".m4a"
        let filePath = getDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String) {
        
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
        _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    @objc func recordResponse() {
        print("pulse button pressed")
        
        if isUploading {
            //do nothing as uploading
        } else if isReadyToUpload {
            // play recoding
            playResponse()
        } else {
            // is recording
            if audioRecorder == nil {
                // start recording
                setup_recorder()
                audioRecorder.record()
                
                rerecordButton.isEnabled = false
                rerecordButton.isHidden = true
                
                uploadButton.isEnabled = false
                uploadButton.isHidden = true
                
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large)
                let image = UIImage(systemName: "square.fill", withConfiguration: largeConfig)
                recordButton.setImage(image, for: .normal)
                
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
             
                isRecording = true
            }   else  {
                // finish recording
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large)
                let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
                recordButton.setImage(image, for: .normal)
                finishAudioRecording(success: true)
            }
        }
    }
    
     
    
    func finishAudioRecording(success: Bool)  {
        if success {
            shapeLayer.strokeEnd = 0
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            stopAnimation()
//            percentageLabel.text = "UPLOAD"
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large)
            let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
            recordButton.setImage(image, for: .normal)
            
            isReadyToUpload = true
            uploadButton.isEnabled = true
            uploadButton.isHidden = false
            rerecordButton.isEnabled = true
            rerecordButton.isHidden = false
            isRecording = false
            do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.prepareToPlay()
            } catch { }
            print("recorded successfully.")
            
        } else {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    
    
    @objc func rerecordResponse() {
        
        if self.isPlaying {
            print("pause player")
            self.playResponse()
        }
        
        
        audioRecorder = nil
        meterTimer.invalidate()
        shapeLayer.strokeEnd = 0
//        updateAudioMeter(timer: meterTimer)
        
        rerecordButton.isEnabled = false
        rerecordButton.isHidden = true
        
        uploadButton.isEnabled = false
        uploadButton.isHidden = true
        
//        playButton.isEnabled = false
//        playButton.isHidden = true
        
//        percentageLabel.text = "GO"
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large)
        let image = UIImage(systemName: "mic.fill", withConfiguration: largeConfig)
        recordButton.setImage(image, for: .normal)
        
        isReadyToUpload = false
    }
    
    
    
    @objc func playResponse() {
        
        if isUploading {
            // do nothing as uploading
        } else if isPlaying {
            do {
                print("pause")
                audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
                audioPlayer.pause()
                self.isPlaying = false
                playerTimer.invalidate()
                self.shapeLayer.strokeEnd = 0
                
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large)
                let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
                recordButton.setImage(image, for: .normal)
                stopAnimation()
            }
            catch { }
        } else {
            do {
                print("play")
//                try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                try AVAudioSession.sharedInstance().setCategory(.playback)
                audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
//                audioPlayer.volume = 100.0
//                audioPlayer.prepareToPlay()
                audioPlayer.play()
                self.isPlaying = true
                playerTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioPlayerMeter(timer:)), userInfo:nil, repeats:true)
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .large)
                let image = UIImage(systemName: "pause.fill", withConfiguration: largeConfig)
                recordButton.setImage(image, for: .normal)
                startAnimation()
            } catch {}
        }
    }
    
    
    
    // upload
    
    @objc func upload() {
        if isUploading {
            //do nothing
            print("is uploading - do nothing")
        } else if isReadyToUpload {
            
            beginUploadingFile()
        } else {
            // no nothing
        }
    }
    
    
    @objc func beginUploadingFile() {
        print("Attempting to upload file")
        uploadButton.isEnabled = false
        rerecordButton.isEnabled = false
        rerecordButton.isHidden = true
//        uploadButton.isHidden = true
//        percentageLabel.text = "UPLOADING..."
        isUploading = true
        shapeLayer.strokeEnd = 0
        
        let fileName = (randomString)+".m4a"
        let fileRef = Storage.storage().reference().child("recordings").child(fileName)
        let metadata = StorageMetadata()
        metadata.contentType = "audio/m4a"
        
        do {
            let audioData = try Data(contentsOf: getFileUrl())
            
            let uploadTask = fileRef.putData(audioData, metadata: metadata){ (data, error) in
                if error == nil {
                    debugPrint("audio has saved")
                    
                } else {
                    print("beginUploadingFile: ", error)
                    
                }
            }
            
            uploadTask.observe(.progress, handler: { (snapshot) in
                print("uploadTask progress ", snapshot.progress?.fractionCompleted)
                self.shapeLayer.strokeEnd = CGFloat(snapshot.progress!.fractionCompleted/2)
            })
            
            uploadTask.observe(.success, handler: { (snapshot) in
                
                print("uploadTask success", snapshot)
                self.shapeLayer.strokeEnd = CGFloat(0.5)
                
                fileRef.downloadURL {url, error in
                    guard let downloadURL = url else { return }
                    debugPrint("downloadURL: ", downloadURL)
                    
                    let stringURL = downloadURL.absoluteString //+ downloadURL.path
                    self.shapeLayer.strokeEnd = CGFloat(0.66)
                    self.saveAudioURL(url: (stringURL))
                    
                }
            })
            
            uploadTask.observe(.failure, handler: { (snapshot) in
                print("uploadTask failure", snapshot)
                self.shapeLayer.strokeEnd = CGFloat(0)
                self.uploadButton.isEnabled = true
                self.isUploading = false
            })
            
            
        } catch {
            debugPrint(error.localizedDescription)
            uploadButton.isEnabled = true
            self.isUploading = false
        }
    }
    
    
    func saveAudioURL(url: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let date = Date().dateMonthToday()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(uid).updateChildValues(["last_recording": url, "last_posted": date]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
              print("Data could not be saved: \(error).")
              self.uploadButton.isEnabled = true
              self.isUploading = false
          } else {
              print("Data saved successfully!")
              self.shapeLayer.strokeEnd = CGFloat(0.83)
              let ref2 = Database.database().reference()
              ref2.child("users").child(uid).child("memories").updateChildValues([date: url]) {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved in my friends successfully!")
                    self.shapeLayer.strokeEnd = CGFloat(1.0)
      //              self.percentageLabel.text = "UPLOADED"
                    self.isUploading = false
                    Profile.profile.posted_today = true
                    
                    self.handleDismiss()
                }
              }
              
              
              
          }
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
