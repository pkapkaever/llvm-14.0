//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <string>

// Call front() on empty const container.

// UNSUPPORTED: c++03, windows
// UNSUPPORTED: use_system_cxx_lib && target={{.+}}-apple-macosx{{10.9|10.10|10.11|10.12|10.13|10.14|10.15|11|12}}
// ADDITIONAL_COMPILE_FLAGS: -D_LIBCPP_ENABLE_ASSERTIONS=1

#include <string>

#include "check_assertion.h"
#include "min_allocator.h"

int main(int, char**) {
  {
    typedef std::string S;
    const S s;
    TEST_LIBCPP_ASSERT_FAILURE(s.front(), "string::front(): string is empty");
  }

  {
    typedef std::basic_string<char, std::char_traits<char>, min_allocator<char> > S;
    const S s;
    TEST_LIBCPP_ASSERT_FAILURE(s.front(), "string::front(): string is empty");
  }

  return 0;
}
