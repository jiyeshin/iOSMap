//
//  ViewController.swift
//  LocationData1122
//
//  Created by 503-12 on 22/11/2018.
//  Copyright © 2018 The. All rights reserved.
//

import UIKit

//위치정보 사용을 위한 프레임워크
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //위치 정보 사용을 위한 인스턴스를 생성
    var locationManager = CLLocationManager()
    
    //시작 위치를 저장할 변수
    var startLocation : CLLocation!
    
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    //var flag = true
    @IBAction func locationUpdate(_ sender: Any) {
        //버튼의 타이틀로 토글.
        //토글은 번갈아서 하는거.
        let btn = sender as! UIButton
        if btn.title(for:.normal) == "위치 정보 수집 시작"{
            //위치 정보 수집 시작
            locationManager.startUpdatingLocation()
            btn.setTitle("위치 정보 수집 중지", for: .normal)
        }else{
            //위치 정보 수집 중지
            locationManager.stopUpdatingLocation()
            btn.setTitle("위치 정보 수집 시작", for: .normal)
        }
        /*
        //버튼의 타이틀로 토글하는것 말고 버튼에 이미지를 넣으려면 flag를 사용하면 된다.
        if flag == ture{
            flag = false
        }else{
            flag = true
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 정밀도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //delegate 설정
        locationManager.delegate = self
        
        //위치정보 사용 동의 대화상자 출력 - 실행 중에만 사용
        locationManager.requestWhenInUseAuthorization()
    }
    
    //Mark: 위치 정보 갱신과 관련된 메소드
    
    //위치정보를 가져오는데 성공했을 때 호출되는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //배열에서 위치정보 객체 1개 가져오기
        let lastLocation = locations[locations.count-1]
        
        //위도 경도 고도 출력
        lblLatitude.text = "\(lastLocation.coordinate.latitude)"
        lblLongitude.text = "\(lastLocation.coordinate.longitude)"
        lblAltitude.text = "\(lastLocation.altitude)"
        
        //시작위치 설정
        if startLocation == nil {
            startLocation = lastLocation
        }
        
        //거리계산
        let distance = lastLocation.distance(from: startLocation)
        lblDistance.text = "\(distance)"
    }


}

