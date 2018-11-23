//
//  RouteViewController.swift
//  MapViewUse1122
//
//  Created by 503-12 on 23/11/2018.
//  Copyright © 2018 The. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //위치 정보를 사용하기 위한 인스턴스
    var locationManager = CLLocationManager()
    
    //위치 정보를 저장하기 위한 변수
    var userLocation:CLLocation?
    
    var destination:MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //정밀도 설정 - 높이면 배터리 소모량이 많아짐
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //delegate 설정
        locationManager.delegate = self
       
        //위치정보 사용여부 확인
        locationManager.requestLocation()
        
    }
}

extension RouteViewController : MKMapViewDelegate, CLLocationManagerDelegate{
    //지도에 경로를 출력해주는 사용자정의 메소드
    func showRoute(_ response : MKDirections.Response){
        //지도 위에 경로 출력
        for route in response.routes{
            //지도에 오버레이 출력
            mapView.addOverlay(route.polyline, level:MKOverlayLevel.aboveRoads)
            //경로를 콘솔에 출력
            for step in route.steps{
                print(step.instructions)
            }
        }
        //지도에 사용자의 위치에 따라 이동하도록 만들기
        if let coordinate = userLocation?.coordinate{
            let region = MKCoordinateRegion(center:coordinate, latitudinalMeters:2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //2개의 위치정보로 경로를 찾아오는 사용자 정의 메소드
    func getDirections(){
        //경로를 찾아주는 객체 만들기
        let request = MKDirections.Request()
        //위치 설정
        request.source = MKMapItem.forCurrentLocation()
        if let destination = destination{
            request.destination = destination
        }
        
        //옵션 설정 - 반대 경로는 찾지 않기
        request.requestsAlternateRoutes = false
        
        //옵션을 가지고 길찾기를 수행해 줄 객체를 생성
        let directions = MKDirections(request: request)
        
        //길찾기 시작
        directions.calculate(completionHandler: {(response, error) in
            //길찾기가 완료되면 지도에 출력하는 메소드 호출
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let response = response{
                    self.showRoute(response)
                }
            }
        })
    }
    
    //위치 정보를 가져오는데 성공했을 시 호출되는 메소드: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //가장 마지막 위치를 저장
        userLocation = locations[locations.count-1]
        //길찾기 메소드 호출
        getDirections()
    }
    //위치정보를 가져오는데 실패했을 때 호출되는 메소드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    //맵 뷰에 오버레이를 할 때 호출되는 메소드
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
}

