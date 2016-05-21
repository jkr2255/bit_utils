require "mkmf"

have_func('__builtin_popcountl(1)')
have_func('rb_absint_numwords')
have_func('rb_big_pack')
have_func('rb_integer_pack')
have_func('rb_big_xor')
have_header('cpuid.h') && have_func('__get_cpuid', 'cpuid.h')
check_sizeof('long')
check_sizeof('long long')
message 'checking for usability of POPCNT in GCC-style inline assembler... '
gcc_popcount = try_compile <<SRC
int main(){
  long a=1, b=2;
  __asm__ volatile ("POPCNT %1, %0;"
                    :"=r"(b)
                    :"r"(a)
                    :
                   );
  return 0;
}
SRC
if gcc_popcount
  message "yes\n"
  $defs << '-DHAVE_POPCNT_GCC_ASM'
  message 'checking for usability of POPCNT for long long in GCC-style inline assembler... '
  gcc_ll_popcount = try_compile <<SRC
int main(){
  long long a=1, b=2;
  __asm__ volatile ("POPCNT %1, %0;"
                    :"=r"(b)
                    :"r"(a)
                    :
                   );
  return 0;
}
SRC
  if gcc_ll_popcount
    message "yes\n"
    $defs << '-DHAVE_POPCNT_LL_GCC_ASM'
  else
    message "no\n"
  end
else
  message "no\n"
end

have_func('__builtin_ctzl(1)')

create_makefile("bit_utils/bit_utils")
