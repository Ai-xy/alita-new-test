import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/enum/vip_level.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'wallet_controller.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            // backgroundColor: Colors.transparent,
            // automaticallyImplyLeading: false,
            title: Text(
          'Get coins',
        )),
        // actions: [],
        // centerTitle: true,
        // elevation: 0,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 80.w,
                decoration: BoxDecoration(
                  // color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/diamondBG.png',
                    ).image,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(34, 19, 0, 19),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        'assets/images/diamond.png',
                        width: 42.w,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          '222',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.symmetric(vertical: 15.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: FlutterFlowTheme.of(context).secondaryBackground,
                  color: AppColor.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 13, 0, 13),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/diamond.png',
                            width: 32,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              '1111',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(1, 19, 0, 19),
                      child: Text(
                        'New user only',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF989898),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 11, 12, 11),
                        child: Container(
                          width: 78,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFF202020),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: AlignmentDirectional(0, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: '999',
                                  style: TextStyle(),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
  }
}
