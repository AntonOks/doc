unit class Test-Files;

=begin overview

Utility methods for generating lists of files for testing.

=end overview

#|(
    Are we working with all the files in the repository?
)
method all-files() {
    not (@*ARGS or %*ENV<TEST_FILES>);
}

#|(
    Return list of files to test.

    If files were passed on the command line, use those.

    Otherwise, if the C<TEST_FILES> environment variable is set to
    a space-separated list of files, use that. Any files specified
    this way that don't exist are silently removed.

    Always skip our C<Build.rakumod>, as it's designed to blow up.
)
method files() {
    my @files;

    if @*ARGS {
        @files = @*ARGS;
    } else {
        if %*ENV<TEST_FILES> {
            @files = %*ENV<TEST_FILES>.trim.split(/ \s /).grep(*.IO.e);
        } else {
            @files = qx<git ls-files>.lines;
        }
    }
    return @files.grep(* ne "Build.rakumod").sort;
}

#|(
    Filtered list of C<files> to return only Pod files.
)
method pods() {
    return $.files\
        .grep({$_.ends-with: '.raku'|'.rakudoc'|'.rakutest'|'.rakumod'})\
        .grep(* ne "Build.rakumod");
}

#|(
    Filtered list of C<files> to return only Pod files and markdown.
)
method documents() {
    return $.files\
        .grep({$_.ends-with: '.raku'|'.rakudoc'|'.md'|'.rakutest'|'.rakumod'})\
        .grep(* ne "Build.rakumod");
}

#|(
    Filtered list of C<files> to return only test files.
)
method tests() {
    return $.files.grep({$_.ends-with: '.rakutest'})
}
