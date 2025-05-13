import 'dart:convert';
import 'package:blood_donation_app/models/zone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/models/donator.dart';
import 'package:blood_donation_app/utils/http_helper.dart';

class SearchController extends GetxController {
  final TextEditingController searchInputController = TextEditingController();
  final HttpHelper httpHelper = HttpHelper(); // Instance of HTTP helper
  var searchResults = <Donator>[].obs;
  var searchCountryResults = <Zone>[].obs;
  var isLoading = false.obs;
  var isCountryLoading = false.obs; // Loading state for country search
  var selectedFilters =
      <String, String>{}.obs; // Observable map of selected filters

  @override
  void onInit() {
    super.onInit();
    search(); // Perform an initial search with an empty query
  }

  void addFilter(String key, String value) {
    if (value == 'All') {
      selectedFilters.remove(key);
    } else {
      selectedFilters[key] = value;
    }
    // Add or update the key-value pair
    search();
  }

  void removeFilter(String key) {
    selectedFilters.remove(key);
    search();
  }

  void searchCountryAutocomplete(String query) async {
    if (query.isEmpty) {
      searchCountryResults.clear(); // Clear results if the query is empty
      return;
    }

    try {
      isCountryLoading.value = true;

      // Make the API call to fetch autocomplete suggestions
      final response =
          await httpHelper.get('/search/autocomplete/zone?query=$query');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Parse the autocomplete results into a list of Zone objects
        if (responseData['data'] != null) {
          searchCountryResults.value = (responseData['data']['zones'] as List)
              .map((json) => Zone.fromJson(json))
              .toList();
        } else {
          print('No autocomplete data found in the response.');
          searchCountryResults.clear();
        }
      } else {
        print(
            'Failed to fetch autocomplete results. Status code: ${response.statusCode}');
        searchCountryResults.clear();
      }
    } catch (e) {
      print('Error during autocomplete search: $e');
      searchCountryResults.clear();
    } finally {
      isCountryLoading.value = false;
    }
  }

  void handleSelectZone(String city, String country) {
    searchInputController.text = city;
    selectedFilters['city'] = city; // Add the selected zone ID to filters
    selectedFilters['country'] =
        country; // Add the selected country ID to filters
    search();
  }

  /// Perform a search with the given query
  void search() async {
    try {
      isLoading.value = true;

      // Make the API call to search for donors
      Map<String, String> queryParams = {
        "blood_type": selectedFilters["Blood Type"] ?? "",
        "gender": selectedFilters["Gender"] ?? "",
        "type": selectedFilters["Request/Donator"] ?? "",
        "city": selectedFilters["city"] ?? "",
        "country": selectedFilters["country"] ?? "",
        "compatible": selectedFilters["Compatible"] ?? "",
      };
      final query = Uri(queryParameters: queryParams).query;
      final response = await httpHelper.get('/search/search_blood_data?$query');
      print('/search/search_blood_data?$query');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Parse the search results into a list of Donator objects
        if (responseData['data'] != null &&
            responseData['data']['bloodData'] != null) {
          searchResults.value = (responseData['data']['bloodData'] as List)
              .map((json) => Donator.fromJson(json))
              .toList();
        } else {
          print('No blood data found in the response.');
          searchResults.clear();
        }
      } else {
        print(
            'Failed to fetch search results. Status code: ${response.statusCode}');
        searchResults.clear();
      }
    } catch (e) {
      print('Error during search: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
