import 'dart:convert';

import 'package:app/base/AdminRequest.dart';
import 'package:app/base/entity/IwaAddress.dart';
import 'package:app/base/entity/IwaGoodsDetail.dart';
import 'package:app/base/entity/IwaMall.dart';
import 'package:app/base/entity/IwaMallDataFormat.dart';
import 'package:app/base/entity/IwaOrder.dart';
import 'package:app/base/util/Paged.dart';
import 'package:app/base/util/Result.dart';
import 'package:dio/dio.dart';

class IwaMallApis {
  //获取首页信息
  static Future<IwaResult<IwaMall>> getHomeData(
    int pageIndex, int pageSize) async {
    try {
      Response response = await apiRequest.get("/mall/home", queryParameters: {
        'pageIndex': pageIndex,
        'pageSize': pageSize,
      });
      IwaResult<IwaMall> entity = IwaResult.fromJson(response.data,(data) =>IwaMall.fromJson(data));

      return entity;
      } on DioError catch (err) {
        return IwaResult(name: err.type.toString(), message: err.message);
    }
  }

  //获取订单详情
  static Future<IwaResult<IwaGoodsDetail>> getDetail(int id) async {
    try {
      Response response = await apiRequest.get("/mall/detail",queryParameters:{
        "id":id
      });
      IwaResult<IwaGoodsDetail> entity = IwaResult.fromJson(response.data,(data) =>IwaGoodsDetail.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return IwaResult(name: err.type.toString(), message: err.message);
    }
  }


  //订单提交
  static Future<String> submitOrder(
      int areaId,List goods,String phone, String remark) async {
    try {
      FormData formData =  FormData.fromMap({
        "areaId": areaId,
        "gid": goods[0].id,
        "num": goods[0].quantity,
        "phone": phone,
        "deductPoint": goods[0].quantity*goods[0].pointPrice,
        "remark": remark,
      });
      Response response = await apiRequest.post("/mall/pointBuy", data: formData);
      // IwaResult<String> entity = IwaResult.fromJson(response.data);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "err";
    }
  }

  //新增地址
  static Future<String> addAddress(String phone,IwaAddress address) async {
    try {
      FormData formData =  FormData.fromMap({
        "phone":phone,
        "nickname":address.name,
        "tel":address.phone,
        "province":address.province,
        "city":address.city,
        "area":address.area,
        "address":address.street,
        "isdefault":address.isDefault?2:1
      });
      Response response = await apiRequest.post("/mall/addAddress", data: formData);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "err";
    }
  }

  //编辑地址
  static Future<String> editAddress(String phone,IwaAddress address) async {
    try {
      FormData formData =  FormData.fromMap({
        "phone":phone,
        "id":address.id,
        "nickname":address.name,
        "tel":address.phone,
        "province":address.province,
        "city":address.city,
        "area":address.area,
        "address":address.street,
        "isdefault":address.isDefault?2:1
      });
      Response response = await apiRequest.put("/mall/editAddress", data: formData);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "err";
    }
  }

  //删除地址
  static Future<String> deleteAddress(String phone,int id) async {
    try {
      FormData formData =  FormData.fromMap({
        "phone":phone,
        "id":id,
      });
      Response response = await apiRequest.delete("/mall/delAddress", data: formData);
      return response.data["data"].toString();
    } on DioError catch (err) {
      return "err";
    }
  }

  //获取最近使用地址
  static Future<IwaResult<IwaAddress>> getRecentAddress(String phone) async {
    try {
      Response response = await apiRequest.get("/mall/recentUsed",queryParameters: {
        "phone":phone
      });
      IwaResult<IwaAddress> entity = IwaResult.fromJson(response.data,(data)=>IwaAddress.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return IwaResult(name: err.type.toString(), message: err.message);
    }
  }

  //获取地址列表
  static Future<IwaResult<IwaFormat>> getAddressList(String phone) async {
    try {
      Response response = await apiRequest.get("/mall/addressList",queryParameters: {
        "phone":phone
      });
      IwaResult<IwaFormat> entity = IwaResult.fromJson(response.data,(data)=>IwaFormat.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return IwaResult(name: err.type.toString(), message: err.message);
    }
  }

  //获取订单列表
  static Future<IwaResult<IwaOrder>> getOrderList(String phone,int type, int pageSize,int pageIndex) async {
    try {
      Response response = await apiRequest.get("/mall/orderList",queryParameters: {
        "phone":phone,
        "type":type,
        "pageSize":pageSize,
        "pageIndex":pageIndex
      });
      IwaResult<IwaOrder> entity = IwaResult.fromJson(response.data,(data)=>IwaOrder.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return IwaResult(name: err.type.toString(), message: err.message);
    }
  }

  //获取订单详情
  static Future<IwaResult<IwaAddress>> getOrderDetail(int id) async {
    try {
      Response response = await apiRequest.get("/mall/orderDetail",queryParameters: {
        "id":id
      });
      IwaResult<IwaAddress> entity = IwaResult.fromJson(response.data,(data)=>IwaAddress.fromJson(data));
      return entity;
    } on DioError catch (err) {
      return IwaResult(name: err.type.toString(), message: err.message);
    }
  }

  //确认收货
  static Future<String> receive(int id) async {
    try {
      Response response = await apiRequest.post("/mall/receive",queryParameters: {
        "id":id
      });
      return response.data["data"].toString();
    } on DioError catch (err) {
      return 'err';
    }
  }
}