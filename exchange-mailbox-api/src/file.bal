public function all() {
    io:println("Current directory: " + file:getCurrentDirectory());
    string|error createDirResults = file:createDir("foo");
    if (createDirResults is string) {
        io:println("Created directory path: " + createDirResults);
    }

    string dirPath = checkpanic filepath:build("foo", "bar");
    createDirResults = file:createDir(dirPath, true);
    if (createDirResults is string) {
        io:println("Created nested directory path: " + createDirResults);
    }

    string|error createFileResults = file:createFile("bar.txt");
    if (createFileResults is string) {
        io:println("Created file path: " + createFileResults);
    }
    file:FileInfo|error fileInfoResults = file:getFileInfo("bar.txt");
    if (fileInfoResults is file:FileInfo) {
        io:println("File name: " + fileInfoResults.getName());
        io:println("File size: " + fileInfoResults.getSize().toString());
        io:println("Is directory: " + fileInfoResults.isDir().toString());
        io:println("Modified at " +
                        fileInfoResults.getLastModifiedTime().toString());
    }

    boolean fileExists = file:exists("bar.txt");
    io:println("bar.txt file exists: " + fileExists.toString());
    string filePath = checkpanic filepath:build("foo", "bar", "bar.txt");
    error? copyDirResults = file:copy("bar.txt", filePath, true);
    if (copyDirResults is ()) {
        io:println("bar.txt file is copied to new path " + filePath);
    }

    string newFilePath = checkpanic filepath:build("foo", "bar1.txt");
    error? renameResults = file:rename("bar.txt", newFilePath);
    if (renameResults is ()) {
        io:println("bar.txt file is moved to new path " + newFilePath);
    }
    
    string tempDirPath = file:tempDir();
    io:println("Temporary directory: " + tempDirPath);
    file:FileInfo[]|error readDirResults = file:readDir("foo");
    error? removeResults = file:remove(newFilePath);
    if (removeResults is ()) {
        io:println("Remove file at " + newFilePath);
    }
    removeResults = file:remove("foo", true);
    if (removeResults is ()) {
        io:println("Remove foo directory with all child elements.");
    }
}
