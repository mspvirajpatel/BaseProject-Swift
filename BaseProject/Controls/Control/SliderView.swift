
import UIKit

class SliderView: UIView, UIScrollViewDelegate {
    
    public var selectedIndex = 0 {
        didSet{
            if self.subviews.count > 0 {
                assert(selectedIndex < subViewCount, "No exist")
                changeView()
            }
        }
    }
    
    public var topViewHeight = 50
   
    public var btnFontSize: CGFloat = 17

    public var btnFontColorNormal = UIColor.black
  
    public var btnFontColorSelected = UIColor.blue
  
    public var lineColor = UIColor.black
   
    public var lineSize: CGFloat = 1
   
    public var sliderColor = UIColor.blue
  
    public var sliderHeight: CGFloat = 2
   
    public var sliderWidth: CGFloat = 0
    
    public var isAllowHandleScroll = true
  
    public var isBounces = false
  
    public var isShowBtnAnimation = true
  
    public var isShowVerticalLine = true
   
    public var isShowHorizontalLine = true
    
    
    private var titles = [String]()
    private var contentViews = [UIView]()
    private var subViewCount = 0
    private var BaseTag = 1000
    private var selectedBtn = UIButton()
    private var topView = UIView()
    private var sliderView =  UIView()
    private var scrollView = RecognizerScrollView()
    
    convenience init(frame: CGRect, titles: [String], contentViews: [UIView]) {
        self.init(frame: frame)
        
        assert(titles.count == contentViews.count, "标题个数和自视图个数不相等！")
        assert(titles.count != 0, "自视图个数为0！")
        
        self.titles = titles
        self.contentViews = contentViews
        subViewCount = titles.count
    }
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func makeUI() {
        
        
        maketopView()
        
        
        addContentView()
    }
    
    private func maketopView() {
        
        topView.frame = CGRect(x: 0, y: 0, width: Int(self.width), height: topViewHeight)
        topView.backgroundColor = UIColor.white
        self.addSubview(topView)
        

        let btnW = topView.width / CGFloat(subViewCount)
        let btnH = topView.height
        for i in 0 ..< subViewCount {
            let btnX = CGFloat(i) * btnW
            let button = UIButton(frame: CGRect(x: btnX, y: 0, width: btnW, height: btnH))
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(btnFontColorNormal, for: .normal)
            button.setTitleColor(btnFontColorSelected, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: btnFontSize)
            button.tag = i + BaseTag
            button.addTarget(self, action: #selector(titleBtnClicked(btn:)), for: .touchUpInside)
            topView.addSubview(button)
            
            if i == selectedIndex {
                button.isEnabled = false
                selectedBtn = button
            }
            

            if isShowVerticalLine {
                let lineView = UIView(frame: CGRect(x: button.right, y: button.height * 0.2, width: lineSize, height: button.height * 0.6))
                lineView.backgroundColor = lineColor
                topView.addSubview(lineView)
            }
        }
        

        if isShowHorizontalLine {
            let bottomLineView = UIView(frame: CGRect(x: 0, y: topView.height - lineSize, width: topView.width, height: lineSize))
            bottomLineView.backgroundColor = lineColor
            topView.addSubview(bottomLineView)
        }
        

        let sliderViewW = sliderWidth == 0 ?  topView.width / CGFloat(subViewCount) : sliderWidth
        let sliderViewX = (btnW - sliderViewW) / 2.0
        sliderView.frame = CGRect(x: sliderViewX, y: topView.height - sliderHeight, width: sliderViewW, height: sliderHeight)
        sliderView.backgroundColor = sliderColor
        topView.addSubview(sliderView)
    }
    

    private func addContentView() {
        
        scrollView.frame = CGRect(x: 0, y: topView.bottom, width: self.width, height: self.height - topView.height)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.gray
        scrollView.bounces = isBounces
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = isAllowHandleScroll
        scrollView.contentSize = CGSize(width: self.width * CGFloat(subViewCount), height: 0)
        self.addSubview(scrollView)
        
        for i in 0 ..< subViewCount {
            let view = contentViews[i]
            let viewX = CGFloat(i) * scrollView.width
            view.frame = CGRect(x: viewX, y: 0, width: scrollView.width, height: scrollView.height)
            scrollView.addSubview(view)
        }
        scrollView.contentOffset = CGPoint(x: CGFloat(selectedIndex) * scrollView.width, y: 0)
    }
    
    

    private func changeView() {
        
        if let btn = topView.viewWithTag(selectedIndex + BaseTag) {
            titleBtnClicked(btn: btn as! UIButton)
        }
    }
    

    @objc private func titleBtnClicked(btn: UIButton) {
        
        if btn == selectedBtn {
            return
        }
        

        changeSelectedBtn(btn: btn)
        

        UIView.animate(withDuration: 0.25) {
            let num = btn.tag - self.BaseTag
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.width * CGFloat(num), y: 0)
        }
    }
    

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
   
        let itemWidth = scrollView.width / CGFloat(subViewCount)
        let xoffset = (itemWidth / scrollView.width) * scrollView.contentOffset.x
        sliderView.transform = CGAffineTransform(translationX: xoffset, y: 0)
    }
    

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let btn = topView.viewWithTag(index + BaseTag) as! UIButton
        
        changeSelectedBtn(btn: btn)
    }
    
 
    private func changeSelectedBtn(btn: UIButton) {
        
        selectedBtn.isEnabled = true
        btn.isEnabled = false
        selectedBtn = btn
        
        
        if isShowBtnAnimation {
            scaleAnimationTitleBtn(btn: btn)
        }
    }
    
    
    private func scaleAnimationTitleBtn(btn: UIButton) {
        
        UIView.animate(withDuration: 0.25, animations: {
            btn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finished) in
            UIView.animate(withDuration: 0.25, animations: {
                btn.transform = CGAffineTransform(scaleX: 1 / 0.95, y: 1 / 0.95)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.25, animations: {
                    btn.transform = CGAffineTransform.identity
                })
            })
        }
    }
}




class RecognizerScrollView: UIScrollView {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
            let pan = gestureRecognizer as? UIPanGestureRecognizer
            if ((pan?.translation(in: self).x) ?? 0 > CGFloat(0)) && (self.contentOffset.x == CGFloat(0)) {
                return false
            }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
