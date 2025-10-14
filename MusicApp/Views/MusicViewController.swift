//
//  MusicViewController.swift
//  MusicApp
//
//  Created by Nahid Askerli on 14.09.25.
//


import UIKit
import AVFoundation
import SnapKit

final class MusicViewController: UIViewController {

    private var trackList: [MusicTrackCell.Item] = []
    private var player: AVPlayer?
    private lazy var viewModel = MusicViewModel(service: URLSessionManager())

    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "🎵\n\nAxtarmağa başlayın.\nMəsələn: 'Eminem'"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "🎵 Music Search"
        view.backgroundColor = .systemBackground
        setupUI()
        viewModel.subscribe(self)

        if let lastSearch = viewModel.getLastSearch() {
            searchBar.text = lastSearch
            viewModel.searchMusic(with: lastSearch)
        } else {
            render(state: .idle)
        }
    }

    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)

        searchBar.delegate = self
        searchBar.placeholder = "Musiqi və ya artist axtar..."

        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 80
        tableView.register(MusicTrackCell.self, forCellReuseIdentifier: MusicTrackCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(40)
        }
    }
}


extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicTrackCell.identifier, for: indexPath) as? MusicTrackCell else {
            return UITableViewCell()
        }

        let track = trackList[indexPath.row]
        cell.configure(item: track)
        cell.onPlayButtonTapped = { [weak self] previewUrl in
            guard let url = URL(string: previewUrl) else { return }
            self?.player = AVPlayer(url: url)
            self?.player?.play()
        }
        return cell
    }
}

extension MusicViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.searchMusic(with: text)
        searchBar.resignFirstResponder()
    }
}

extension MusicViewController: MusicViewModelDelegate {
    func render(state: MusicViewModel.State) {
        DispatchQueue.main.async {
            switch state {
            case .idle:
                self.emptyStateLabel.isHidden = false
                self.loadingIndicator.stopAnimating()
                self.trackList = []
                self.tableView.reloadData()
            case .loading:
                self.emptyStateLabel.isHidden = true
                self.loadingIndicator.startAnimating()
            case .result(let tracks):
                self.loadingIndicator.stopAnimating()
                if tracks.isEmpty {
                    self.showErrorAlert(message: "Heç bir mahnı tapılmadı")
                } else {
                    self.trackList = tracks
                    self.emptyStateLabel.isHidden = !tracks.isEmpty
                    self.tableView.reloadData()
                }
            case .error(let error):
                self.loadingIndicator.stopAnimating()
                self.emptyStateLabel.isHidden = true
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Xəta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
