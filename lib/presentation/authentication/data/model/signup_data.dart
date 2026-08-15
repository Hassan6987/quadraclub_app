class SignupData {
  // Step 1 — Create account
  String fullName = '';
  DateTime? dateOfBirth;
  String email = '';
  String password = '';
  String? profilePhotoPath;

  // Step 3 — About you
  String? location;
  String? gender; // Masculine, Feminine, Prefer not to say
  String? dominantHand; // Left, Right

  // Step 4 — Games preferences
  List<String> selectedSports = [];

  // Step 5 — Define your level
  String? preferredSide; // Left, Right, Both
  Map<String, String?> sportCategories = {}; // sport -> category label
}
