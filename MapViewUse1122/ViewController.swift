//
//  ViewController.swift
//  MapViewUse1122
//
//  Created by 503-12 on 22/11/2018.
//  Copyright © 2018 The. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    var locationManager : CLLocationManager!

    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    //검색 결과를 저장할 배열
    var matchingItems : [MKMapItem] = [MKMapItem]()

    func performsSearch(){
        //기존 검색 내용 삭제
        matchingItems.removeAll()
        
        //검색 객체 만들기
        let request = MKLocalSearch.Request()
        
        //검색어와 검색 영역 설정
        request.naturalLanguageQuery = tf.text
        request.region = mapView.region
        
        //검색 요청 객체 생성
        let search = MKLocalSearch(request: request)
        
        //검색 요청과 핸들러
        search.start(completionHandler:{(response:MKLocalSearch.Response!, error:Error!) in
            if error != nil{
                print("검색 중 에러")
            }else if response?.mapItems.count == 0{
                print("검색된 결과가 없습니다.")
            }else{
                print("검색 성공")
                //전체 데이터를 순회하면서
                for item in response.mapItems as [MKMapItem]{
                    //데이터를 한 개씩 배열에 저장
                    self.matchingItems.append(item as MKMapItem)
                    //각각을 맵에 출력
                    let annotation = MKPointAnnotation()
                    //어노테이션 정보 생성
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    //Mark: 검색 텍스트필드
    @IBAction func search(_ sender: Any) {
        //키보드를 제거
        let textField = sender as! UITextField
        textField.resignFirstResponder()
        //맵 뷰의 어노테이션 제거
        mapView.removeAnnotations(mapView.annotations)
        //검색 메소드 호출
        performsSearch()
    }
    
    //Mark: Tool Bar Menu
    @IBAction func zoom(_ sender: Any) {
        //맵 뷰에서 현재 사용자의 위치 가져오기
        let userLocation = mapView.userLocation
        
        //출력 영역 만들기
        let region = MKCoordinateRegion(center:userLocation.coordinate, latitudinalMeters:2000, longitudinalMeters:2000)
        
        //맵 뷰에 설정
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func type(_ sender: Any) {
        if mapView.mapType == .satellite{
            mapView.mapType = .standard
        }else{
            mapView.mapType = .satellite
        }
    }
    
    @IBAction func moveDetail(_ sender: Any) {
        let detailTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
        detailTableViewController.mapItems = self.matchingItems
        self.title = "MainView"
        //self.present(detailTableViewController, animated: true)
        self.navigationController?.pushViewController(detailTableViewController, animated: true)
    }
    //Mark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //위치정보 사용 객체 생성
        locationManager = CLLocationManager()
        //위치정보 사용 권한을 묻는 대화상자 출력
        locationManager?.requestWhenInUseAuthorization()
        //맵 뷰에 현재 위치를 출력
        mapView.showsUserLocation = true
        
        mapView.delegate = self
    }
}

extension ViewController:MKMapViewDelegate{
    //사용자의 위치가 변경된 경우 호출되는 메소드 
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
}

