import 'dart:async';

//节流函数
Function throttle(Future Function() func){
  if(func == null){
    return null;
  }
  bool enable=true;
  Function target(){
    if(enable=true){
      enable=false;
      func().then((value) => enable=true);
    }
  }
  return target();
}