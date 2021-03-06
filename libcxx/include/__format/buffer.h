// -*- C++ -*-
//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP___FORMAT_BUFFER_H
#define _LIBCPP___FORMAT_BUFFER_H

#include <__algorithm/copy_n.h>
#include <__algorithm/unwrap_iter.h>
#include <__config>
#include <__format/formatter.h> // for __char_type TODO FMT Move the concept?
#include <__iterator/back_insert_iterator.h>
#include <__iterator/concepts.h>
#include <__iterator/iterator_traits.h>
#include <__iterator/wrap_iter.h>
#include <__utility/move.h>
#include <concepts>
#include <cstddef>
#include <type_traits>

#if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#  pragma GCC system_header
#endif

_LIBCPP_BEGIN_NAMESPACE_STD

#if _LIBCPP_STD_VER > 17

namespace __format {

/// A "buffer" that handles writing to the proper iterator.
///
/// This helper is used together with the @ref back_insert_iterator to offer
/// type-erasure for the formatting functions. This reduces the number to
/// template instantiations.
template <__formatter::__char_type _CharT>
class _LIBCPP_TEMPLATE_VIS __output_buffer {
public:
  using value_type = _CharT;

  template <class _Tp>
  _LIBCPP_HIDE_FROM_ABI explicit __output_buffer(_CharT* __ptr,
                                                 size_t __capacity, _Tp* __obj)
      : __ptr_(__ptr), __capacity_(__capacity),
        __flush_([](_CharT* __p, size_t __size, void* __o) {
          static_cast<_Tp*>(__o)->flush(__p, __size);
        }),
        __obj_(__obj) {}

  _LIBCPP_HIDE_FROM_ABI void reset(_CharT* __ptr, size_t __capacity) {
    __ptr_ = __ptr;
    __capacity_ = __capacity;
  }

  _LIBCPP_HIDE_FROM_ABI auto make_output_iterator() {
    return back_insert_iterator{*this};
  }

  // TODO FMT It would be nice to have an overload taking a
  // basic_string_view<_CharT> and append it directly.
  _LIBCPP_HIDE_FROM_ABI void push_back(_CharT __c) {
    __ptr_[__size_++] = __c;

    // Profiling showed flushing after adding is more efficient than flushing
    // when entering the function.
    if (__size_ == __capacity_)
      flush();
  }

  _LIBCPP_HIDE_FROM_ABI void flush() {
    __flush_(__ptr_, __size_, __obj_);
    __size_ = 0;
  }

private:
  _CharT* __ptr_;
  size_t __capacity_;
  size_t __size_{0};
  void (*__flush_)(_CharT*, size_t, void*);
  void* __obj_;
};

/// A storage using an internal buffer.
///
/// This storage is used when writing a single element to the output iterator
/// is expensive.
template <__formatter::__char_type _CharT>
class _LIBCPP_TEMPLATE_VIS __internal_storage {
public:
  _LIBCPP_HIDE_FROM_ABI _CharT* begin() { return __buffer_; }
  _LIBCPP_HIDE_FROM_ABI size_t capacity() { return __buffer_size_; }

private:
  static constexpr size_t __buffer_size_ = 256 / sizeof(_CharT);
  _CharT __buffer_[__buffer_size_];
};

/// A storage writing directly to the storage.
///
/// This requires the storage to be a contiguous buffer of \a _CharT.
/// Since the output is directly written to the underlying storage this class
/// is just an empty class.
template <__formatter::__char_type _CharT>
class _LIBCPP_TEMPLATE_VIS __direct_storage {};

template <class _OutIt, class _CharT>
concept __enable_direct_output = __formatter::__char_type<_CharT> &&
    (same_as<_OutIt, _CharT*>
#if _LIBCPP_DEBUG_LEVEL < 2
     || same_as<_OutIt, __wrap_iter<_CharT*>>
#endif
    );

/// Write policy for directly writing to the underlying output.
template <class _OutIt, __formatter::__char_type _CharT>
class _LIBCPP_TEMPLATE_VIS __writer_direct {
public:
  _LIBCPP_HIDE_FROM_ABI explicit __writer_direct(_OutIt __out_it)
      : __out_it_(__out_it) {}

  _LIBCPP_HIDE_FROM_ABI auto out() { return __out_it_; }

  _LIBCPP_HIDE_FROM_ABI void flush(_CharT*, size_t __size) {
    // _OutIt can be a __wrap_iter<CharT*>. Therefore the original iterator
    // is adjusted.
    __out_it_ += __size;
  }

private:
  _OutIt __out_it_;
};

/// Write policy for copying the buffer to the output.
template <class _OutIt, __formatter::__char_type _CharT>
class _LIBCPP_TEMPLATE_VIS __writer_iterator {
public:
  _LIBCPP_HIDE_FROM_ABI explicit __writer_iterator(_OutIt __out_it)
      : __out_it_{_VSTD::move(__out_it)} {}

  _LIBCPP_HIDE_FROM_ABI auto out() { return __out_it_; }

  _LIBCPP_HIDE_FROM_ABI void flush(_CharT* __ptr, size_t __size) {
    __out_it_ = _VSTD::copy_n(__ptr, __size, _VSTD::move(__out_it_));
  }

private:
  _OutIt __out_it_;
};

/// Selects the type of the writer used for the output iterator.
template <class _OutIt, class _CharT>
class _LIBCPP_TEMPLATE_VIS __writer_selector {
public:
  using type = conditional_t<__enable_direct_output<_OutIt, _CharT>,
                             __writer_direct<_OutIt, _CharT>,
                             __writer_iterator<_OutIt, _CharT>>;
};

/// The generic formatting buffer.
template <class _OutIt, __formatter::__char_type _CharT>
requires(output_iterator<_OutIt, const _CharT&>) class _LIBCPP_TEMPLATE_VIS
    __format_buffer {
  using _Storage =
      conditional_t<__enable_direct_output<_OutIt, _CharT>,
                    __direct_storage<_CharT>, __internal_storage<_CharT>>;

public:
  _LIBCPP_HIDE_FROM_ABI explicit __format_buffer(_OutIt __out_it) requires(
      same_as<_Storage, __internal_storage<_CharT>>)
      : __output_(__storage_.begin(), __storage_.capacity(), this),
        __writer_(_VSTD::move(__out_it)) {}

  _LIBCPP_HIDE_FROM_ABI explicit __format_buffer(_OutIt __out_it) requires(
      same_as<_Storage, __direct_storage<_CharT>>)
      : __output_(_VSTD::__unwrap_iter(__out_it), size_t(-1), this),
        __writer_(_VSTD::move(__out_it)) {}

  _LIBCPP_HIDE_FROM_ABI auto make_output_iterator() {
    return __output_.make_output_iterator();
  }

  _LIBCPP_HIDE_FROM_ABI void flush(_CharT* __ptr, size_t __size) {
    __writer_.flush(__ptr, __size);
  }

  _LIBCPP_HIDE_FROM_ABI _OutIt out() && {
    __output_.flush();
    return _VSTD::move(__writer_).out();
  }

private:
  _LIBCPP_NO_UNIQUE_ADDRESS _Storage __storage_;
  __output_buffer<_CharT> __output_;
  typename __writer_selector<_OutIt, _CharT>::type __writer_;
};
} // namespace __format

#endif //_LIBCPP_STD_VER > 17

_LIBCPP_END_NAMESPACE_STD

#endif // _LIBCPP___FORMAT_BUFFER_H
