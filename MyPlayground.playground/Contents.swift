import UIKit

func findPrimNumber() -> [Int] {
    var num = [2, 3]
    var flag = true
    var sqr = 0
    for x in 4...10000 {
        sqr = Int(sqrt(Double(x)))
        for y in 2...sqr {
            if x % y == 0 {
                flag = false
                break
            }
        }
        if flag {
            num.append(x)
        }
        flag = true
    }
    return num
} //返回1到10000中所有的质数

var numbers = findPrimNumber()
numbers.sort() //升序排序

//降序排序
/// mark: method 1: 自定义函数的闭包，将函数作为参数传递进排序函数中
func descending(x: Int, y: Int) -> Bool {
    return x > y
}
numbers.sort(by: descending)

/// mark: method 2: 指定参数名和类型的闭包，这个是最标准的闭包的语法
numbers.sort { (x: Int, y: Int) -> Bool in
    return x > y
}

/// mark: method 3: 利用推断只指定参数名的闭包，当定义函数参数时，肯定会定义传入的闭包的类型，所以可以根据上下文推断闭包中参数的类型
numbers.sort { (x, y) -> Bool in
    return x > y
}

/// mark: method 4: 利用推断省略返回值类型的闭包，同第三种方法，返回值类型也可以通过上下文推断
numbers.sort { (x, y) in
    return x > y
}

/// mark: method 5: 利用推断省略参数和返回值的闭包，同第三种方法，参数类型和返回值类型都可以通过上下文推断，所以可以使用一个语法糖来表示参数，其中$0表示第一个参数，$1表示第二个参数，如果还有更多的参数，依次类推
numbers.sort(by: { return $0 > $1 })

/// mark: method 6: 省略return的闭包,当闭包中只有一句return语句时，可以省略return
numbers.sort { $0 > $1 }

/// mark: method 7: 传入操作符函数的闭包，在Swift中，操作符也定义为函数，所以操作符也可以作闭包使用
numbers.sort(by: >)

//性别的枚举
enum Gender: Int {
    case male    //男性
    case female  //女性
    case unknow  //未知
    
    //重载>操作符，方便后面排序使用
    static func >(lhs: Gender, rhs: Gender) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

//人类
class Person: CustomStringConvertible  {
    var firstName: String  //姓
    var lastName: String  //名
    var age: Int  //年龄
    var gender: Gender  //性别
    
    var fullName: String {  //全名
        get {
            return firstName + lastName
        }
    }
    
    //构造方法
    init(firstName: String, lastName: String, age: Int, gender: Gender) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.gender = gender
    }
    
    convenience init(firstName: String, age: Int, gender: Gender) {
        self.init(firstName: firstName, lastName: "", age: age, gender: gender)
    }
    
    convenience init(firstName: String) {
        self.init(firstName: firstName, age: 0, gender: Gender.unknow)
    }
    
    required convenience init() {
        self.init(firstName: "")
    }
    
    //重载==
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.age == rhs.age && lhs.gender == rhs.gender
    }
    
    //重载!=
    static func !=(lhs: Person, rhs: Person) -> Bool {
        return !(lhs == rhs)
    }
    
    //实现CustomStringConvertible协议中的计算属性，可以使用print直接输出对象内容
    var description: String {
        return "fullName: \(self.fullName), age: \(self.age), gender: \(self.gender)"
    }
}

var p1 = Person(firstName: "张")
var p2 = Person(firstName: "张", age: 20, gender: .male)
print(p1)  //输出fullName: 张, age: 0, gender: male
print(p1 == p2)  //输出false
print(p1 != p2)  //输出true

//教师类
class Teacher: Person {
    var title: String  //标题
    
    //构造方法
    init(title: String, firstName: String, lastName: String, age: Int, gender: Gender) {
        self.title = title
        super.init(firstName: firstName, lastName: lastName, age: age, gender: gender)
    }
    
    init(title: String) {
        self.title = title
        super.init(firstName: "", lastName: "", age: 0, gender: .unknow)
    }
    
    convenience required init() {
        self.init(title: "")
    }
    
    //重写父类的计算属性
    override var description: String {
        return "title: \(self.title), fullName: \(self.fullName), age: \(self.age), gender: \(self.gender)"
    }
}

var t1 = Teacher(title: "hello")
print(t1)  //输出title: hello, fullName: , age: 0, gender: unknow

//学生类
class Student: Person {
    var stuNo: Int  //学号
    
    //构造方法
    init(stuNo: Int, firstName: String, lastName: String, age: Int, gender: Gender) {
        self.stuNo = stuNo
        super.init(firstName: firstName, lastName: lastName, age: age, gender: gender)
    }
    
    init(stuNo: Int) {
        self.stuNo = stuNo
        super.init(firstName: "", lastName: "", age: 0, gender: Gender.unknow)
    }
    
    required convenience init() {
        self.init(stuNo: 0)
    }
    
    //重写父类的计算属性
    override var description: String {
        return "stuNo: \(self.stuNo), fullName: \(self.fullName), age: \(self.age), gender: \(self.gender)"
    }
}

var s1 = Student(stuNo: 2015110101)
print(s1)  //输出stuNo: 2015110101, fullName: , age: 0, gender: unknow

//初始化一个空的Person数组
var array = [Person]()

//生成5个Person对象
for i in 1...5 {
    let temp = Person(firstName: "张", lastName: "\(i)", age: 20, gender: .male)
    array.append(temp)
}
//生成3个Teacher对象
for i in 1...3 {
    let temp = Teacher(title: "hello", firstName: "李", lastName: "\(i)", age: 21, gender: .female)
    array.append(temp)
}
//生成4个Student对象
for i in 1..<5 {
    let temp = Student(stuNo: 2015110100 + i, firstName: "王", lastName: "\(i)", age: 19, gender: .male)
    array.append(temp)
}

//定义一个字典，用于统计每个类的对象个数
var dict = ["Person": 0, "Teacher": 0, "Student": 0]

for item in array {
    if item is Teacher {  //是否是Teacher类
        dict["Teacher"]! += 1
    } else if item is Student {  //是否是Student
        dict["Student"]! += 1
    } else {  //Person类
        dict["Person"]! += 1
    }
}

//输出字典值
for (key, value) in dict {
    print("\(key) has \(value) items")
}

//原始数组
print("------------------------------")
for item in array {
    print(item)
}

//根据age从大到小排序
print("------------------------------")
array.sort { return $0.age > $1.age}
for item in array {
    print(item)
}

//根据全名从前往后排序
print("------------------------------")
array.sort { return $0.fullName < $1.fullName}
for item in array {
    print(item)
}

//根据gender和age从大往小排序
print("------------------------------")
array.sort { return ($0.gender > $1.gender) && ($0.age > $1.age) }
for item in array {
    print(item)
}

