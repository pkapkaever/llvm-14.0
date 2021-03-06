//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <vector>

// pop_back() more than the number of elements in a vector

// UNSUPPORTED: c++03, windows
// UNSUPPORTED: use_system_cxx_lib && target={{.+}}-apple-macosx{{10.9|10.10|10.11|10.12|10.13|10.14|10.15|11|12}}
// ADDITIONAL_COMPILE_FLAGS: -D_LIBCPP_ENABLE_ASSERTIONS=1

#include <vector>

#include "check_assertion.h"

int main(int, char**) {
    std::vector<int> v;
    v.push_back(0);
    v.pop_back();
    TEST_LIBCPP_ASSERT_FAILURE(v.pop_back(), "vector::pop_back called on an empty vector");

    return 0;
}
