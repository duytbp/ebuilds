# NordVPN 4.6.0 Reset Design

## Goal

Replace the existing NordVPN history on `main` with a single fresh commit named `add nordvpn 4.6.0`.

## Scope

- Remove the existing NordVPN-focused commits from the current `main` lineage.
- Preserve unrelated commits already on `main`, including the later non-NordVPN package and repo maintenance commits.
- Reintroduce the package as one new commit on top of the cleaned `main` lineage.
- Target upstream version `4.6.0`.

## Assumptions

- "Drop all previous nordvpn commits" means removing the commits whose purpose is adding or updating the NordVPN package, not removing unrelated commits that happened before or after them.
- The `main@nordvpn` remote bookmark can remain as imported remote history; the cleanup only changes this repo's local `main` history.
- The new package commit may restore package files from the old hidden local history as source material, but those old NordVPN commits will not remain in the rewritten `main` lineage.

## Rewrite Plan

1. Identify the NordVPN-focused commits currently present in local `main`.
2. Rewrite `main` so those NordVPN commits are removed while unrelated commits remain in order.
3. Build a new working change on top of the cleaned `main` head.
4. Restore the NordVPN package directory contents needed for a valid package layout.
5. Add a single new commit with description `add nordvpn 4.6.0`.

## Package Contents Plan

- Restore the package directory structure from the last known-good hidden local history for this repo rather than from the nordvpn remote history.
- Keep the package layout minimal: package files, `metadata.xml`, the `4.6.0` ebuild, and a regenerated `Manifest`.
- Do not preserve older NordVPN ebuild versions in the new history unless they are required for the package to be valid.

## Validation

- Confirm upstream Debian metadata still advertises `nordvpn` version `4.6.0`.
- Verify the new `main` no longer contains the old NordVPN-focused commits.
- Verify the new package tree exists in the working copy after the rewrite.
- Regenerate `Manifest` for `net-vpn/nordvpn`.
- Run repo-level or package-level validation commands that are available in this overlay.

## Risks

- Because the earlier history rewrite left the current materialized tree sparse, restoring package files must be done carefully so unrelated working-copy changes are not disturbed.
- Rewriting local `main` again will move it even farther from `origin/main`, so publishing later will require an explicit history-rewriting push.
