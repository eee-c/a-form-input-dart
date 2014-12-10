library plain_old_forms_test;

import 'package:unittest/unittest.dart';
import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

createElement(String html) =>
  new Element.html(html, treeSanitizer: new NullTreeSanitizer());

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(node) {}
}

main() {
  initPolymer();

  var _el, _form, _container;
  group("AFormInputMixin mixed into <x-double>", (){
    setUp((){
      _container = createElement('<div></div>');
      _form = createElement('<form></form>');
      _el = createElement('<x-double></x-double>');

      _form.append(_el);
      _container.append(_form);
      document.body.append(_container);
    });

    tearDown((){
      _container.remove();
    });

    test('has a shadowRoot', (){
      expect(
        query('x-double').shadowRoot,
        isNotNull
      );
    });


    group('acts like <input> -', (){
      setUp((){
        _el.name = 'my_field_name';
        _el.start = '21';

        var completer = new Completer();
        _el.async(completer.complete);
        return completer.future;
      });

      test('value property is updated when internal state changes', (){
        expect(_el.value, '42'); // Doubled by <x-double>
      });

      test('value attribute is updated when internal state changes', (){
        expect(_el.getAttribute('value'), '42');
      });

      test('form value attribute is updated when internal state changes', (){
        var inputValues = _form.
          children.
          where((i)=> i.tagName == 'INPUT').
          map((i)=> i.value);
        expect(inputValues.first, '42');
      });

      test('containing form includes input with supplied name attribute', (){
        var inputNames = _form.
          children.
          where((i)=> i.tagName == 'INPUT').
          map((i)=> i.name);
        expect(inputNames, contains('my_field_name'));
      });

      test('setting the name property updates the name attribute', (){
        _el.name = 'new_field_name';

        _test(_){
          var inputNames = _form.
            children.
            where((i)=> i.tagName == 'INPUT').
            map((i)=> i.name);
          expect(inputNames, contains('new_field_name'));
        }

        _el.async(expectAsync(_test));
      });
    });

  });

  pollForDone(testCases);
}


pollForDone(List tests) {
  if (tests.every((t)=> t.isComplete)) {
    window.postMessage('dart-main-done', window.location.href);
    return;
  }

  var wait = new Duration(milliseconds: 100);
  new Timer(wait, ()=> pollForDone(tests));
}
