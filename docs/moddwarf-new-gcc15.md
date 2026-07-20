# moddwarf-new-gcc15

## Rationale

This target adds a GCC 15 variant for MOD Dwarf New while preserving the existing `moddwarf-new` runtime baseline as much as possible.

Goals:
- keep the same target architecture as `moddwarf-new`
- keep `glibc 2.27`
- keep Linux headers `4.4.302`
- keep `buildroot-2016.02`
- minimize invasive changes
- use GCC 15 for plugin builds
- prefer static `libstdc++` and `libgcc` while keeping glibc dynamic

## Repository changes

Added:
- `toolchain/moddwarf-new-gcc15.config`
- `plugins-dep/configs/moddwarf-new-gcc15_defconfig`
- `patches/crosstool-ng-1.28.0/glibc-2.27/0003-skip-getrandom-syscall.patch`
- `patches/crosstool-ng-1.28.0/glibc-2.27-dwarf/0004-non-optimized-memset.patch`

Updated:
- `.common`
- `bootstrap.sh`

## Current toolchain strategy

The new target uses:
- `crosstool-ng-1.28.0`
- `gcc 15.2.0`
- `glibc 2.27`
- Linux headers `4.4.302`
- `buildroot-2016.02`

This keeps the MOD Dwarf New ABI baseline close to the existing target while using a newer crosstool-NG release to access GCC 15 support.

## Buildroot constraints

`buildroot-2016.02` remains in use for the target defconfig and package set.
The external toolchain definition switches from GCC 9 to GCC 15 while keeping:
- external glibc
- aarch64 / cortex-a35
- Linux 4.4 headers

No Buildroot upgrade is introduced by this initial target definition.

## GCC 15 constraints

The main compatibility change in the Buildroot external toolchain config is:
- `BR2_TOOLCHAIN_EXTERNAL_GCC_15=y`

To match the historical static-toolchain approach where appropriate, linker flags were updated to:
- `-static-libstdc++ -static-libgcc`

This keeps `glibc` dynamic while statically linking the GCC runtime pieces.

## ct-ng 1.28 + glibc 2.27 patch integration

The original `moddwarf-new` target under ct-ng 1.25.0 relied on:
- a glibc 2.27 getrandom syscall compatibility patch
- a Dwarf-specific memset patch

Those patches were not initially wired into the ct-ng 1.28.0 bootstrap path.
They have now been carried forward for `moddwarf-new-gcc15` by adding:
- generic glibc 2.27 patch copy logic for ct-ng 1.28.0
- Dwarf-specific glibc 2.27 patch copy logic for `moddwarf-new-gcc15`

## Compatibility notes

This target is intended to remain compatible with MOD Dwarf New by preserving:
- `aarch64`
- `cortex-a35`
- `glibc 2.27`
- Linux headers `4.4.302`

Further validation is still required for:
- full toolchain build
- full plugin package build
- `neural-amp-modeler-lv2`
- confirmation that no package-specific GCC 15 patches are needed

## Build instructions

Build the target with:

```bash
./bootstrap.sh moddwarf-new-gcc15
```

## Notes

This is an initial minimal target definition. Full completion of the original task still requires:
- repository-history review and commit summary
- package-by-package GCC 15 validation
- `neural-amp-modeler-lv2` verification
- targeted compatibility patches if any packages fail with GCC 15
