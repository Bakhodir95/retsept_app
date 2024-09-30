String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email kiriting";
    }

    final emailRegExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (!emailRegExp.hasMatch(value)) {
      return "To'g'ri email kiriting";
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Parol kiriting";
    }

    if (value.length < 6) {
      return "Parol kamida 6 ta belgidan iborat bo'lishi kerak";
    }

    return null;
  }