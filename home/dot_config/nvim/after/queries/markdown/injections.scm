(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(ts|typescript)(:.*)?$")
 (#set! language "typescript")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(py|python)(:.*)?$")
 (#set! language "python")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(sh|shell|bash)(:.*)?$")
 (#set! language "bash")
)
