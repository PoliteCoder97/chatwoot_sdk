extension ListExtention on List {
  String listToString() {
    return join(",");
    // return map((e1) => "${e1.toString()},")
    //     .toList()
    //     .toString()
    //     .replaceAll("[", "")
    //     .replaceAll("]", "")
    //     .replaceAll("([", "")
    //     .replaceAll("])", "")
    //     .replaceAll(",", "")
    //     .replaceAll(", ", "");
  }

  String listToStringParams() {
    return map((e1) => e1.toString())
        .toList()
        .toString()
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("([", "")
        .replaceAll("])", "")
        .replaceAll(", ", "");
  }
}
