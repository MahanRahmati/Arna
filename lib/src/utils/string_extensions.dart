/// String extension.
extension ArnaStringExtension on String {
  static const List<String> _numbers = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  ];

  /// Normalize the string.
  String toNormalize() {
    return toLowerCase().removeDiacritics();
  }

  /// Capitalize the string.
  String toCapitalize() {
    return isNotEmpty
        ? '${this[0].toUpperCase()}${substring(1, length).toLowerCase()}'
        : this;
  }

  /// remove diacritics from the string.
  String removeDiacritics() {
    const String diacriticsString =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const String nonDiacriticsString =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    return splitMapJoin(
      '',
      onNonMatch: (final String char) =>
          char.isNotEmpty && diacriticsString.contains(char)
              ? nonDiacriticsString[diacriticsString.indexOf(char)]
              : char,
    );
  }

  /// remove last word from the string.
  String removeLastWord([final int amount = 1]) {
    final int cacheLenght = length;
    if (cacheLenght > amount) {
      return substring(0, cacheLenght - amount);
    } else {
      return '';
    }
  }

  /// Remove all numbers from the string.
  String removeAllNumbers({final List<String> include = const <String>[]}) {
    final List<String> invalid = _numbers.toList()..addAll(include);
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      final String character = this[i];
      if (!invalid.contains(character)) {
        buffer.write(character);
      }
    }
    return buffer.toString();
  }

  /// Remove everything except numbers from the string.
  String removeAllNotNumber({final List<String> exclude = const <String>[]}) {
    final List<String> valid = _numbers.toList()..addAll(exclude);
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      final String character = this[i];
      if (valid.contains(character)) {
        buffer.write(character);
      }
    }
    return buffer.toString();
  }
}
