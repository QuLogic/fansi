library(unitizer)
library(fansi)

unitizer_sect("term_cap_test", {
  tct <- term_cap_test()
  tct
  fansi_lines(LETTERS, step=6)
})
unitizer_sect("digits", {
  ints <- c(-100L, -9999L, -1L, 0L, 1L, 9L, 10L, 99L, 100L, 101L, 9999L)
  cbind(
    ints,
    fansi:::digits_in_int(ints)
  )
})
unitizer_sect("add_int", {
  fansi:::add_int(1, 1)
  fansi:::add_int(2^31 - 1, 1)
  fansi:::add_int(2^31 - 1, 0)
  fansi:::add_int(-2^31 + 1, 0)
  fansi:::add_int(-2^31 + 1, -1)
})
unitizer_sect("unhandled", {
  # example
  string.0 <- c(
    "\033[41mhello world\033[m", "foo\033[22>m", "\033[999mbar",
    "baz \033[31#3m", "a\033[31k", "hello\033m world"
  )
  unhandled_ctl(string.0)
  # some more interesting cases
  string.1 <- c(
    "foo\033[22>mhello\033[9999m", "a\033[31k", "hello\033m world \033"
  )
  unhandled_ctl(string.1)

  # A malformed ESCape

  unhandled_ctl("hello\033\033\033[45p wor\ald")
})
unitizer_sect("strtrim", {
  strtrim_ctl(" hello world", 7)
  strtrim_ctl("\033[42m hello world\033[m", 7)
  strtrim_ctl(" hello\nworld", 7)
  strtrim_ctl("\033[42m hello\nworld\033[m", 7)
  strtrim_ctl("\nhello\nworld", 7)
  strtrim_ctl("\033[42m\nhello\nworld\033[m", 7)
  strtrim_ctl("\thello\rworld foobar", 12)
  strtrim_ctl("\033[42m\thello\rworld\033[m foobar", 12)

  strtrim2_ctl("\033[42m\thello world\033[m foobar", 12, tabs.as.spaces=TRUE)
})
unitizer_sect("C funs", {
  fansi:::cleave(1:10)
  fansi:::cleave(1:9)
  fansi:::cleave(1:10 + .1)

  # sort_chr doesn't guarantee that things will be sorted lexically, just that
  # alike things will be contiguous

  set.seed(42)
  jumbled <- as.character(rep(1:10, 10))[sample(1:100)]
  sorted <- fansi:::sort_chr(jumbled)

  which(as.logical(diff(as.numeric(sorted))))
})
