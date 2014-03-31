GregProbstSoiree
================

Greg Probst's capstone project. An iOS event logging application
```
  var times = Array(2,1,12,3,16,19,23)
  val low = for(i <- times if i < 12) yield i
  val high = for(i <- times if i >= 12) yield i
  times = high.sorted ++ low.sorted
  for(i <- times) println(i)
```
