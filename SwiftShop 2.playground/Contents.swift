//: Playground - noun: a place where people can play

import UIKit



// Класс можно рассматривать как "чертеж дома" - образец, по которому будет в дальнейшем построен дом
// Экземпляр класса это объект "Дом", построенный по такому чертежу
// пример: Int - тип данных, переменная типа Int - является экземпляром типа Int

/* 1. Добавить следующий функционал в проект SwiftShop.playground:
 
 a. Товар в наличии и под заказ
 b. Возврат товара по условиям
 c. Очередь на кассе, несколько касс
 d. Учет количества товара
 2. Подумать о классах для проекта “погода”. Краткое описание проекта - загрузка погоды по городам из Интернета. Добавление, удаление городов.*/


enum CurrentProduct {
    case available
    case order
}

enum Condition {
    case good
    case bad
}

//struct ConditionOfProduct {
//    var product: Product
//    var condition: Condition
//
//    var current: String {
//        switch condition {
//        case .good:
//            return product.productId
//        case .bad:
//            return product.productId
//        }
//
//    }
//}
//
//struct AvaibleProduct {
//    var currentProduct: CurrentProduct
//    var product: Product
//
//
//    var current: String {
//        switch currentProduct {
//        case .available:
//            return product.productId
//        case .order:
//            return product.productId
//
//        }
//    }
//}




class Product {
    
    var productId: String                     = ""
    var name: String                          = ""
    var price: Double                         = 0.0
    
    init(productId: String, name: String, price: Double) {
        self.productId                            = productId// self - автоматически формируемая ссылка на данный экземпляр класса
        self.name                                 = name
        self.price                                = price
    }
    
    convenience init(productId: String, name: String){
        // вспомогательный инит, для ситуации к примеру когда, товар пришел, но стоимость товара еще не рассчитана
        self.init(productId: productId, name: name, price: 0.0)
    }
    
}



class Storage {
    
    static let instance = Storage()//объявляем синглтон, товар должен храниться централизованно, на одном складе
    private var products = [Product]()// массив продукции
    
    func addProduct(product: Product){
        products.append(product) // функция экземпляра класса, добавляющая в массив новый продукт
    }
    
    func removeProductByID(productId: String){ // функция экземпляра класса
        for i in 0..<products.count{ // цикл по массиву продукции
            if products[i].productId == productId {
                products.remove(at: i) // если ID совпал, удаляем и завершаем цикл
                break
            }
        }
    }
    
    
    func printAllProducts(){
        
        for product in products{
            print("ID = \(product.productId) name = \(product.name) price = \(product.price)")
            
        }
    }
    //Lomtev: Товар в наличии и под заказ
    func isOrderedProduct(productId: String) ->  CurrentProduct {
        
        for product in Storage.instance.products {
            
            if product.productId == productId {
                
                return .available
            }
        }
        return .order
    }
    
    //Lomtev: возврат по условиям
    func isTestingProduct (productId:String, condition: Condition) -> String {
        
        if let product: Product = Storage.productByID(productID: productId){
            if condition == .bad {
                Storage.instance.addProduct(product: product)
                return ("Возвращаем товар")
            }
        }
        condition == .good
        return ("Все в порядке")
    }
    
    
    
    class func isProductAvailable(productId: String) -> Bool { // функция класса
        for product in instance.products { // доступ к массиву экземпляра
            //            проверка через вызов функции класса productByID() и опциональную привязку
            //            if let _ : Product = productByID(productID: productId) {
            //                return true
            //            }
            if product.productId == productId {
                
                return true
            }
        }
        return false
        
    }
    
    class func productByID(productID: String) -> Product?{ // функция класса, возвращает опцион
        for product in instance.products{ // доступ к массиву экземпляра
            if product.productId == productID{
                return product
            }
        }
        return nil
    }
    // обратите внимание первые две функции экземпляра, последние две функции класса, отличие в доступе к свойствам
    
    func isOrder(productID: String) -> Bool {
        for product in Storage.instance.products { // доступ к массиву экземпляра
            //            проверка через вызов функции класса productByID() и опциональную привязку
            //            if let _ : Product = productByID(productID: productId) {
            //                return true
            //            }
            if product.productId == productID {
                return true
            }
        }
        return false
        
    }
}


class Cashbox {
    class func trySell(productId:String, price: inout Double) -> (Bool, String?){ // функция класса
        // параметр in-out это значение, которое будет подано в функцию (IN), изменено внутри функции и затем возвращено, заменив значение в переменной поданной на вход функции
        if let product: Product                   = Storage.productByID(productID: productId){// опциональная привязка, если такой продукт с переданным ID имеется в базе, то проверяем его дальше
            if product.price <= price {
                price-=product.price
                Storage.instance.removeProductByID(productId: product.productId)
                return (true, nil)
            }
            return (false, "Не достаточно средств для покупки \(product.name)")
        }
        return (false, "Продукта с ID             = \(productId) нет на складе")
    }
}





let toy                                   = Product(productId: "PRODUCTID_TOY", name: "super_toy", price: 38.59)//создаем экземпляр класса Product
print(toy.name)

let pen                                   = Product(productId: "PRODUCTID_TOY", name: "super_pen", price: 9.99)//создаю еще один экземпляр

var storage                               = Storage.instance//получаем экземпляр хранилища, для добавления или удаления позиции в Storage, необходимо получить его экземпляр, поэтому используем метод экземпляра

storage.addProduct(product: toy) // добавим в хранилище toy

var storage2 = Storage.instance//получаем экземпляр хранилища
storage2.addProduct(product: pen) // добавим в хранилище pen

print("Storage")
storage.printAllProducts() //выводим содержимое из storage

print("Storage2")
storage2.printAllProducts() // выводим содержимое из storage2

//в storage и storage2 получены ссылки на один и тот же экземпляр класса Storage, в памяти это хранится как один объект



print(Storage.isProductAvailable(productId: toy.productId)) // для проверки доступности позиции на складе, заходить на него не надо, поэтому используем функцию класса, которая сама по необходимости зайдет на этот склад. Внутри этой функции мы получаем экземпляр класса объект и работаем с его свойствами


//покупка и выдача сдачи

var price = 100.0
let resut: (Result: Bool, Error: String?) = Cashbox.trySell(productId: pen.productId, price: &price)
if let error: String = resut.Error {
    print(error)
} else {
    print("Сдача составила =\(price)") // inout параметр
}


//Lomtev : 2

class City {
    var namecity: String?
    let cityIndex: Int?
    let  currentTemperature: Double
    
    init(name: String, cityIndex: Int, currentTemperature: Double) {
        self.namecity = name
        self.cityIndex = cityIndex
        self.currentTemperature = currentTemperature
    }
}

class APIMng {
    let api: String
    var url: String?
    var errorFetch: Bool
    
    init(api: String, url: String, errorFetch: Bool) {
        self.api = api
        self.url = url
        self.errorFetch = errorFetch
    }
    var citys = [City]()
    
    func fetchingUrl(name: String, cityIndex: Int) -> [City]{
        if url != nil {
            for city in citys {
                if errorFetch == false {
                    citys.append(city)
                }
            }
        }
        return citys
    }
    func removeCity(name: String) {
        for i in 0...citys.count {
            if citys[i].namecity == name {
                citys.remove(at: i)
            }
        }
    }
}
