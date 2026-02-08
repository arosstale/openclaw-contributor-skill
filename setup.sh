#!/bin/bash
# Verify prerequisites for OpenClaw contribution

set -e

echo "Checking prerequisites..."

command -v gh >/dev/null 2>&1 || { echo "FAIL: gh CLI not found"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "FAIL: git not found"; exit 1; }
gh auth status > /dev/null 2>&1 || { echo "FAIL: GitHub auth not configured"; exit 1; }
gh repo view arosstale/openclaw > /dev/null 2>&1 || { echo "FAIL: Fork not accessible"; exit 1; }
gh repo view openclaw/openclaw > /dev/null 2>&1 || { echo "FAIL: openclaw/openclaw not accessible"; exit 1; }

echo "OK. Read SKILL.md for the workflow."
