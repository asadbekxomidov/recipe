import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterWidget extends StatefulWidget {
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onTimeSelected;
  final String initialCategory;
  final String initialTime;

  SearchFilterWidget({
    required this.onCategorySelected,
    required this.onTimeSelected,
    required this.initialCategory,
    required this.initialTime,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final List<String> categories = [
    'All',
    'Nonushta',
    'Shirinlik',
    'Kechki ovqat',
    'Salat',
    'Tushlik',
  ];

  late String selectedCategory;
  late String selectedTime;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      height: 600.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.r),
          topRight: Radius.circular(50.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Filter Search',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.h,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Time',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.h,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 10.w,
            children: ['All', 'Newest', 'Oldest', 'Popularity'].map((time) {
              return ChoiceChip(
                label: Text(
                  time,
                  style: TextStyle(
                    fontSize: 12.h,
                    color: Colors.black,
                  ),
                ),
                selected: selectedTime == time,
                onSelected: (_) {
                  setState(() {
                    selectedTime = time;
                  });
                  widget.onTimeSelected(time);
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),
          Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.h,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: categories.map((category) {
              return ChoiceChip(
                label: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12.h,
                    color: Colors.black,
                  ),
                ),
                selected: selectedCategory == category,
                onSelected: (_) {
                  setState(() {
                    selectedCategory = category;
                  });
                  widget.onCategorySelected(category);
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = 'All';
                    selectedTime = 'All';
                  });
                  widget.onCategorySelected('All');
                  widget.onTimeSelected('All');
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45.h,
                  width: 150.w,

                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'Clear Filter',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
