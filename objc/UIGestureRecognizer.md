### UIPanGestureRecognizer 添加一个Pan动作
http://www.raywenderlich.com/76020/using-uigesturerecognizer-with-swift-tutorial
1. Drag a Pan Gesture Recognizer on top of the banana Image View.
2. Control drag from the new Pan Gesture Recognizer to the View Controller and connect it to the handlePan: function.
3. So select both image views, open up the Attributes Inspector, and check the User Interaction Enabled checkbox
4. 还需要以下代码
```Ruby
@IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        recognizer.view.center = CGPoint(x:recognizer.view.center.x + translation.x,y:recognizer.view.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
```

------

--EOF--