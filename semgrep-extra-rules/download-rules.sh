#!/bin/sh

## Exit on error
set -e

## Echo all command
set +x

## Do everything in a clean folder
cd "${1:-rules}"

## Get the rules from the official Semgrep registry where possible
curl -sSL https://semgrep.dev/c/p/default > semgrep-default.yaml
curl -sSL https://semgrep.dev/c/p/trailofbits > trailofbits.yaml

## Clone additional repos
## Leads to error -> ignore for now
# git clone --depth 1 "https://github.com/0xdea/semgrep-rules" "0xdea"
git clone --depth 1 "https://github.com/akabe1/akabe1-semgrep-rules" akabe1
git clone --depth 1 "https://github.com/Decurity/semgrep-smart-contracts" decurity
git clone --depth 1 "https://github.com/mindedsecurity/semgrep-rules-android-security" mindedsecurity
git clone --depth 1 "https://github.com/patched-codes/semgrep-rules.git" patched-codes
git clone --depth 1 "https://github.com/s0rcy/semgrep-rules" s0rcy

## Cleanup YAML files mistakingly interpreted as rules
rm -r */.github/
rm */.pre-commit-config.yaml || true

## Remove all non-rule files to minimize space usage
find . -type f ! -name "*.yaml" ! -name "*.yml" -delete

## Remove broken rules (rule parse error, etc)
# [ERROR] Rule parse error in rule rules.mindedsecurity.rules.platform.MSTG-PLATFORM-8.1:
# Invalid pattern for Java: Stdlib.Parsing.Parse_error
# ----- pattern -----
# class $C extends ObjectOutputStream
# ----- end pattern -----
rm mindedsecurity/rules/platform/mstg-platform-8.1.yaml
