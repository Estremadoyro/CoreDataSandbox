### CRUD
Basic Create Read Update & Delete operations done with the **CoreData** framework.
Aswell as some additional filter & sort methods.

#### Snippet
```swift
extension HomeViewModel {
    /// # CREATE
    func addPerson(name: String, completion: () -> Void) {
        // 1. Create new model instance
        let person = Person(context: context)
        person.name = name
        person.age = 100
        person.gender = "Male"
        
        // 2. Save data
        saveData()
        
        // 3. Fetch and update state
        getPeople()
        
        // 4. Callback
        completion()
    }
    
    /// # READ
    /// Notice how the Read/Fetch/Get method doesn't alter the *CoreData Store* (LocalData) and just manipulates it.
    func getPeople(completion: (() -> Void)? = nil) {
        do {
            // 1. Create a fetch request
            let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
            
            // 2. Add filter
//            let predicate = NSPredicate.init(format: "name CONTAINS %@", "Leonardo")
//            fetchRequest.predicate = predicate
            
            // 3. Sort by name
//            let sort = NSSortDescriptor(key: #keyPath(Person.name),
//                                        ascending: true,
//                                        selector: #selector(NSString.caseInsensitiveCompare))
//            fetchRequest.sortDescriptors = [sort]
            
            // 3. Execute fetch request
            let fetchedPeople = try context.fetch(fetchRequest)
            
            // 4. Update local state
            self.people = fetchedPeople
            
            // 5. Callback
            completion?()
        } catch {
            print("senku - getPeople - Error: \(error)")
        }
    }
    
    /// # UPDATE
    func updatePerson(_ person: Person, newName: String, completion: () -> Void) {
        // 1. Update model
        person.name = newName
        
        // 2. Save data
        saveData()
        
        // 3. Fetch and update state
        getPeople()
        
        // 4. Callback
        completion()
    }
    
    /// # DELETE
    func deletePerson(_ person: Person, completion: () -> Void) {
        // 1. Delete person
        context.delete(person)
        
        // 2. Save data
        saveData()
        
        // 3. Fetch and update state
        getPeople()
        
        // 4. Callback
        completion()
    }
    
    func relationshipDemo() {
        // 1. Create family
        let family = Family(context: context)
        family.name = "Ishigami"
        
        // 2. Create person
        let person = Person(context: context)
        person.name = "Senku"
        
        // 3. Specify relationship
        person.family = family
        // family.addToPeople(person) // With the pre-defined methods.
        
        // 4. Save context
        saveData()
    }
}

```
##### Save data in CoreData
```swift
private extension HomeViewModel {
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print("senku [DEBUG] \(String(describing: type(of: self))) - Error saving data: \(error)")
        }
    }
}
```
