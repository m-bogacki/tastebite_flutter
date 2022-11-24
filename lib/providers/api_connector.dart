import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/constants.dart';
import '../models/category.dart';
import '../models/meal.dart';

abstract class ApiConnector {
  static Future<List<Meal>> getMealsByCategory(String category) async {
    List<Meal> mealsToDisplay = [];
    try {
      final Url = Uri.parse('${Constants.mealUrl}/filter.php?c=${category}');
      final response = await http.get(Url);
      final decodedDessertsResponse = jsonDecode(response.body);
      final List<dynamic> mealsList = decodedDessertsResponse['meals'];
      for (var meal in mealsList.take(10)) {
        mealsToDisplay.add(Meal(
          meal['idMeal'],
          meal['strMeal'],
          meal['strMealThumb'],
        ));
      }
      return mealsToDisplay;
    } catch (error) {
      rethrow;
    }
  }

  static Future<Meal> getRandomMeal() async {
    final headerMealUrl = Uri.parse('${Constants.mealUrl}/random.php');
    final responseHeaderMeal = await http.get(headerMealUrl);
    final decodedHeaderMealResponse = jsonDecode(responseHeaderMeal.body);
    final Map<String, dynamic> extractedMeal =
        decodedHeaderMealResponse['meals'][0];
    Meal headerMeal = Meal(
      extractedMeal['idMeal'],
      extractedMeal['strMeal'],
      extractedMeal['strMealThumb'],
    );
    return headerMeal;
  }

  static Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    try {
      final Url = Uri.parse('${Constants.mealUrl}/categories.php');
      final response = await http.get(Url);
      final decodedResponse = jsonDecode(response.body);
      final List<dynamic> extractedCategories = decodedResponse['categories'];
      for (var extractedCategory in extractedCategories) {
        Category category = Category(
            extractedCategory['idCategory'],
            extractedCategory['strCategory'],
            extractedCategory['strCategoryThumb'],
            extractedCategory['strCategoryDescription']);
        categories.add(category);
      }
      return categories;
    } catch (error) {
      rethrow;
    }
  }
}