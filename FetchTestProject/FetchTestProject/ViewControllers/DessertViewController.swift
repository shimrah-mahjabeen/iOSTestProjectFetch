//
//  ViewController.swift
//  FetchTestProject
//
//  Created by Dev on 22/02/2024.
//

import UIKit

class DessertViewController: UIViewController {
    
    @IBOutlet weak var dessertCollectionView: UICollectionView!
    
    var dessertViewModel = DessertViewModel()
    
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator()
        NetworkManager.shared.fetchData(from: Constants.BASEURL.baseUrl, endpoint: Constants.ENDPOINTS.fetchDessert, responseType: Meal.self) { result in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            switch result {
            case.success(let data):
                self.dessertViewModel.dessertData = data
                self.dessertViewModel.dessertData.meals = self.dessertViewModel.dessertData.meals.sorted(by: { $0.dessertName < $1.dessertName })

                DispatchQueue.main.async {
                    self.dessertCollectionView.reloadData()
                }
            case.failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
}

extension DessertViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dessertViewModel.dessertData.meals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return self.dessertViewModel.getCollectionViewCell(withCollectionView: dessertCollectionView, withIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "DessertDetails", bundle: Bundle.main).instantiateViewController(withIdentifier: "dessertDetails") as? DessertDetailsViewController
        vc?.id = dessertViewModel.dessertData.meals[indexPath.row].dessertID
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
