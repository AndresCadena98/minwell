 class MyToastModel {
  final String message;
  final ToastType type;

  MyToastModel(this.message, this.type);
  
  }
  
  class ToastType {
    final String name;
    const ToastType(this.name);
    static const success = ToastType('success');
    static const favoriteSuccess = ToastType('favoriteSuccess');
    static const error = ToastType('error');
    static const warning = ToastType('warning');
    static const info = ToastType('info');
  }