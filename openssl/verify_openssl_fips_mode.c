#include <openssl/err.h>
#include <string.h>
  
/* This program checks the ability to set a FIPS mode, effectively·
 * ensuring that we have a FIPS-compliant OpenSSL implementation
 */
int main() {
  ERR_load_crypto_strings();

  int fips_compatible_build = -1;
  if ((fips_compatible_build = FIPS_mode()) == 0) {
    printf("[FAIL] The current version of OpenSSL is not FIPS-capable!\n");
    /* Error "0F06D065" indicates no FIPS capability */
    ERR_print_errors_fp(stderr);
    exit(1);
  }

  if (!FIPS_mode_set(1)) {
    printf("[FAIL] Error initializing FIPS mode!\n");
    ERR_print_errors_fp(stderr);
    exit(1);
  }

  printf("[ OK ] Installed library has FIPS support!\n");
  return 0;
}
