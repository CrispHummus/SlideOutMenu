//
//  SlideOutMenuViewController.swift
//  Slide out menu
//
//  Created by Tristan Brankovic on 8/5/18.
//  Copyright © 2018 parab3llum. All rights reserved.
//

import UIKit

class SlideOutMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var containerView = UIView()
    var menuTableView = UITableView()
    
    var menuOffset = CGFloat()
    var menuIsOpen = false
    var panRight = UIPanGestureRecognizer()

    let menuID = "Search"
    var currentRow = 0
    var menuSections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get container and table view with the tag of 999
        containerView = self.view.viewWithTag(999)!
        menuTableView = self.view.viewWithTag(998) as! UITableView
        
        //Avoid presenting floating headers
        let dummyViewHeight = CGFloat(45)
        self.menuTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.menuTableView.bounds.size.width, height: dummyViewHeight))
        self.menuTableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        
        //Add shadow to container view
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 3
        containerView.clipsToBounds = false

        //Get menu info
        parseJson()
        
        //Assign values
        menuOffset = menuTableView.frame.origin.x
        print(menuOffset)
        
        //Add gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenu))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        panRight = UIPanGestureRecognizer(target: self, action: #selector(moveMenu))
        self.view.addGestureRecognizer(panRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let lbl = UILabel()
        lbl.text = "\(menuSections[section].title.uppercased())"
        lbl.textColor = UIColor(white: 0.8, alpha: 1)
        lbl.font = lbl.font.withSize(13)
        lbl.frame = CGRect(x: 15, y: 0, width: menuTableView.frame.width - 15, height: 25)
        view.addSubview(lbl)
        
        if lbl.text != "" {
            view.backgroundColor = UIColor(white: 0.25, alpha: 1)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 25
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        
        cell.titleLbl.text = menuSections[indexPath.section].items[indexPath.row]
        cell.storyboardID = menuSections[indexPath.section].itemIDs[indexPath.row]
        
        if cell.titleLbl.text != menuSections[0].items[0] {
            cell.selectedView.isHidden = true
        }
        cell.selectionStyle = .none
        
        currentRow += 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        cell.selectedView.isHidden = false
        addCildView(viewID: cell.storyboardID)
        toggleMenu()
    }
    
    func addCildView(viewID: String) {
        //Assign child view to container view
        let controller = storyboard!.instantiateViewController(withIdentifier: viewID)
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        
        //Enable autolayout
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    @objc func toggleMenu() {
        if !menuIsOpen {
            //Open menu
            UIView.animate(withDuration: 0.2) {
                self.menuTableView.frame.origin.x = 0
                self.containerView.frame.origin.x = self.menuTableView.frame.width
            }
            menuIsOpen = true
            panRight.isEnabled = false
        } else {
            //Close menu
            UIView.animate(withDuration: 0.2) {
                self.menuTableView.frame.origin.x = self.menuOffset
                self.containerView.frame.origin.x = 0
            }
            menuIsOpen = false
            panRight.isEnabled = true
        }
    }
    
    @objc func moveMenu(_ gestureRecognizer: UIPanGestureRecognizer) {
        //Move views based on pan
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            if !menuIsOpen && menuTableView.frame.origin.x >= menuOffset && containerView.frame.origin.x < self.menuTableView.frame.width && containerView.frame.origin.x >= 0 {
                let translation = gestureRecognizer.translation(in: self.view)
                
                if (containerView.frame.origin.x >= 0 && translation.x > 0) && containerView.frame.origin.x + translation.x <= menuTableView.frame.width {
                    self.menuTableView.frame.origin.x += translation.x * CGFloat(abs(menuOffset) / self.menuTableView.frame.width)
                    self.containerView.frame.origin.x += translation.x
                } else if (containerView.frame.origin.x >= 0 && translation.x > 0) && containerView.frame.origin.x + translation.x > menuTableView.frame.width {
                    menuTableView.frame.origin.x = 0
                    containerView.frame.origin.x = self.containerView.frame.width
                }
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                
            } else if menuTableView.frame.origin.x < menuOffset || self.containerView.frame.origin.x < 0 {
                menuTableView.frame.origin.x = menuOffset
                print(menuTableView.frame.origin.x)
                self.containerView.frame.origin.x = 0
                
            } else if containerView.frame.origin.x > self.menuTableView.frame.width {
                menuTableView.frame.origin.x = 0
                containerView.frame.origin.x = self.containerView.frame.width
            }
        } else if gestureRecognizer.state == .ended {
            //Either close or open menu
            if containerView.frame.origin.x >= self.menuTableView.frame.width / 3 {
                //Open menu
                toggleMenu()
            } else {
                //Close menu
                UIView.animate(withDuration: 0.2) {
                    self.menuTableView.frame.origin.x = self.menuOffset
                    self.containerView.frame.origin.x = 0
                }
                menuIsOpen = false
                panRight.isEnabled = true
            }
        }
    }
    
    func parseJson() {
        //Read menu info
        do {
            if let file = Bundle.main.url(forResource: "Menus", withExtension: "json") {
                let data = try Data(contentsOf: file)
                if let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String: Any] {
                    //Add initial view
                    if menuSections.isEmpty {
                        let initialView = json["Home"] as! [String]
                        let key = initialView[0]
                        addCildView(viewID: initialView[1])
                        menuSections.append(Section(title: "", items: [key], itemIDs: [initialView[1]]))
                    }
                    
                    //Add menu items
                    let menuViews = (json[menuID] as! Dictionary<String, Any>)["views"] as! [[String]]
                    var items = [String]()
                    var itemIDs = [String]()
                    for vc in menuViews {
                        items.append(vc[0])
                        itemIDs.append(vc[1])
                    }
                    
                    menuSections.append(Section(title: menuID, items: items, itemIDs: itemIDs))
                }
            }
        } catch {
            print("Error with json file.")
        }
        //Update menu & initialize table view
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
}

struct Section {
    var title: String
    var items: [String]
    var itemIDs: [String]
}

extension UIButton {
    func toggleMenu(_ sender: UIButton) {
        sender.addTarget(SlideOutMenuViewController(), action: #selector(SlideOutMenuViewController.toggleMenu), for: .touchUpInside)
    }
}

