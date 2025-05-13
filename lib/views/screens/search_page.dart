import 'package:blood_donation_app/controllers/search_controller.dart'
    as custom;
import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:blood_donation_app/l10n/appLocal.dart';
import 'package:blood_donation_app/models/zone.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/skeleton_search.dart';
import 'package:blood_donation_app/views/widgets/map_search.dart'; // Import MapSearch widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import SpinKit

class SearchPage extends StatelessWidget {
  final custom.SearchController searchController =
      Get.put(custom.SearchController());
  final UserController userController = Get.find<UserController>();
  final List<String> filters = [
    'Gender',
    'Blood Type',
    'Request/Donator',
    'Compatible'
  ];
  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? filter = Get.arguments?['filter'];
    final String currentLang = Get.locale?.languageCode ?? 'en';

    final List<String> displayedFilters = [
      AppLocale.gender,
      AppLocale.bloodType,
      AppLocale.requestDonator,
      AppLocale.compatible,
    ].map((key) => translateFilter(key, currentLang)).toList();
    // Apply the filter to the search controller
    if (filter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchController.addFilter('Request/Donator', filter);
      });
    }
    final user = userController.user.value;
    final String defaultHintText = user != null
        ? user.zone ?? 'Search location ...'
        : 'search_default_country'.tr;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: searchController.searchInputController,
                onChanged: (value) {
                  searchController.searchCountryAutocomplete(value);
                },
                decoration: InputDecoration(
                  hintText: defaultHintText,
                  border: InputBorder.none,
                ),
              ),
            ),
            Obx(() {
              return searchController.isCountryLoading.value
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: SpinKitChasingDots(
                          color: GlobalColors.primaryColor,
                          size: 20.0,
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            }),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: GlobalColors.primaryColor),
            onPressed: () {
              _showMapBottomSheet(context); // Open the MapSearch widget
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _showFilterBottomSheet(context, filter);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: GlobalColors.lightGray,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    searchController.selectedFilters[filter] !=
                                            null
                                        ? GlobalColors.primaryColor
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              displayedFilters[filters.indexOf(filter)],
                              style: TextStyle(color: GlobalColors.accentColor),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ))),
          SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                Obx(() {
                  if (searchController.isLoading.value) {
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return SkeletonLoader();
                      },
                    );
                  }

                  final results = searchController.searchResults;
                  return results.isEmpty
                      ? Center(
                          child: Text(
                            'No results found.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final donor = results[index];
                            return Card(
                              elevation: 0,
                              color: GlobalColors.secondaryColor,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                onTap: () {
                                  print(searchController.selectedFilters);
                                  Get.toNamed(
                                    '/details',
                                    arguments: {
                                      'donator': donor,
                                      'isDonator': searchController
                                                          .selectedFilters[
                                                      'Request/Donator'] ==
                                                  'donor' ||
                                              searchController.selectedFilters[
                                                      'Request/Donator'] ==
                                                  null
                                          ? true
                                          : false,
                                    },
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: GlobalColors.primaryColor
                                      .withOpacity(0.1),
                                  child: Text(
                                    donor.username[0].toUpperCase(),
                                    style: TextStyle(
                                      color: GlobalColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(donor.username),
                                subtitle: Text(
                                    ' ${donor.bloodType} 🩸    📍  ${donor.zone} '),
                              ),
                            );
                          },
                        );
                }),
                Obx(() {
                  final autocompleteResults =
                      searchController.searchCountryResults;
                  if (autocompleteResults.isEmpty) {
                    return SizedBox.shrink(); // Hide autocomplete if no results
                  }

                  return Positioned(
                    top: 0, // Position below the search input
                    left: 0,
                    right: 0,
                    child: Material(
                      elevation: 1,
                      color: GlobalColors.secondaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: autocompleteResults.length,
                        itemBuilder: (context, index) {
                          final Zone zone = autocompleteResults[index];
                          return ListTile(
                            title: Text('📍${zone.country}, ${zone.city}'),
                            onTap: () {
                              searchController.handleSelectZone(
                                  zone.city, zone.country);
                              searchController.searchCountryResults
                                  .clear(); // Clear autocomplete
                            },
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMapBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.8, // 80% of screen height
          child: MapSearch(
            donators: searchController.searchResults, // Pass the search results
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context, String filter) {
    showModalBottomSheet(
      backgroundColor: GlobalColors.secondaryColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by $filter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                if (filter == 'Gender') ...[
                  _buildFilterOption(context, 'All', filter),
                  _buildFilterOption(context, 'male', filter),
                  _buildFilterOption(context, 'female', filter),
                ] else if (filter == 'Blood Type') ...[
                  _buildFilterOption(context, 'All', filter),
                  _buildFilterOption(context, 'A+', filter),
                  _buildFilterOption(context, 'A-', filter),
                  _buildFilterOption(context, 'B+', filter),
                  _buildFilterOption(context, 'B-', filter),
                  _buildFilterOption(context, 'AB+', filter),
                  _buildFilterOption(context, 'AB-', filter),
                  _buildFilterOption(context, 'O+', filter),
                  _buildFilterOption(context, 'O-', filter),
                ] else if (filter == 'Request/Donator') ...[
                  _buildFilterOption(context, 'requester', filter),
                  _buildFilterOption(context, 'donor', filter),
                ] else if (filter == 'Compatible') ...[
                  _buildFilterOption(context, 'true', filter),
                  _buildFilterOption(context, 'false', filter),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(BuildContext context, String option, String key) {
    return Container(
      decoration: BoxDecoration(
        color: searchController.selectedFilters[key] != null &&
                searchController.selectedFilters[key]!.contains(option)
            ? GlobalColors.lightGray
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(option.tr),
        onTap: () {
          if (searchController.selectedFilters[key] != null &&
              searchController.selectedFilters[key]!.contains(option)) {
            searchController.removeFilter(key);
          } else {
            searchController.addFilter(key, option);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
