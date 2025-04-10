class Validations {
  static final fullNameRegex = RegExp(r"^([A-Za-z]{2,99}\.?)( [A-Za-z]{2,99}\.?){0,3}$");
  static final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static final numberRegex = RegExp(r'^(?:\+?88)?01[3-9]\d{8}$');
  static final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{6,}$');


  static String? nameValidator(String? name) {
    if (name!.trim().isEmpty) {
      return "Enter Name";
    } else if (!fullNameRegex.hasMatch(name.trim())) {
      return "Name must be between 2-99 characters, only letters and optional periods.";
    } else {
      return null;
    }
  }

  static String? emailValidator(String? email) {
    if (email!.trim().isEmpty) {
      return "Enter Email";
    } else if (!emailRegex.hasMatch(email)) {
      return "Invalid Email Format";
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? password) {
    if (password!.trim().isEmpty) {
      return "Enter Password";
    } else if (passwordRegex.hasMatch(password) == false) {
      return "At least 1 uppercase, 1 lowercase & 1 number with length 6";
    }
    return null;
  }

  static String? numberValidator(String? value) {
    if (value!.trim().isEmpty) {
      return "Enter Mobile Number";
    } else if (!numberRegex.hasMatch(value)) {
      return "Invalid Mobile Number Format";
    } else {
      return null;
    }
  }


  static String? nonEmptyValidator(String? value) {
    if (value!.trim().isEmpty) {
      return "Cannot be empty";
    }
    return null;
  }

  static String? bioValidator(String? value) {
    if (value!.trim().isEmpty) {
      return "Cannot be empty";
    } else if (value.length >= 150) {
      return "Bio length must be in 150 characters";
    }
    return null;
  }
}
