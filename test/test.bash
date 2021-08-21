#!/usr/bin/env bats

@test "throw error without --tag param" {
    run ../read_changelog_tasks.bash --path changelog.md
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "--tag param is required" ]
    [ "${lines[1]}" = "usage: read_changelog_tasks --path __ --tag __" ]
}

@test "throw error without --path param" {
    run ../read_changelog_tasks.bash --tag 1.0
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "--path param is required" ]
    [ "${lines[1]}" = "usage: read_changelog_tasks --path __ --tag __" ]
}

@test "throw error with not existent changelog file" {
    run ../read_changelog_tasks.bash --tag 1.0 --path "notexistent.md"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "The file notexistent.md was not found" ]
}

@test "displays correct task numbers" {
    run ../read_changelog_tasks.bash --tag 1.0 --path changelogs/1.md
    [ $status -eq 0 ]
    [ "${lines[0]}" = "#HCMGDP-2222" ]
}

@test "do not duplicate tasks" {
    run ../read_changelog_tasks.bash --tag 1.1 --path changelogs/2.md
    [ $status -eq 0 ]
    [ "${lines[0]}" = "#HCMGDP-3333" ]
    [ "${lines[1]}" = "#HCMGDP-2222" ]
    [ "${lines[2]}" = "#HCMGDP-2211" ]
}

@test "the tag must be a number" {
    run ../read_changelog_tasks.bash --tag v1.1 --path changelogs/2.md
    [ $status -eq 1 ]
    [ "${lines[0]}" = "--tag must be a number" ]
}

@test "throw error if tag does not exists" {
    run ../read_changelog_tasks.bash --tag 000 --path changelogs/2.md
    [ $status -eq 1 ]
    [ "${lines[0]}" = "The tag 000 was not found" ]
}

@test "output help" {
    run ../read_changelog_tasks.bash --help
    [ $status -eq 0 ]
    [ "${lines[0]}" = "Reads a changelog file and output an array of tasks for a given version." ]
    [ "${lines[1]}" = "Usage: read_changelog_tasks --tag <version> --path <path_to_file>" ]
}