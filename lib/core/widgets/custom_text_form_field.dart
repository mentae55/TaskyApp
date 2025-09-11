import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final double? width;
  final double height;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.validator,
    this.width,
    this.height = 58,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final _formKey = GlobalKey<FormState>();

  bool validate() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20.sp),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: TextFormField(
              controller: widget.controller,
              style: TextStyle(color: theme.colorScheme.onSurface),
              validator: widget.validator,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: theme.textTheme.titleMedium,
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: isDark ? const Color(0xFF6D6D6D) : Colors.grey[600],
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
