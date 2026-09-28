import 'package:flutter_test/flutter_test.dart';
import 'package:sarco_care/l10n/speech_text.dart';

void main() {
  test('speaks the title and each paragraph as its own utterance', () {
    expect(
      speechUtterances(
        title: 'Overview',
        paragraphs: ['First para.', 'Second para.'],
        isThai: false,
      ),
      ['Overview', 'First para.', 'Second para.'],
    );
  });

  test('drops Latin asides from Thai text, which Thai voices mangle', () {
    expect(
      speechUtterances(
        title: 'ภาพรวม',
        paragraphs: ['ภาวะมวลกล้ามเนื้อน้อย (Sarcopenia) คือการสูญเสียมวล'],
        isThai: true,
      ).last,
      'ภาวะมวลกล้ามเนื้อน้อย คือการสูญเสียมวล',
    );
  });

  test('keeps Latin asides in English text', () {
    expect(
      speechUtterances(
        title: 'Overview',
        paragraphs: ['Muscle loss (sarcopenia) is gradual.'],
        isThai: false,
      ).last,
      'Muscle loss (sarcopenia) is gradual.',
    );
  });

  test('joins the Thai repetition mark onto the word it repeats', () {
    expect(
      speechUtterances(
        title: 'ภาพรวม',
        paragraphs: ['นิสัยเล็ก ๆ ที่ทำสม่ำเสมอ'],
        isThai: true,
      ).last,
      'นิสัยเล็กๆ ที่ทำสม่ำเสมอ',
    );
  });

  test('turns dashes and middle dots into a pause', () {
    expect(
      speechUtterances(
        title: 'Overview',
        paragraphs: ['Tasks — standing up, stairs — feel harder.'],
        isThai: false,
      ).last,
      'Tasks, standing up, stairs, feel harder.',
    );
  });

  test('skips empty paragraphs', () {
    expect(
      speechUtterances(title: 'Overview', paragraphs: ['', '  '], isThai: false),
      ['Overview'],
    );
  });
}
