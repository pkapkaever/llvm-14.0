// RUN: %check_clang_tidy %s misc-misleading-bidirectional %t

void func(void) {
  int admin = 0;
  /*‮ }⁦if(admin)⁩ ⁦ begin*/
  // CHECK-MESSAGES: :[[#@LINE-1]]:3: warning: comment contains misleading bidirectional Unicode characters [misc-misleading-bidirectional]
  const char msg[] = "‮⁦if(admin)⁩ ⁦tes";
  // CHECK-MESSAGES: :[[#@LINE-1]]:22: warning: string literal contains misleading bidirectional Unicode characters [misc-misleading-bidirectional]
}

void all_fine(void) {
  char valid[] = "some‮valid‬sequence";
  /* EOL ends bidi‮ sequence
   * end it's fine to do so.
   * EOL ends ⁧isolate too
   */
}

int invalid_utf_8(void) {
  bool isAdmin = false;

  // the comment below contains an invalid utf8 character, but should still be
  // processed.

  // CHECK-MESSAGES: :[[#@LINE+1]]:3: warning: comment contains misleading bidirectional Unicode characters [misc-misleading-bidirectional]
  /*‮ } ⁦if (isAdmin)⁩ ⁦ begin admins only */
  return 1;
  /* end admins only ‮ { ⁦*/
  // CHECK-MESSAGES: :[[#@LINE-1]]:3: warning: comment contains misleading bidirectional Unicode characters [misc-misleading-bidirectional]
  return 0;
}

// CHECK-MESSAGES: :[[#@LINE+1]]:19: warning: string literal contains misleading bidirectional Unicode characters [misc-misleading-bidirectional]
char invalid1[] = "‮⁦‬⁩";

// Test that segment and paragraph separator correctly reset the state
char valid1[] = R"||(‮
‮ ‮‮)||";

