import 'package:audio_video_call_flutter_app/common/utils/date.dart';
import 'package:audio_video_call_flutter_app/common/values/colors.dart';
import 'package:audio_video_call_flutter_app/pages/frame/welcome/controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/entities/message.dart';
import 'controller.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  Widget _headBar() {
    return Center(
      child: GestureDetector(
        onTap: () {
          controller.goProfile();
        },
        child: Container(
          width: 320.w,
          height: 44.h,
          margin: EdgeInsets.only(bottom: 20.h, top: 20.h),
          child: Row(children: [
            Stack(
              children: [
                GestureDetector(
                  child: Container(
                    width: 44.h,
                    height: 44.h,
                    decoration: BoxDecoration(
                        color: AppColors.primarySecondaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(22)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 10,
                              blurRadius: 20,
                              offset: const Offset(0, 1))
                        ]),
                    child: controller.state.head_detail.value.avatar == null
                        ? Image.asset("assets/images/account_header.png")
                        : CachedNetworkImage(
                            imageUrl:
                                controller.state.head_detail.value.avatar!,
                            height: 44.w,
                            width: 44.w,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22.w),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill)),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Image(
                                  image: AssetImage(
                                      "assets/images/account_header.png"));
                            },
                          ),
                  ),
                ),
                Positioned(
                    bottom: 5.w,
                    right: 0.w,
                    height: 14.w,
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.w, color: AppColors.primaryElementText),
                          color: AppColors.primaryElementStatus,
                          borderRadius: BorderRadius.circular(12.w)),
                    ))
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget _headTabs() {
    return Center(
      child: Container(
        height: 48.h,
        width: 320.w,
        decoration: BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(4.w),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () {
              controller.goTabstatus();
            },
            child: Container(
              width: 150.w,
              height: 40.h,
              decoration: controller.state.tabstatus.value
                  ? BoxDecoration(
                      boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2))
                        ],
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(5))
                  : BoxDecoration(),
              child: Center(
                  child: Text(
                "Chat",
                style: TextStyle(
                    color: AppColors.primaryThreeElementText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.goTabstatus();
            },
            child: Container(
              width: 150.w,
              height: 40.h,
              decoration: controller.state.tabstatus.value
                  ? BoxDecoration()
                  : BoxDecoration(
                      boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2))
                        ],
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                "Call",
                style: TextStyle(
                    color: AppColors.primaryThreeElementText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp),
              )),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _chatListItem(Message item) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, left: 0.w, right: 0.w, bottom: 1.h),
      child: InkWell(
        onTap: () {
          if (item.doc_id != null) {
            Get.toNamed("/chat", parameters: {
              "doc_id": item.doc_id!,
              "to_token": item.token!,
              "to_name": item.name!,
              "to_avatar": item.avatar!,
              "to_online": item.online.toString()
            });
          }
        },
        child: Row(children: [
          Container(
            width: 44.h,
            height: 44.h,
            margin: EdgeInsets.only(right: 13.w),
            decoration: BoxDecoration(
                color: AppColors.primarySecondaryBackground,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 10,
                      blurRadius: 20,
                      offset: const Offset(0, 1))
                ]),
            child: item.avatar == null
                ? Image.asset("assets/images/account_header.png")
                : CachedNetworkImage(
                    imageUrl: item.avatar!,
                    height: 44.w,
                    width: 44.w,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.w),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill)),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Image(
                          image:
                              AssetImage("assets/images/account_header.png"));
                    },
                  ),
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 175.w,
                    height: 44.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name!,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color: AppColors.thirdElement,
                              fontSize: 14.sp),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        Text(item.last_msg!,
                            style: TextStyle(
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.normal,
                                color: Colors
                                    .black, //AppColors.primaryElementText,
                                fontSize: 12.sp),
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            softWrap: false)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 86.w,
                    height: 44.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.last_time == null
                              ? ""
                              : duTimeLineFormat(
                                  (item.last_time as Timestamp).toDate()),
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.black, // AppColors.primaryElementText,
                              fontSize: 11.sp),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        item.msg_num == 0
                            ? Container()
                            : Container(
                                padding: EdgeInsets.only(left: 4.w, right: 4.w),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "${item.msg_num}",
                                  style: TextStyle(
                                      fontFamily: "Avenir",
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .black, //AppColors.primaryElementText,
                                      fontSize: 11.sp),
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )
                      ],
                    ),
                  )
                ]),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white, // AppColors.primarySecondaryBackground,
      floatingActionButton: GestureDetector(
        onTap: () {
          Future.delayed(
              const Duration(seconds: 3), () => controller.goContactPage());
        },
        child: Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(10),
            decoration:
                const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: Image.asset("assets/icons/contact.png")),
      ),
      body: Obx(() {
        return SafeArea(
            child: Stack(
          alignment: Alignment.center,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.primarySecondaryBackground,
                  pinned: true,
                  title: _headBar(),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
                  sliver: SliverToBoxAdapter(
                    child: _headTabs(),
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
                  sliver: controller.state.tabstatus.value
                      ? SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                          var item = controller.state.msgList[index];
                          return _chatListItem(item);
                        }, childCount: controller.state.msgList.length))
                      : SliverToBoxAdapter(
                          child: Container(),
                        ),
                )
              ],
            )
          ],
        ));
      }),
    );
  }
}
