//
//  ViewController.swift
//  PeekABook
//
//  Created by Nayani Gaonkar on 07/10/22.
//

import UIKit
import RxCocoa
import RxSwift

let dispose = DisposeBag()

struct Product {
    let imageName: String
    let title: String
    let description: String
}

struct ProductViewModal{
    let items = PublishSubject<[Product]>()

    func fetchProductItems() {
        
        let products = [
            Product(imageName: "Img 1", title: "Blue", description: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."),
            Product(imageName: "Img 2", title: "Green", description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.")
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableConterView: UIView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    private let viewModal = ProductViewModal()
    
    private let tableView: UITableView = {
        
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: K.tableCell)
        
        return table
    }()
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
                                                            
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text!)
        
        tableConterView.addSubview(tableView)
        
        tableView.frame = view.bounds
                
        bindTableData()
                
    }
    
    func bindTableData() {
        viewModal.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, modal, cell in
            cell.textLabel?.text = modal.title
            cell.imageView?.image = UIImage(systemName: modal.imageName)

        }.disposed(by: dispose)

        tableView.rx.modelSelected(Product.self).bind { Product in
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailsViewSB") as! BookDetailsViewController
//
//            vc.bookNameText = Product.title
//            vc.authorNameText = Product.imageName
//            vc.bookDescription = Product.description
//
//            self.present(vc, animated: true)
            
        }.disposed(by: dispose)
    
        viewModal.fetchProductItems()
        
    }
}


