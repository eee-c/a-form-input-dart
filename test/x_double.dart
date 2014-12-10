import 'package:polymer/polymer.dart';
import 'package:a-form-input/a_form_input.dart';

@CustomTag('x-double')
class XDouble extends PolymerElement with AFormInputMixin {
  @PublishedProperty(reflect: true)
  String start = '0';

  XDouble.created(): super.created();

  attached() {
    super.attached();

    this.doubleStart();

    changes.listen((list){
      list.forEach((change) {
        if (change.name == #start) this.doubleStart();
      });
    });
  }

  doubleStart(){
    int doubled = 2 * int.parse(start);
    value = '$doubled';
  }
}
