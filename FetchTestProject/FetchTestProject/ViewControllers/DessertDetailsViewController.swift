//
//  DessertDetailsViewController.swift
//  FetchTestProject
//
//  Created by Dev on 22/02/2024.
//

import UIKit

class DessertDetailsViewController: UIViewController {
    
    @IBOutlet weak var dessertDetailsTableView: UITableView!
    @IBOutlet weak var dessertName: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipe: UILabel!
    @IBOutlet weak var dessertInstructions: UITextView!
    @IBOutlet weak var dessertDetailsTableHeight: NSLayoutConstraint!
    private var contentSizeObservation: NSKeyValueObservation?
    
    
    var activityView: UIActivityIndicatorView?
    
    var id: String = ""
    
    var dessertDetails = DessertDetails(meals: [])
    
    var ingredients: [String] = []
    var measures: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dessertDetailsTableView.allowsSelection = false
        
        showActivityIndicator()
        NetworkManager.shared.fetchData(from: Constants.BASEURL.baseUrl, endpoint: Constants.ENDPOINTS.fetchDessertDetails + id, responseType: DessertDetails.self) { result in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            switch result {
            case.success(let data):
                self.dessertDetails = data
                let meals = self.dessertDetails.meals.first
                let sortedKeys = meals?.keys.sorted()
                
                guard let sortedKeys = sortedKeys else {
                    return
                }
                
                for key in sortedKeys {
                    if key.hasPrefix("strIngredient") {
                        //making sure vlaue is not empty or null
                        guard let value = meals?[key], value?.trimmingCharacters(in: .whitespacesAndNewlines) != "" ,value != nil else {continue}
                        self.ingredients.append(value ?? "")
                    }
                    if key.hasPrefix("strMeasure") {
                        //making sure vlaue is not empty or null
                        guard let value = meals?[key], value?.trimmingCharacters(in: .whitespacesAndNewlines) != "", value != nil else {continue}
                        self.measures.append(value ?? "")
                    }
                }
                
                DispatchQueue.main.async {
                    self.dessertDetailsTableView.reloadData()
                    self.dessertName.text = meals?["strMeal"] ?? ""
                    self.ingredientsLabel.text = "Ingredients"
                    self.dessertInstructions.text = meals?["strInstructions"] ?? ""
                    self.recipe.text = "Recipe"
                }
            case.failure(let error):
                print("Error fetching data: \(error)")
            }
        }
        
        contentSizeObservation = self.dessertDetailsTableView.observe(\.contentSize, options: .new, changeHandler: { [weak self] (tv, _) in
            guard let self = self else { return }
            self.dessertDetailsTableHeight.constant = self.dessertDetailsTableView.contentSize.height
        })
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

extension DessertDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dessertDetailsTableView.dequeueReusableCell(withIdentifier: Constants.CELLREUSEIDENTIFIERS.tableViewCell) as! DessertDetailTableViewCell
        cell.ingredientName.text = ingredients[indexPath.row]
        cell.measure.text = measures[indexPath.row]
        
        return cell
    }
}
