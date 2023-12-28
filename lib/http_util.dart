import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'package:path_provider/path_provider.dart';

///APP当前环境
class AppEnv {
  static const int DEV = 0;
  static const int TEST = 1;
  static const int RELEASE = 2;
}

Dio _http = Dio(_httpOptions);

///成功
typedef OnHttpSuccess = Function(dynamic data, {BaseModel? response});

///失败
typedef OnHttpFail = Function(BaseModel response);

const String DEV_API = 'https://wos2.58cdn.com.cn/';
const String TEST_API = 'https://wos2.58cdn.com.cn/';
const String RELEASE_API = 'https://wos2.58cdn.com.cn/';

int currentEnv = AppEnv.RELEASE;

///api地址
String get baseApiUrl {
  return currentEnv == AppEnv.RELEASE ? RELEASE_API : TEST_API;
}

BaseOptions _httpOptions = BaseOptions(
  baseUrl: baseApiUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  contentType: Headers.jsonContentType,
);

enum RequestMethod {
  POST,
  GET,
}

class HttpUtil {
  static const NET_ERROR = -1000;
  static const NET_SUCCESS = 0;
  static const LOGIN_EXPIRE = 401;
  static const OPT_PASSWD_LOCK = 5003; // 弹窗提示锁定24小时
  static const OPT_PASSWD_ERROR = 5004; // 操作密码输入错误，toast 提示
  static const OPT_PASSWD_ERROR_COLOSE = 5005; // 操作密码输入错误，最后一次关闭密码输入键盘
  static const FORCE_UPDATE = 606; // 强制更新

  static Future<BaseModel> requestGet(String? url,
      {Map<String, dynamic>? params,
      OnHttpSuccess? success,
      OnHttpFail? fail,
      Map<String, dynamic>? headers,
      bool usePath = true}) async {
    return await _requestHttp(url ?? "",
        params: params,
        method: RequestMethod.GET,
        success: success,
        fail: fail,
        headers: headers,
        usePath: usePath);
  }

  static Future<BaseModel> requestPost(String? url,
      {Map<String, dynamic>? params,
      OnHttpSuccess? success,
      OnHttpFail? fail,
      Map<String, dynamic>? headers,
      bool usePath = false}) async {
    return await _requestHttp(url ?? '',
        params: params,
        method: RequestMethod.POST,
        success: success,
        fail: fail,
        headers: headers,
        usePath: usePath);
  }

  static Future<BaseModel> _requestHttp(String url,
      {Map<String, dynamic>? params,
      RequestMethod? method,
      OnHttpSuccess? success,
      OnHttpFail? fail,
      bool usePath = false,
      String fileKey = 'multipart',
      Map<String, dynamic>? headers,
      String? filePath}) async {
    Response? response;
    BaseModel baseModel;
    dynamic callback;

    try {
      if (method == RequestMethod.POST) {
        ///上传图片
        if (filePath?.isNotEmpty == true) {
          Map<String, dynamic> sParams = {
            fileKey: await MultipartFile.fromFile(
              filePath!,
              filename: 'image.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          };
          if (params != null) {
            sParams.addAll(params);
          }
          FormData formData = FormData.fromMap(sParams);
          response = await _http.post(url,
              data: formData, options: Options(headers: headers));
        } else {
          if (usePath) {
            response = await _http.post(url,
                queryParameters: params, options: Options(headers: headers));
          } else {
            response = await _http.post(url,
                data: params, options: Options(headers: headers));
          }
        }
      } else {
        response = await _http.get(url,
            queryParameters: params, options: Options(headers: headers));
      }
      var data = response.data;
      if (data is String) {
        try {
          data = jsonDecode(response.data);
        } catch (e) {
          print(e);
        }
      }
      if (data is Map<String, dynamic>) {
        baseModel = BaseModel.fromJson(data);
        if (baseModel.code == NET_SUCCESS) {
          //成功
          callback = success?.call(baseModel.data, response: baseModel);
        } else {
          if (baseModel.code == FORCE_UPDATE) {
            callback = fail?.call(baseModel);
          } else {
            callback = fail?.call(baseModel);
          }
        }
      } else {
        baseModel = BaseModel(message: "返回数据有误");
        callback = fail?.call(baseModel);
      }
    } catch (e) {
      print(e);
      String msg = "";
      if (e is DioError) {
        msg = e.message ?? "";
        // msg = GlobalConfig.inProduction ? "服务器开小差，请稍后重试" : e.message;
      } else {
        // msg = GlobalConfig.inProduction ? "服务器开小差，请稍后重试" : e.toString();
      }
      baseModel = BaseModel(message: msg);
      callback = fail?.call(baseModel);
    }
    if (callback is Future) {
      await callback;
    }

    if (baseModel.code == LOGIN_EXPIRE) {
    } else if (baseModel.code == OPT_PASSWD_LOCK) {}

    return baseModel;
  }

  static void requestNetworks(Iterable<Future> futures, {Function? onDone}) {
    Future.wait(futures).catchError((e) {
      print(e);
    }).whenComplete(() {
      onDone?.call();
    });
  }

  static Future<BaseModel> postFile(String? url,
      {required String filePath,
      String? fileKey,
      Map<String, dynamic>? params,
      OnHttpSuccess? success,
      OnHttpFail? fail}) async {
    return await _requestHttp(url ?? '',
        method: RequestMethod.POST,
        fileKey: fileKey ?? 'multipart',
        params: params,
        success: success,
        fail: fail,
        filePath: filePath);
  }

  static Future download(
    String? url, {
    String? savePath,
    Map<String, dynamic>? params,
    void Function(int, int, String)? onReceiveProgress,
  }) async {
    try {
      if (savePath == null) {
        var tempDir = await getTemporaryDirectory();
        savePath = tempDir.path;
      }

      return await _http.download(
        url ?? '',
        savePath + Platform.pathSeparator + "11.apk",
        queryParameters: params,
        onReceiveProgress: (int count, int total) {
          onReceiveProgress?.call(count, total, savePath!);
        },
      );
    } on DioError catch (e) {
      // ToastUtil.toast(msg: "下载失败请重试");
    } on Exception catch (e) {
      // ToastUtil.toast(msg: "下载失败请重试");
    }
  }

  ///初始化网络配置
  static Future<void> initHttpConfig() async {
    ///设置网络代理
    var systemProxy = await getSystemProxy();
    HttpOverrides.global = _HttpOverrides(systemProxy, isProduction: true);

    ///设置dio回调
    _http.interceptors.clear();
  }

  ///获取手机系统代理
  static Future<String?> getSystemProxy() async {
    String? systemProxy;
    try {
      ProxySetting settings = await NativeProxyReader.proxySetting;
      var host = settings.host;
      var port = settings.port;
      if (host != null) {
        systemProxy = '$host:$port';
      }
    } catch (e) {
      print(e);
    }

    return systemProxy;
  }
}

class _HttpOverrides extends HttpOverrides {
  String? systemProxy;

  ///是否是线上生产环境,该环境由native端获取
  bool isProduction;

  _HttpOverrides(this.systemProxy, {this.isProduction = false});

  final String PROXY_DIRECT = "DIRECT";

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    var createHttpClient = super.createHttpClient(context);
    if (!isProduction) {
      ///设置非生产环境https证书不校验
      createHttpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
    return createHttpClient;
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    String proxy = PROXY_DIRECT;

    ///生产环境不使用代理
    if (!isProduction && systemProxy?.isNotEmpty == true) {
      proxy = "PROXY $systemProxy;$PROXY_DIRECT";
    }
    return proxy;
  }
}

class BaseModel {
  int code = HttpUtil.NET_ERROR;
  String message = "";
  dynamic data;

  BaseModel({this.code = HttpUtil.NET_ERROR, this.message = "", this.data});

  BaseModel.fromJson(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      code = int.tryParse(
              responseData["errorCode"]?.toString() ?? '${HttpUtil.NET_ERROR}') ??
          HttpUtil.NET_ERROR;
      message = responseData["errorMsg"]?.toString() ?? '';
      data = responseData["data"];
    }
  }
}
