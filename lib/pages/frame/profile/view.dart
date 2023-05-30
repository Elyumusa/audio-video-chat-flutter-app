import 'package:audio_video_call_flutter_app/common/values/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primarySecondaryBackground,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      title: Text(
        "Profile",
        style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  _buildProfilePhoto() {
    return Stack(
      children: [
        Container(
          height: 120.w,
          width: 120.w,
          decoration: BoxDecoration(
              color: AppColors.primarySecondaryBackground,
              borderRadius: BorderRadius.circular(60.w),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1)),
              ]),
          child: controller.state.profile_detail.value.avatar != null
              ? CachedNetworkImage(
                  imageUrl: controller.state.profile_detail.value.avatar!,
                  height: 120.w,
                  width: 120.w,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.w),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill)),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const Image(
                        image: AssetImage("assets/images/account_header.png"));
                  },
                )
              : Image.asset(
                  "assets/images/account_header.png",
                  height: 120.h,
                  width: 120.w,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
            bottom: 5.w,
            right: 0.w,
            height: 35.w,
            child: GestureDetector(
              child: Container(
                height: 35.w,
                width: 35.w,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: AppColors.primaryElementText,
                    borderRadius: BorderRadius.circular(40.w)),
                child: Image.asset(
                  "assets/icons/edit.png",
                  color: Colors.blue,
                ),
              ),
            ))
      ],
    );
  }

  _buildCompleteBtn() {
    return GestureDetector(
      child: Container(
        height: 44.h,
        width: 295.w,
        margin: EdgeInsets.only(top: 60.h, bottom: 30.h),
        decoration: BoxDecoration(
            color: AppColors.primaryElement,
            borderRadius: BorderRadius.circular(5.w),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1)),
            ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Complete",
            style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal),
          )
        ]),
      ),
    );
  }

  _buildLogOutBtn() {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
            title: "Are you sure to Log out?",
            onConfirm: () {
              controller.goLogout();
            },
            onCancel: () {},
            content: Container(),
            confirmTextColor: Colors.white,
            textConfirm: "Confirm",
            textCancel: "Cancel");
      },
      child: Container(
        height: 44.h,
        width: 295.w,
        margin: EdgeInsets.only(top: 60.h, bottom: 30.h),
        decoration: BoxDecoration(
            color: AppColors.primaryElementText,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1)),
            ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Logout",
            style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfilePhoto(),
                  _buildCompleteBtn(),
                  _buildLogOutBtn()
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
