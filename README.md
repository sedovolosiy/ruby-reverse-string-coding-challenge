# 🧠 Ruby Coding Challenge

Let’s put your Ruby skills to the test!

Write a method that takes a string, reverses it manually, and returns the result. Don’t use built-in methods like `String#reverse` or `String#reverse!`. You can use standard library methods like `String#length`.

### Example Method Signature

```ruby
def my_reverse(string)
  # your code here
end

puts my_reverse('abc') # => "cba"
```

### Challenge

❓ What would your implementation look like? Drop your solution in the comments and explain your approach. You don’t need to optimize it — just show us your cleanest thinking!

Let’s see how creative and elegant your Ruby can be.

**Ready, set, reverse!**

---

### Implementations and Benchmark Results

Below are the implementations and their benchmark results for reversing a string manually:

#### Implementations

1. **fernando_melo_cunha_reverse_str**
   - Uses a loop to append characters from the end of the string to a new string.

2. **berfy_kunsangabo_web_reverse_str**
   - Implements a recursive approach to reverse the string.

3. **serhii_s_b6b528a1_reverse_str**
   - Uses a `while` loop to append characters from the end of the string to a new string.

4. **jess_alejo_prepend_reverse_str**
   - Uses `String#prepend` to build the reversed string by prepending each character.

5. **jess_alejo_reduce_reverse_str**
   - Uses `Enumerable#reduce` to reverse the string by concatenating characters in reverse order.

#### Benchmark Results

The benchmark results for short, medium, and long strings are as follows:

**Short Strings:**
- `serhii_s_b6b528a1_reverse_str`: 0.000004 seconds
- `berfy_kunsangabo_web_reverse_str`: 0.000005 seconds
- `jess_alejo_prepend_reverse_str`: 0.000005 seconds
- `jess_alejo_reduce_reverse_str`: 0.000007 seconds
- `fernando_melo_cunha_reverse_str`: 0.000013 seconds

**Medium Strings:**
- `serhii_s_b6b528a1_reverse_str`: 0.000084 seconds
- `fernando_melo_cunha_reverse_str`: 0.000115 seconds
- `jess_alejo_prepend_reverse_str`: 0.000136 seconds
- `jess_alejo_reduce_reverse_str`: 0.000201 seconds
- `berfy_kunsangabo_web_reverse_str`: 0.000364 seconds

**Long Strings:**
- `serhii_s_b6b528a1_reverse_str`: 0.076065 seconds
- `fernando_melo_cunha_reverse_str`: 0.109563 seconds
- `jess_alejo_prepend_reverse_str`: 5.989687 seconds
- `jess_alejo_reduce_reverse_str`: 26.691096 seconds

---

### Observations

- The `serhii_s_b6b528a1_reverse_str` implementation is the fastest across all string sizes.
- Recursive approaches like `berfy_kunsangabo_web_reverse_str` may encounter stack level issues for very long strings.
- Methods using `String#prepend` or `Enumerable#reduce` are significantly slower for long strings due to their higher computational complexity.

---

Check out the original LinkedIn post for this challenge [here](https://www.linkedin.com/feed/update/urn:li:activity:7326692494572761089?utm_source=share&utm_medium=member_desktop&rcm=ACoAABWc6oMBiuwv2plRUS-i9qym3gm0c59VD7s).
