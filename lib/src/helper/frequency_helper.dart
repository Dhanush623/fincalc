dynamic findValueByKey(List<Map<String, dynamic>> list, String keyToFind) {
  for (var map in list) {
    if (map['key'] == keyToFind) {
      return map['value'];
    }
  }
  return null; // Key not found
}
