class UserSelections {
  List<String> seasonings = [];
  List<String> spiceries = [];

  List<String> customBottomSheetIngredients = [];
  String? maincategoryServings;
  String? maincategoryUtensil;
  String? selectedMainIngredient;

  String subcategoryCookingSkill = '';
  double subcategoryCookingTime = 5.0;
  String? subcategoryKeywords = '';
  bool gourmetMode = false;
  bool allinMode = false;

  void updateSeasoningsAndSpiceries(
      List<String> newSeasonings, List<String> newSpiceries) {
    seasonings = newSeasonings;
    spiceries = newSpiceries;
  }

  // 선택 사항 업데이트 메서드들
  void mainCategoryServings(String? category) {
    maincategoryServings = category;
  }

  void mainCategoryUtensil(String? category) {
    maincategoryUtensil = category;
  }

  void updateSeasonings(List<String> selectedSeasonings) {
    seasonings = selectedSeasonings;
  }

  // Update the spiceries list with the selected items
  void updateSpiceries(List<String> selectedSpiceries) {
    spiceries = selectedSpiceries;
  }

  void selectMainIngredient(String ingredient) {
    selectedMainIngredient = ingredient;
  }

  void addIngredient(String ingredient) {
    customBottomSheetIngredients.add(ingredient);
  }

  String getModeText() {
    if (gourmetMode) {
      return "중에서 레시피에 가장 적합한 재료만 사용";
    } else if (allinMode) {
      return "(을)를 모두 사용";
    }
    return ""; // 두 모드 모두 활성화되지 않은 경우
  }
}
