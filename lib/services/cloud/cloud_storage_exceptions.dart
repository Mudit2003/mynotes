class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNotesException extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}
