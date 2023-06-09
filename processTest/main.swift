//
//  main.swift
//  processTest
//
//  Created by Ed Elliott on 6/1/23.
//

import Foundation

print("Hello, World!")

let filemgr = FileManager.default

let processPath = URL(fileURLWithPath:
//                      "C:\\Users\\edell\\Dev\\Pearson\\SFDX2\\TestProject")
                      "/Users/eddie/Dev/Pearson/SFDX2/TestProject")

filemgr.changeCurrentDirectoryPath(
//        "C:\\Users\\edell\\Dev\\Pearson\\SFDX2\\TestProject")
        "/Users/eddie/Dev/Pearson/SFDX2/TestProject")

print("Current Directory: \(filemgr.currentDirectoryPath)")

let pipe = Pipe()

let process = Process()
process.executableURL = URL(fileURLWithPath:
                                // "C:\\Program Files\\sfdx\\bin\\sf.cmd")
                            "/usr/local/bin/sf")
process.arguments = ["project", "retrieve", "start", "--metadata", "CustomObject:Account"]
process.currentDirectoryURL = processPath
process.standardOutput = pipe

process.terminationHandler = { (process) in
   print("\ndidFinish: \(!process.isRunning)")
}

do {
    process.waitUntilExit()
    try process.run()
} catch {
    print(error)
}

let data = pipe.fileHandleForReading.readDataToEndOfFile()

guard let standardOutput = String(data: data, encoding: .utf8) else {
    FileHandle.standardError.write(Data("Error in reading standard output data".utf8))
    fatalError() // or exit(EXIT_FAILURE) and equivalent
    // or, you might want to handle it in some other way instead of a crash
}

print("Output: \(standardOutput)")
