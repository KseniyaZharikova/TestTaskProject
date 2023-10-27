//
//  ViewController.swift
//  Test
//
//  Created by Kseniya Zharikova on 25/10/23.
//

import UIKit

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pages: [Page] = []
    let pageSize = 20
    var loading = false
    var currentPage = 0
    var previousPage = 0
    var nextPage = 0
    var currentSection = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messages"
        view.backgroundColor = .systemGray6
        configureItems()
        loadNext(pageNumber: currentPage)
        configureChatListView()
    }
    
    private func configureItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Jump to",
            style: .plain,
            target: self,
            action: #selector(jump)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Page \(currentPage)",
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    private func configureChatListView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(
            UINib(nibName: "MessageCell", bundle: nil),
            forCellWithReuseIdentifier: "MessageCell"
        )
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(
            width: collectionView.bounds.width,
            height: 44
        )
        collectionView.collectionViewLayout = layout
    }
    
    @objc private func jump() {
        let page = 1000 / pageSize
        jumpToPage(pageNumber: page)
    }
    
    private func jumpToPage(pageNumber: Int) {
        guard !loading else {
            return
        }
        loading = true
        
        previousPage = pageNumber - 1
        currentPage = pageNumber
        nextPage = pageNumber + 1
        
        let previousPageData = mock()
        let pageData = mock()
        let nextPageData = mock()
        
        let previous = Page(pageNumber: previousPage, items: previousPageData)
        let page = Page(pageNumber: currentPage, items: pageData)
        let next = Page(pageNumber: nextPage, items: nextPageData)
        
        pages.removeAll()
        pages.append(contentsOf: [previous, page, next])
        collectionView.reloadData()
        
        if let currentSectionFrame = collectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: currentSection))?.frame {
            let currentSectionOffset = currentSectionFrame.origin.y
            collectionView.setContentOffset(CGPoint(x: 0, y: currentSectionOffset), animated: false)
        }
        
        let indexPath = IndexPath(item: 0, section: 1)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        
        self.loading = false
    }
    
    func loadPrevious(pageNumber: Int) {
        guard !loading else {
            return
        }
        loading = true
        previousPage = pageNumber - 1
        currentPage = pageNumber
        
        let previousPageData = mock()
        let pageData = mock()
        
        let previous = Page(pageNumber: previousPage, items: previousPageData)
        let page = Page(pageNumber: pageNumber, items: pageData)
        
        pages.removeAll { $0.pageNumber == pageNumber }
        pages.insert(contentsOf: [page, previous], at: 0)
        collectionView.reloadData()
    
        if let currentSectionFrame = collectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: currentSection))?.frame {
            let currentSectionOffset = currentSectionFrame.origin.y
            collectionView.setContentOffset(CGPoint(x: 0, y: currentSectionOffset), animated: false)
        }
       
        self.loading = false
    }
    
    func loadNext(pageNumber: Int) {
        guard !loading else {
            return
        }
        loading = true
        currentPage = pageNumber
        nextPage = pageNumber + 1
        
     //   print("page:  currentPage \(currentPage)")
        
        let pageData = mock()
        let nextPageData = mock()
        let page = Page(pageNumber: pageNumber, items: pageData)
        let next = Page(pageNumber: nextPage, items: nextPageData)
        
        pages.removeAll { $0.pageNumber == pageNumber }
        pages.append(contentsOf: [page, next])
        
        collectionView.reloadData()
        self.loading = false
    }
}

extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        let item = pages[indexPath.section].items[indexPath.row]
        let pageNumber = pages[indexPath.section].pageNumber
        let messageNumber = (pageNumber * pageSize) + indexPath.item
        
        cell.fill(message: item.text, messageNumber: messageNumber)
        
        if let leftBarButtonItem = navigationItem.leftBarButtonItem {
            leftBarButtonItem.title = "Page \(pages[indexPath.section].pageNumber)"
            currentPage = pages[indexPath.section].pageNumber
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("page:  currentPage \(currentPage)")
        if scrollView.contentOffset.y < 0 && !loading  && currentPage != 0 {
            currentPage -= 1
            loadPrevious(pageNumber: currentPage)
        } else if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) && !loading {
            currentPage += 1
            loadNext(pageNumber: currentPage)
        }
    }
}

extension MessagesViewController {
    //VM
    func mock() -> [MessageModel] {
        return [
            MessageModel(text: "The fall of the Western Roman Empire, also called the fall of the Roman Empire or the fall of Rome, was the loss of central political control in the Western Roman Empire, a process in which the Empire failed to enforce its rule, and its vast territory was divided into several successor polities."),
            MessageModel(text: "The reasons for the collapse are major subjects of the historiography of the ancient world and they inform much modern discourse on state failure."),
            MessageModel(text: "By 476, the position of Western Roman Emperor wielded negligible military, political, or financial power, and had no effective control over the scattered Western domains that could still be described as Roman."),
            MessageModel(text: "From at least the time of Henri Pirenne (1862–1935), scholars have described a continuity of Roman culture and political legitimacy long after 476."),
            MessageModel(text: "Economic growth and poor health"),
            MessageModel(text: "In 166, during the epidemic, the Greek physician and writer Galen traveled from Rome to his home in Asia Minor and returned to Rome in 168, when he was summoned by the two Augusti, the co-emperors Marcus Aurelius and Lucius Verus. "),
            MessageModel(text: "Historians differ in their assessment of the impact of the Antonine Plague on Rome. To some, the plague was the beginning of the decline of the Roman Empire. To others, it was a minor event, documented by Galen and other writers but only slightly more deadly than other epidemics which frequently ravaged parts of the empire."),
            MessageModel(text: "Only two of emperor Marcus Aurelius' fourteen children are known to have reached adulthood."),
            MessageModel(text: "The ancient chroniclers portray the plague as a disaster for the Roman army with the army reduced almost to extinction."),
            MessageModel(text: "A good indicator of nutrition and the disease burden is the average height of the population"),
            MessageModel(text: "Although Ge Hong was the first writer of traditional Chinese medicine who accurately described the symptoms of smallpox, the historian Rafe de Crespigny mused that the plagues afflicting the Eastern Han Empire during the reigns of Emperor Huan of Han "),
            MessageModel(text: "Lucius Aurelius Verus (15 December 130 – January/February 169) was Roman emperor from 161 until his death in 169, alongside his adoptive brother Marcus Aurelius. "),
            MessageModel(text: "The senate accepted, granting Lucius the imperium, the tribunician power, and the name Augustus."),
            MessageModel(text: "The Roman Empire lost the strengths that had allowed it to exercise effective control over its Western provinces; modern historians posit factors including the effectiveness and numbers of the army, the health and numbers of the Roman population, the strength of the economy, the competence of the emperors, the internal struggles for power, the religious changes of the period, and the efficiency of the civil administration. Increasing pressure from invading barbarians outside Roman culture also contributed greatly to the collapse. Climatic changes and both endemic and epidemic disease drove many of these immediate factors."),
            MessageModel(text: "Soon after the emperors' accession, Marcus's eleven-year-old daughter, Annia Lucilla, was betrothed to Lucius (in spite of the fact that he was, formally, her uncle)"),
            MessageModel(text: "The emperors permitted free speech, evinced by the fact that the comedy writer Marullus was able to criticize them without suffering retribution. At any other time, under any other emperor, he would have been executed. But it was a peaceful time, a forgiving time. And thus, as the biographer wrote, No one missed the lenient ways of Pius"),
            MessageModel(text: "Immediately after Hadrian's death, Antoninus approached Marcus and requested that his marriage arrangements be amended: Marcus' betrothal to Ceionia Fabia would be annulled, and he would be betrothed to Faustina, Antoninus' daughter, instead. Faustina's betrothal to Ceionia's brother Lucius Commodus would also have to be annulled. Marcus consented to Antoninus' proposal."),
            MessageModel(text: "When his father died in early 138, Hadrian chose Antoninus Pius (86–161) as his successor."),
            MessageModel(text: "Born on 15 December 130, he was the eldest son of Lucius Aelius Caesar, first adopted son and heir to Hadrian. Raised and educated in Rome, he held several political offices prior to taking the throne. After his biological father's death in 138, he was adopted by Antoninus Pius, who was himself adopted by Hadrian. Hadrian died later that year, and Antoninus Pius succeeded to the throne. Antoninus Pius would rule the empire until 161, when he died, and was succeeded by Marcus Aurelius, who later raised his adoptive brother Verus to co-emperor."),
            MessageModel(text: "The emperors' early reign proceeded smoothly.")
        ]
    }
}
