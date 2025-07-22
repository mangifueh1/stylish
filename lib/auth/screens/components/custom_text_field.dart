import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StylishInput extends StatefulWidget {
  const StylishInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.fontSize,
    this.isPassword = false,
  });
  final TextEditingController controller;
  final String hintText;
  final Widget? icon;
  final double? fontSize;
  final bool? isPassword;

  @override
  State<StylishInput> createState() => _StylishInputState();
}

class _StylishInputState extends State<StylishInput> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 47.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade400, width: 2.0),
      ),
      child: Center(
        child: TextField(
          obscureText: widget.isPassword! ? _obscureText : false,
          controller: widget.controller,
          style: TextStyle(
            fontSize: widget.fontSize ?? 14.sp,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
          decoration: InputDecoration(
            suffixIcon:
                widget.isPassword!
                    ? IconButton(
                      iconSize: 20.r,
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : null,
            icon: widget.icon,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
              fontFamily: 'Montserrat',
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
