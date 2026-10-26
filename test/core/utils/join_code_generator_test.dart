import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/core/utils/join_code_generator.dart';

void main() {
  group('JoinCodeGenerator', () {
    test('should generate a code of default length 6', () {
      final code = JoinCodeGenerator.generate();
      expect(code.length, 6);
    });

    test('should generate a code of specified custom length', () {
      final code8 = JoinCodeGenerator.generate(length: 8);
      expect(code8.length, 8);

      final code4 = JoinCodeGenerator.generate(length: 4);
      expect(code4.length, 4);
    });

    test('should only contain characters from allowed safe character set', () {
      for (int i = 0; i < 50; i++) {
        final code = JoinCodeGenerator.generate();
        for (int j = 0; j < code.length; j++) {
          final char = code[j];
          expect(
            JoinCodeGenerator.allowedCharacters.contains(char),
            isTrue,
            reason: 'Character $char is not in the allowed character set',
          );
        }
      }
    });

    test('should NEVER contain ambiguous characters (0, O, 1, I)', () {
      const ambiguous = ['0', 'O', '1', 'I'];
      for (int i = 0; i < 100; i++) {
        final code = JoinCodeGenerator.generate();
        for (final amb in ambiguous) {
          expect(
            code.contains(amb),
            isFalse,
            reason: 'Code $code should not contain ambiguous character $amb',
          );
        }
      }
    });

    test('should generate varied/random codes across consecutive calls', () {
      final codeSet = <String>{};
      for (int i = 0; i < 50; i++) {
        codeSet.add(JoinCodeGenerator.generate());
      }
      // With 31^6 permutations, 50 random samples should be unique
      expect(codeSet.length, 50);
    });
  });
}
