import Foundation

class Module {
    let name: String
    var unbuildedDependencies: Set<String>
    var isBuilded: Bool = false

    init(name: String, unbuildedDependencies: Set<String>) {
        self.name = name
        self.unbuildedDependencies = unbuildedDependencies
    }

    func buildModule(dependencies: inout [String: [Module]], modules: inout [String: Module]) -> [String] {
        var query: [String] = []
        while (!unbuildedDependencies.isEmpty) {
            let dep = unbuildedDependencies.first!
            let newQuery = modules[dep]!.buildModule(dependencies: &dependencies, modules: &modules)
            query.append(contentsOf: newQuery)
            unbuildedDependencies.remove(dep)
            if let modules = dependencies[dep] {
                modules.forEach { $0.removeDependency(dep) }
                dependencies.removeValue(forKey: dep)
            }
        }

        if !isBuilded {
            query.append(name)
            if let modules = dependencies[name] {
                modules.forEach { $0.removeDependency(name) }
            }
            isBuilded = true
        }

        return query
    }

    func removeDependency(_ dep: String) {
        unbuildedDependencies.remove(dep)
    }
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readEmpty() {
    readLine()
}

func readNextModule(dependencies: inout [String: [Module]]) -> Module {
    let info = readLine()!.split(separator: ":")
    let name = String(info[0])
    if info.count > 1 {
        let deps = info[1].split(separator: " ").map{ String($0) }
        let module = Module(name: name, unbuildedDependencies: Set(deps))
        for dep in deps {
            if dependencies[dep] == nil {
                dependencies[dep] = [module]
            } else {
                dependencies[dep]!.append(module)
            }
        }
        return module
    } else {
        return Module(name: name, unbuildedDependencies: Set<String>())
    }
}

func readBuildModule() -> String {
    readLine()!
}

func handleNextDataSet() {
    var dependencies: [String: [Module]] = [:]
    var modules: [String: Module] = [:]
    readEmpty()
    let modulesCount = readInt()
    for _ in 0 ..< modulesCount {
        let module = readNextModule(dependencies: &dependencies)
        modules[module.name] = module
    }

    let buildsCount = readInt()
    for _ in 0 ..< buildsCount {
        let moduleName = readBuildModule()
        let module = modules[moduleName]!
        let result = module.buildModule(dependencies: &dependencies, modules: &modules)
        if result.isEmpty {
            print("0")
        } else {
            let resultString = result.joined(separator: " ")
            print("\(result.count) \(resultString)")
        }
    }

    print()
}

func main() {
    let dataSetCount = readInt()
    for _ in 0 ..< dataSetCount {
        handleNextDataSet()
    }
}

main()
