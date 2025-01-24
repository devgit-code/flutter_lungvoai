class UserData {
  static String idName = 'id00000';  // Default initial ID

  // Increase ID when needed
  static void increaseId() {
    int currentId = int.tryParse(idName.substring(2)) ?? 0;  // Parse the current number from 'id00001'
    currentId++;
    idName = 'id${currentId.toString().padLeft(5, '0')}';  // Increment ID and format it
  }
}
