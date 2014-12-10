library a_form_input;

import 'package:polymer/polymer.dart';
import 'dart:html' show HiddenInputElement;

class AFormInput extends PolymerElement with AFormInputMixin {
  AFormInput.created(): super.created();
}

abstract class AFormInputMixin {
  @PublishedProperty(reflect: true)
  String get name => readValue(#name);
  set name(String n) => writeValue(#name, n);

  @PublishedProperty(reflect: true)
  String get value => readValue(#value);
  set value(String v) => writeValue(#value, v);

  HiddenInputElement _lightInput;

  get parent;
  get changes;
  readValue(v);
  writeValue(n,v);

  void attached() {
    _injectHiddenInputInParent();
    _synchronizeChanges();
  }

  _injectHiddenInputInParent() {
    _lightInput = new HiddenInputElement();
    if (name != null) _lightInput.name = name;
    parent.append(_lightInput);
  }

  _synchronizeChanges() {
    changes.listen((list){
      list.forEach((change) {
        if (change.name == #name) _lightInput.name = change.newValue;
        if (change.name == #value) _lightInput.value = change.newValue;
      });
    });
  }
}
