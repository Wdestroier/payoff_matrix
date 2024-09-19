import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InlineEditableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const InlineEditableText(
    this.text, {
    this.style,
    this.onSubmitted,
    this.keyboardType,
    this.inputFormatters,
    super.key,
  });

  @override
  State<InlineEditableText> createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<InlineEditableText> {
  var _isEditing = false;
  final _focusNode = FocusNode();
  late String _text = widget.text;
  late final TextStyle? _style = widget.style;
  late TextEditingController _controller;
  String initialText = '';

  @override
  void initState() {
    _controller = TextEditingController(text: _text);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _isEditing = false);
      } else {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    saveChanges(String changedText) {
      try {
        widget.onSubmitted?.call(changedText);
        setState(() {
          _text = changedText;
          _isEditing = false;
        });
      } catch (_) {
        _controller.text = _text;
        rethrow;
      }
    }

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          _focusNode.unfocus();
          _controller.text = initialText;
        }
      },
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            _isEditing = !_isEditing;
            if (_isEditing) {
              initialText = _controller.text;
              _focusNode.requestFocus();
            }
          });
        },
        child: TextField(
          onTapOutside: (_) {
            _focusNode.unfocus();
            saveChanges(_controller.text);
          },
          textAlign: TextAlign.center,
          maxLines: 1,
          style: _style,
          controller: _controller,
          focusNode: _focusNode,
          onSubmitted: saveChanges,
          showCursor: _isEditing,
          cursorColor: Colors.black,
          enableInteractiveSelection: _isEditing,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 4.4,
            ),
            border: _isEditing
                ? const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )
                : InputBorder.none,
          ),
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
        ),
      ),
    );
  }
}
