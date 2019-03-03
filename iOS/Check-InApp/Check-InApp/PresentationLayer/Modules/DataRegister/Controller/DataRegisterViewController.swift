//
//  DataRegisterViewController.swift
//  CheckInApp
//
//  Created by Тимур on 05/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

final class DataRegisterViewController: UIViewController {

    @IBOutlet private var editButton: UIButton!
    private var nameDateDataView: NameDateEditView!
    private var didViewsInstalled: Bool = false
    private let dataRegisterInteractor: IDataRegisterInteractor = DataRegisterInteractor()
    unowned var assembly: IPresentationAssembly

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardFadedOnTap()
        nameDateDataView = NameDateEditView()
        view.addSubview(nameDateDataView)
        addActionsForDataViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didViewsInstalled {
            setupViews()
            didViewsInstalled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    init(assembly: IPresentationAssembly) {
        self.assembly = assembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateUI() {
        dataRegisterInteractor.loadData(completion: reloadData)
    }

    private func setupViews() {
        setupDataViews()
        editButton.layer.cornerRadius = editButton.frame.width * 0.05
    }

    private func reloadData(with user: User?) {
        nameDateDataView.isEdit = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        nameDateDataView.nameLabel.text = user?.surname ?? "Ваша фамилия"
        nameDateDataView.dateLabel.text = user?.date ?? "Дата рождения"
    }

    private func setupDataViews() {
        let width = view.frame.width * 0.7
        let height = width * 5 / 4
        let size = CGSize(width: width, height: height)
        nameDateDataView.frame.size = size
        let y = view.frame.maxY - 2*height
        let x = view.frame.width * 0.05
        nameDateDataView.frame.origin = CGPoint(x: x, y: y)
        nameDateDataView.center = view.center
        nameDateDataView.isEdit = false
        nameDateDataView.leftButton.setImage(named: "forbidden-mark")
        nameDateDataView.rightButton.setImage(named: "tick-sign")
        setShadows(for: editButton)
        setShadows(for: nameDateDataView)
    }

    private func setShadows(for view: UIView) {
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shouldRasterize = true
    }

    private func addActionsForDataViews() {
        nameDateDataView.leftButton.addTarget(self, action: #selector(cancelTapped(sender:)), for: .touchUpInside)
        nameDateDataView.rightButton.addTarget(self, action: #selector(saveTapped(sender:)), for: .touchUpInside)
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        animatingToEdit()
    }

    @objc func cancelTapped(sender: UIButton) {
        animatingToDefault()
    }

    @objc func saveTapped(sender: UIButton) {
        animatingToDefault()
        guard let surname = nameDateDataView.nameLabel.text else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let date = dateFormatter.string(from: nameDateDataView.datePicker.date)
        dataRegisterInteractor.saveData(surname: surname, date: date)
    }

    private func animatingToEdit() {
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: {
            self.editButton.isHidden = true
            self.nameDateDataView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { (_) in
            self.nameDateDataView.isEdit = true
        })
    }

    private func animatingToDefault() {
        nameDateDataView.isEdit = false
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn, animations: {
            self.nameDateDataView.transform = .identity
        }, completion: { (_) in
            self.editButton.isHidden = false
    })
    }

}
