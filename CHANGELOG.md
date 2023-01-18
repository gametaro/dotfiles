# Changelog

## [1.1.1](https://github.com/gametaro/dotfiles/compare/v1.1.0...v1.1.1) (2023-01-18)


### Bug Fixes

* **command:** accept ? nargs ([fd3556b](https://github.com/gametaro/dotfiles/commit/fd3556b562dfd0cf861dcb2208b990130d1a202a))
* **option:** restore accidentally removed code ([4d68f89](https://github.com/gametaro/dotfiles/commit/4d68f8968fa5dd3d240610d474cdb60987333977))
* **ufo:** use treesitter as provider on diff-mode ([535baa9](https://github.com/gametaro/dotfiles/commit/535baa9d278945792bbf533d433c0dc2da33a2d4))

## [1.1.0](https://github.com/gametaro/dotfiles/compare/v1.0.0...v1.1.0) (2023-01-15)


### Features

* **command:** create scratch-buffer ([9c518cd](https://github.com/gametaro/dotfiles/commit/9c518cd440c06abfbb43153101c4bd78f93a18a0))


### Bug Fixes

* **zsh:** remove -d arguments ([660faba](https://github.com/gametaro/dotfiles/commit/660fabad2352121ecbe8ba2cedbda1dd5ee49a85))

## 1.0.0 (2023-01-14)


### ⚠ BREAKING CHANGES

* reorganize various things
* **plugins:** migrate from packer to lazy
* **packer:** migrate from v1 to v2
* **plugins:** replace `spread.nvim` with `treesj`
* **jetpack:** migrate from jetpack to packer

### Features

* add experimental treemotion ([5b41a94](https://github.com/gametaro/dotfiles/commit/5b41a940158f7495ee01e7860a344577ec144991))
* **autocmd:** append listchars in visual mode ([e81aefb](https://github.com/gametaro/dotfiles/commit/e81aefb0e2c4d4c0a44818aaba993538d4fd9690))
* **autocmd:** set cursorline based on cursor movement ([b1f81eb](https://github.com/gametaro/dotfiles/commit/b1f81ebf87f0d54ced82d3f188434eccda697174))
* **autopairs:** add rule to add spaces on `=` ([998dea9](https://github.com/gametaro/dotfiles/commit/998dea936334141a07c04c715c89b5540be8e775))
* **chezmoi:** use nvim as difftool ([cce9eba](https://github.com/gametaro/dotfiles/commit/cce9ebac83f7b5262baf123424885b7587ccdd10))
* **colorscheme:** add command to clean compiled file ([5c0826f](https://github.com/gametaro/dotfiles/commit/5c0826fd5f0fc4f0a56cbbaac3d23f865f8a788e))
* **colorscheme:** add command to create compiled files ([dc29e82](https://github.com/gametaro/dotfiles/commit/dc29e82bf4bfe50f93474fa8f832ec2e65a6eea6))
* **colorscheme:** add highlight groups for treesitter ([ec218bf](https://github.com/gametaro/dotfiles/commit/ec218bf045495e35d2f5c0ff8edc05e4abe03abd))
* **colorscheme:** add highlights for `hlargs.nvim` ([411864f](https://github.com/gametaro/dotfiles/commit/411864f280f9295c57c8200b1b1ed0ba3076b4ab))
* **colorscheme:** add highlights for `nvim-treehopper` ([f10b64b](https://github.com/gametaro/dotfiles/commit/f10b64be67e0e8cb2ba1cb079f2ec7847e6a664b))
* **command:** add command to enable/disable diagnostics ([799d901](https://github.com/gametaro/dotfiles/commit/799d901972c0d3c306789e62ec62cb044dac2cfe))
* **containers:** add config file mainly for podman ([75896a1](https://github.com/gametaro/dotfiles/commit/75896a17fd2b33056d41643841a45942e7109be5))
* **cursorline:** hide only if line was changed ([efb1968](https://github.com/gametaro/dotfiles/commit/efb1968826ef35aa88261c9d5420b6d0bf9d3a7a))
* **docker:** add config.json ([2886421](https://github.com/gametaro/dotfiles/commit/2886421d726bea7bf521e8c9732660134a8ef325))
* **filetype:** add `code-workspace` pattern ([d252b97](https://github.com/gametaro/dotfiles/commit/d252b976682fbbab0d5a5de61fe8e7ce90a23fa7))
* **gh:** add config file ([5501d34](https://github.com/gametaro/dotfiles/commit/5501d34210345c1f9c4d09df641f797e49130d1f))
* **git:** enable `push.autoSetupRemote` ([6d0c47c](https://github.com/gametaro/dotfiles/commit/6d0c47c97671ed6c09a2aad837d1c67355581dfc))
* **grep:** use git grep for vimgrep and live_grep ([c1f84b9](https://github.com/gametaro/dotfiles/commit/c1f84b97b4f295f394a5038a109469fe43e9d4a1))
* **heirline:** add tabline ([2f3524b](https://github.com/gametaro/dotfiles/commit/2f3524bbe4a2e2c0b694624ea80226617ead6d9e))
* **hlargs:** enable `extra highlighting` ([2f024bf](https://github.com/gametaro/dotfiles/commit/2f024bff18652a1b84a3c8b80bf508d5883ceecb))
* **hlslens:** add mapping on visual mode ([781ab58](https://github.com/gametaro/dotfiles/commit/781ab5830de36cab569c54cd06127afdd054592a))
* **init:** enable ts_highlight_lua ([d6644b5](https://github.com/gametaro/dotfiles/commit/d6644b5424d126735df5f69d37089c2d1555ab8c))
* **jetpack:** migrate from jetpack to packer ([2c4eb10](https://github.com/gametaro/dotfiles/commit/2c4eb10608e392a67e5464c387ec91602f88b9fa))
* **lir:** enable `highlight_dirname` ([b651792](https://github.com/gametaro/dotfiles/commit/b651792600aecbdd6b86b113b2ebd45b7b15f3e5))
* **lsp:** use `lsp.buf.format` for range formatting ([d9046cf](https://github.com/gametaro/dotfiles/commit/d9046cf8286371af71c9188f6396c7e076076c4b))
* **mapping:** add mapping for new `Inspect` command ([d57ce2b](https://github.com/gametaro/dotfiles/commit/d57ce2bba422b907fb04e63a67423661781351d4))
* **mini.ai:** define textobj-diagnostic myself ([cc497bf](https://github.com/gametaro/dotfiles/commit/cc497bf9a20455e2222da632c4d1c8f024fd97ec))
* **mini.misc:** add mapping for zoom ([8eb5c97](https://github.com/gametaro/dotfiles/commit/8eb5c972c34b4f697c54697c608b59b71066eb00))
* **mini:** enable `mini.map` module ([5480b99](https://github.com/gametaro/dotfiles/commit/5480b9966a7dbcdbbe6d35f1b14fcd4f8c07b922))
* **noice:** enable lsp.hover and lsp.signature ([1a92121](https://github.com/gametaro/dotfiles/commit/1a921213ffd355051496a11df76ac19b26a0e4b0))
* **noice:** enable lsp.override ([552415e](https://github.com/gametaro/dotfiles/commit/552415ea32a97e227656fd9fbca55874bc8c0f57))
* **noice:** use presets ([8b8492b](https://github.com/gametaro/dotfiles/commit/8b8492b2401f33a88df7ce63b35f65b80b432aac))
* **null-ls:** add `actionlint` ([7604a3b](https://github.com/gametaro/dotfiles/commit/7604a3b8ee26df9e346ff01491c9c7ec6b0baeb6))
* **null-ls:** add `gitlint` ([727ec6b](https://github.com/gametaro/dotfiles/commit/727ec6b0e8b390a696c18ee5ee6c298fce8f1842))
* **null-ls:** add `shellcheck` code actions ([3827f74](https://github.com/gametaro/dotfiles/commit/3827f747c1ad6c38edaadaf4cc32dc68a5ef9820))
* **null-ls:** add `yamlfmt` ([bfeb26a](https://github.com/gametaro/dotfiles/commit/bfeb26ae83df9b728a9906290edb4d7d06ad8372))
* **null-ls:** add typescript.extensions to sources ([74dcdf4](https://github.com/gametaro/dotfiles/commit/74dcdf4664c1f5b8e391739de811aa857f832712))
* **number:** set number and relativenumber based on condition ([10b37b8](https://github.com/gametaro/dotfiles/commit/10b37b826ba9ea45c825c3f91cee3bf5a0761703))
* **option:** add `C` flag to `shortmess` ([a174fac](https://github.com/gametaro/dotfiles/commit/a174fac552158ba953a7c5e2612f8d10bc4adada))
* **option:** add `noplainbuffer` to `spelloptions` ([7b214a1](https://github.com/gametaro/dotfiles/commit/7b214a1379fd0587e3b2460f2cfd88a34cd24650))
* **option:** enable `startofline` ([549fe06](https://github.com/gametaro/dotfiles/commit/549fe06d7dad4493feef87a9d7c80f71d510c7a5))
* **option:** enable brand new `statuscolumn` ! ([8fc6a94](https://github.com/gametaro/dotfiles/commit/8fc6a942cb61c0df57bd1643ebaa404e1178e6ea))
* **option:** enable new diffopt's option ([a04815f](https://github.com/gametaro/dotfiles/commit/a04815f8bbfb1bca92008291fd61d4ba076ccc44))
* **option:** set `splitkeep` to `screen` ([6def095](https://github.com/gametaro/dotfiles/commit/6def0958b4733bcff1a4e632b75862fcffebe436))
* **packer:** add keymap to open compiled file ([778cd6d](https://github.com/gametaro/dotfiles/commit/778cd6dcb16056599ab73c25416c4e4d55ad75a6))
* **packer:** migrate from v1 to v2 ([881b712](https://github.com/gametaro/dotfiles/commit/881b712fa6858a09e8cce5f6208021df4916e566))
* **plugins:** add `messages.nvim` ([1b34687](https://github.com/gametaro/dotfiles/commit/1b346870fd379215cd35956e3e9f9b09a72d6d27))
* **plugins:** add `neodev.nvim` ([43658c7](https://github.com/gametaro/dotfiles/commit/43658c7f8b83433cdaa35be073ab2336ac6612f1))
* **plugins:** add `neogen` ([c82e527](https://github.com/gametaro/dotfiles/commit/c82e5272bcd78e54de5a4bdaf65fc81aa02794e7))
* **plugins:** add `neovim-session-manager` ([648e0f8](https://github.com/gametaro/dotfiles/commit/648e0f8bb2a114eb9de2358221c84ef54bc35e18))
* **plugins:** add `noice.nvim` ([aa9658a](https://github.com/gametaro/dotfiles/commit/aa9658ada6fbd916c00c4203fe1e87b709e1a044))
* **plugins:** add `notifier.nvim` ([23462d9](https://github.com/gametaro/dotfiles/commit/23462d9b7c7236e8d4f0f16193c687c2a5fa6f3a))
* **plugins:** add `nvim-FeMaco.lua` ([cdf0c5a](https://github.com/gametaro/dotfiles/commit/cdf0c5a747e04ea3722c9f5cd7178efb08d05073))
* **plugins:** add `nvim-fundo` and `undotree` ([1663df3](https://github.com/gametaro/dotfiles/commit/1663df3388e55efb52fd8f363d68416af50a4581))
* **plugins:** add `nvim-material-icon` ([633f3eb](https://github.com/gametaro/dotfiles/commit/633f3eb837f1186b9d0f551ffec8a49c93614042))
* **plugins:** add `nvim-treesitter-context` ([d35b189](https://github.com/gametaro/dotfiles/commit/d35b18933f5f54af075f1e922d1ed90f270179b2))
* **plugins:** add `nvim-ufo` ([e38a679](https://github.com/gametaro/dotfiles/commit/e38a679fa24719bedc97aea4f5c23fdbca198b77))
* **plugins:** add `nvim-unception` ([683b853](https://github.com/gametaro/dotfiles/commit/683b853bced53978067905d5c3993290e2863553))
* **plugins:** add `olddirs.nvim` ([02537c3](https://github.com/gametaro/dotfiles/commit/02537c345f6f77b59c8c3d25e942956fcb917d9c))
* **plugins:** add `portal.nvim` ([c1d5a6c](https://github.com/gametaro/dotfiles/commit/c1d5a6cee62452cf106af24980e20e5cfe5b6629))
* **plugins:** add `spread.nvim` ([2d3ec5b](https://github.com/gametaro/dotfiles/commit/2d3ec5b823fc26dd7cc80b0cd230079e7f0a7753))
* **plugins:** add `telescope-lazy.nvim` ([d695e78](https://github.com/gametaro/dotfiles/commit/d695e78f9432445724210c90e24c4f936810e117))
* **plugins:** add `template-string.nvim` ([b5600e8](https://github.com/gametaro/dotfiles/commit/b5600e89aeb841c9267a4a9608185e7907afb375))
* **plugins:** add `tint.nvim` ([90c276d](https://github.com/gametaro/dotfiles/commit/90c276d216d5fa262f6aa9d802e73de3b1662a81))
* **plugins:** add `vim-highlighturl` ([27afb67](https://github.com/gametaro/dotfiles/commit/27afb673fc193dcc0f0e8d6f1ca0a138c40756c4))
* **plugins:** add `vim-illuminate` ([271f561](https://github.com/gametaro/dotfiles/commit/271f561677344f5478b0d87405e670e26b88dab0))
* **plugins:** add neoconf.nvim ([9313fcd](https://github.com/gametaro/dotfiles/commit/9313fcdbc04ef0d5e71bf68a73909b4c5d137666))
* **plugins:** migrate from packer to lazy ([7ee75ea](https://github.com/gametaro/dotfiles/commit/7ee75ea0bf2d1517bb5dc230bab8682aaeb1e902))
* **plugins:** replace `spread.nvim` with `treesj` ([2a91d16](https://github.com/gametaro/dotfiles/commit/2a91d16f8ea6834a3c0e4f65d796599108025ebe))
* reorganize various things ([703d84c](https://github.com/gametaro/dotfiles/commit/703d84c1683f92a3cf07225d099d89f0a1b449c0))
* **surround:** adapt to latest release ([9b918c2](https://github.com/gametaro/dotfiles/commit/9b918c2d2745c2d2dc45c157ab366eac006c4dea))
* **surround:** add print statements for lua/typescript ([d60ee47](https://github.com/gametaro/dotfiles/commit/d60ee4746c3a3764746f84793b86db5d6f31793e))
* **telescope:** enable default_workspace of frecency ([30588f6](https://github.com/gametaro/dotfiles/commit/30588f69070a1140deeeefd00d1006c0c9fc4a97))
* **terminal:** allow `&lt;C-^&gt;` from terminal mode ([5fb5ad1](https://github.com/gametaro/dotfiles/commit/5fb5ad1d5d2cdda41bed10cd0a4b15bf26dd2194))
* **tint:** add more ignore patterns ([27b6b76](https://github.com/gametaro/dotfiles/commit/27b6b767f16ee8eb2bb45ef2359ffc9e52ce0e3a))
* **todo-comments:** add mappings to jump to prev/next comment ([6a597f2](https://github.com/gametaro/dotfiles/commit/6a597f2295ad4ebdb0890237e32d3e2475483b07))
* **walkthrough:** support count ([d448789](https://github.com/gametaro/dotfiles/commit/d448789b2471679cb2a32e5f078b10e975ddfcc9))
* **walkthrough:** various improvements ([b6c9afb](https://github.com/gametaro/dotfiles/commit/b6c9afb28111bfd7cbb457751c4c584818925628))
* **word:** add lua equivalent to vim-smartword (WIP) ([cc3dd42](https://github.com/gametaro/dotfiles/commit/cc3dd420f4a8eba70a32bb55e85c0522e9b214e8))


### Bug Fixes

* **accelerated-jk:** visual glitch when cmdheight = 0 ([a86e6ac](https://github.com/gametaro/dotfiles/commit/a86e6ac149a53c6c0d6aebb8ace27036f11b6289))
* **autocmd:** add missing modules ([fa6582b](https://github.com/gametaro/dotfiles/commit/fa6582ba4ae3cb88b2c297832ef12e3d0ce8656d))
* **autocmd:** chezmoi's pattern ([cc8fb76](https://github.com/gametaro/dotfiles/commit/cc8fb765cdba0abeebb5bb76b8e39457e58d83f7))
* **autocmd:** correct augroup creation ([e4dce08](https://github.com/gametaro/dotfiles/commit/e4dce085d4b0da2d58eaad4fe925221b3a33cbc5))
* **autocmd:** correct debounce function for DiagnosticChanged ([a5d0d95](https://github.com/gametaro/dotfiles/commit/a5d0d95c92d791078f4db233bac6fe5893910e8c))
* **autocmd:** invalid buf error ([15f0917](https://github.com/gametaro/dotfiles/commit/15f09179a6687f240f5cb6515c1685d911fce60a))
* **autocmd:** specify mods.silent ([912e814](https://github.com/gametaro/dotfiles/commit/912e814a3bde7223c889aff36263883b2849d763))
* **chezmoi:** install python3-venv ([1b5283c](https://github.com/gametaro/dotfiles/commit/1b5283ceffae8ce50c0c179aebf370f4b35bad50))
* **chezmoi:** remove unnecessary comma ([f20d038](https://github.com/gametaro/dotfiles/commit/f20d038532c75ce7b8a306492d4f32ca4c2d132e))
* **chezmoi:** remove unused variable ([155c84a](https://github.com/gametaro/dotfiles/commit/155c84aff0cfdc8f41fbf06c75ec950fe993374a))
* **clink:** update path ([3c47be7](https://github.com/gametaro/dotfiles/commit/3c47be7fc0b9e0aaf69d304a3b7c58baacf5bd16))
* **colorscheme:** [@variable](https://github.com/variable) do not work with semantic tokens ([e04acd8](https://github.com/gametaro/dotfiles/commit/e04acd864326252b4f1667b1d29f5793f56cdff8))
* **colorscheme:** correct highlight's name ([c6f09a5](https://github.com/gametaro/dotfiles/commit/c6f09a5806bd01b27225ac56e27c156903fa91a1))
* **colorscheme:** correct highlight's name ([2880592](https://github.com/gametaro/dotfiles/commit/2880592298e2a70945e13ab520cc1edfebcaf55d))
* **colorscheme:** lint errors ([368b776](https://github.com/gametaro/dotfiles/commit/368b776fc1f07d3c7ddc40d654c4cd961ddfbc61))
* **colorscheme:** swap fg and bg for `Cursor` ([0878d3a](https://github.com/gametaro/dotfiles/commit/0878d3af73fdaac1d233ca908f49372aaab4dae6))
* **defer:** replace timer:close() with timer:stop() ([6fd9178](https://github.com/gametaro/dotfiles/commit/6fd91781e8469bdabaaea331b63c30f2b69630bb))
* **diagnostic:** correct format ([2cab1b9](https://github.com/gametaro/dotfiles/commit/2cab1b9fcec9232997ae817b1a6c375fef810811))
* **diagnostic:** correct icons for diagnostic ([d61834f](https://github.com/gametaro/dotfiles/commit/d61834f85d6abff15748327bad220e73ae0d7d69))
* **diffview:** correct command args ([9536ecb](https://github.com/gametaro/dotfiles/commit/9536ecb5c636c2b7c1352355ca1041a98563e682))
* **gitsigns:** read after `BufRead` ([73c6436](https://github.com/gametaro/dotfiles/commit/73c6436fa1171213554d36b7cf1111c35ed1533b))
* **heirline:** change &lt;-&gt; remove ([b79c7ba](https://github.com/gametaro/dotfiles/commit/b79c7ba33f9efe0b14da3813ef9a026c74722cdc))
* **heirline:** create autocmd outside lazy ([8ea0d00](https://github.com/gametaro/dotfiles/commit/8ea0d00dd4aa1f12502b957b68ce7b69367d22c1))
* **heirline:** do not use `link` for highlights ([92532a1](https://github.com/gametaro/dotfiles/commit/92532a1cb62b5921fcb95e9fa3bd7ef8eb74afea))
* **heirline:** set `showtabline` to 1 ([1365eaf](https://github.com/gametaro/dotfiles/commit/1365eaff798924922605203bbeb4cb2621378259))
* **illuminate:** adapt to latest changes ([8a4b414](https://github.com/gametaro/dotfiles/commit/8a4b414d14da479fa6bef8992b93e26744343873))
* **illuminate:** disable on `null-ls`/change highlight groups ([5e8b529](https://github.com/gametaro/dotfiles/commit/5e8b5292e38a3b02c2d706b5d7cc16225ac1a559))
* **job:** check nil ([513d1c5](https://github.com/gametaro/dotfiles/commit/513d1c5f2368f1a473f648ab6fbe5c646cd3b6e1))
* **jump:** correct command ([03d9318](https://github.com/gametaro/dotfiles/commit/03d93188760f8976c387ead019583c9156e30c43))
* **lazy:** adapt to latest changes ([86249e3](https://github.com/gametaro/dotfiles/commit/86249e3d9120cbdd0dc6e7c5a1927c0bb92c71ba))
* **lazy:** tweak rtp to recognize spell file ([ac5443f](https://github.com/gametaro/dotfiles/commit/ac5443f8f664422eef5c5ebbf83f2b7500dd5f81))
* **lazy:** udpate path ([de9b3ad](https://github.com/gametaro/dotfiles/commit/de9b3adbd0fe79aaa1e3a86aa9f2f060a697cd76))
* lint errors ([4d5d53a](https://github.com/gametaro/dotfiles/commit/4d5d53a6b6f5c02f5986703a34dbbf92a3b2581d))
* **lir:** adapt to latest changes ([e9cb73b](https://github.com/gametaro/dotfiles/commit/e9cb73b47283caf51f268b58bff4953d281d50d1))
* **mapping:** nextcmd is not working ([9291299](https://github.com/gametaro/dotfiles/commit/9291299726143a65634753bb9b31ffccbbe1f63d))
* **mini.pairs:** set `replace_keycodes` to false ([6c28984](https://github.com/gametaro/dotfiles/commit/6c28984fbb15a9cf02744872f491a237e85cd7bc))
* **mini:** do not require `mini` directly ([876a385](https://github.com/gametaro/dotfiles/commit/876a38539d4b262362d2c1859fdb7b95e7bd386d))
* **notify:** don't override vim.notify ([773859b](https://github.com/gametaro/dotfiles/commit/773859b6e5c95dd78ad4c1521d1be4d0b1299dd0))
* **notify:** use &lt;Cmd&gt; mappings ([765bfbe](https://github.com/gametaro/dotfiles/commit/765bfbe4d13b1b48bbf2972d6e80f7f0ec6b13a3))
* **number:** redraw only on `CmdlineEnter` ([1833fce](https://github.com/gametaro/dotfiles/commit/1833fce6db048fae1b31b2a0719515a8d9585f76))
* **number:** remove unneeded code ([dbf97a6](https://github.com/gametaro/dotfiles/commit/dbf97a63879800d0c025d7a8134437a6db9cdcd4))
* **nvim-surround:** load on `VeryLazy` ([e974357](https://github.com/gametaro/dotfiles/commit/e9743577822fda1402ba8248087aab5e7af26578))
* **osc52:** add require guard ([1a0d7e7](https://github.com/gametaro/dotfiles/commit/1a0d7e70c232c7360a4edac5d09c9990a7cb8160))
* **packer:** correct mappings ([768d196](https://github.com/gametaro/dotfiles/commit/768d19652d3dcc6b05aa98aaf15702e7debd8df2))
* **plugins:** add guard for require ([9af8b2a](https://github.com/gametaro/dotfiles/commit/9af8b2a19bfc14cb5dd2b653d1772be21b93218c))
* **plugins:** correct function to run on update ([400c578](https://github.com/gametaro/dotfiles/commit/400c578f98896a1c5daf37030f5e2144251cd2db))
* **plugins:** set silent to true ([91c1900](https://github.com/gametaro/dotfiles/commit/91c1900cb21fa8904269aa6f64425ff12697c8bf))
* **pounce:** correct autocmd pattern and mapping ([39512f4](https://github.com/gametaro/dotfiles/commit/39512f43860100c58632a807c67fabafdfdfb201))
* **project:** always set pwd with tcd ([ed709fe](https://github.com/gametaro/dotfiles/commit/ed709fea4b81fca9fb38523afe99003041915390))
* **sheldon:** adapt to latest version ([055705b](https://github.com/gametaro/dotfiles/commit/055705bcfe5b51a027210519bf204b9f26c2b1cf))
* **sheldon:** correct install script ([da15645](https://github.com/gametaro/dotfiles/commit/da15645ffb1c412a4dad612bc0663140798964cb))
* **statuscolumn:** disable on terminal ([5c66e21](https://github.com/gametaro/dotfiles/commit/5c66e21ce2ad10cbc94cf638b4eb8a09519023b9))
* **telescope:** redefined local variables ([b4458ec](https://github.com/gametaro/dotfiles/commit/b4458ecccfe1773c34a832e156e195543243943e))
* **util:** handle nil case ([6820f8f](https://github.com/gametaro/dotfiles/commit/6820f8f9095bc61bb2b4354ab10b213bf8953655))
* **walkthrough:** handle case if #files == 1 ([59a3cc1](https://github.com/gametaro/dotfiles/commit/59a3cc132b9e2e0e8f7bb10b57cb1b65cdacf729))
* **word:** compare two tables correctly ([522d47b](https://github.com/gametaro/dotfiles/commit/522d47b667ae8ec0072b07c10f2039510c504b4f))
* **word:** correct function call ([8fd096a](https://github.com/gametaro/dotfiles/commit/8fd096ae559118f81266be0b7e3ac2ee02b40e1e))


### Performance Improvements

* **bqf:** load on ft ([5328965](https://github.com/gametaro/dotfiles/commit/532896527d89310ca20e1a5570f8c371a39db60b))
* **colorscheme:** use local variables for compiling ([e0fe9f3](https://github.com/gametaro/dotfiles/commit/e0fe9f3b408f08b57af04e8521dc99138af9e5df))
* **lazy:** set defaults.lazy to true ([0548e84](https://github.com/gametaro/dotfiles/commit/0548e84a3e522cba162c40b0ccd49ac97f571e8d))
* **walkthrough:** introduce file watcher ([429fc44](https://github.com/gametaro/dotfiles/commit/429fc441825c690726e4a2ab7d609e71abe86dc5))
