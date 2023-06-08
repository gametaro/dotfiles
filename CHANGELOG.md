# Changelog

## [2.9.0](https://github.com/gametaro/dotfiles/compare/v2.8.2...v2.9.0) (2023-06-08)


### Features

* **dropbar:** add icons and highlight for modified file ([0e3e2e6](https://github.com/gametaro/dotfiles/commit/0e3e2e6bb7f9672d60ca330f64b5b06012b0e1d4))
* **plugins:** add `dropbar.nvim` ([27e991b](https://github.com/gametaro/dotfiles/commit/27e991bb140e7685fca0e704cf85cec532c648cf))


### Bug Fixes

* **autocmd:** check if obj.data exists ([cd8ac96](https://github.com/gametaro/dotfiles/commit/cd8ac96fbfdb225bfc50fa9d761a4585f18691fb))


### Performance Improvements

* **dropbar:** tweak update_events ([46afb1c](https://github.com/gametaro/dotfiles/commit/46afb1ce058e16fb0560fbca9adb92d150f9ee18))

## [2.8.2](https://github.com/gametaro/dotfiles/compare/v2.8.1...v2.8.2) (2023-05-31)


### Bug Fixes

* **lsp:** remove annotations and server_capabilities for yaml ([294abbb](https://github.com/gametaro/dotfiles/commit/294abbbb872c8579fd1a1a0903f03e61ed32ef1d))

## [2.8.1](https://github.com/gametaro/dotfiles/compare/v2.8.0...v2.8.1) (2023-05-19)


### Bug Fixes

* **qf:** check nil ([f4c3597](https://github.com/gametaro/dotfiles/commit/f4c35971665efcfcc41d30bea8bf3ac257085ab9))

## [2.8.0](https://github.com/gametaro/dotfiles/compare/v2.7.1...v2.8.0) (2023-05-10)


### Features

* add rtx ([4c6b966](https://github.com/gametaro/dotfiles/commit/4c6b96695a53580579a6246ce19b1f17dab34e70))
* **diffview:** set `--follow` on `DiffviewFileHistory` ([25e29da](https://github.com/gametaro/dotfiles/commit/25e29da6e9dbd8113836f34dd8775655bf31bede))
* **option:** enable `smoothscroll` ([7d9fa92](https://github.com/gametaro/dotfiles/commit/7d9fa92305f74e82982969e0282d9529b6d0ffcd))
* **typescript:** use vtsls instead of typescript-language-server ([bd61c4a](https://github.com/gametaro/dotfiles/commit/bd61c4aa3fd90dd6bdcd96fe29875a982ec7f676))


### Bug Fixes

* **ls:** check nil ([c1fcc5e](https://github.com/gametaro/dotfiles/commit/c1fcc5e75274b8284027eeacfce9c372bfd36c6f))

## [2.7.1](https://github.com/gametaro/dotfiles/compare/v2.7.0...v2.7.1) (2023-04-10)


### Bug Fixes

* **edgemotion:** respect multibyte characters ([1122956](https://github.com/gametaro/dotfiles/commit/11229561c5fc7905aa83dcf8d1056c1d74cfea50))
* **null-ls:** do not attach on diffview ([298c359](https://github.com/gametaro/dotfiles/commit/298c3594e51e0a81000e5e677dad714fd8ddcf36))
* **qf:** correctly set option value ([3a770c3](https://github.com/gametaro/dotfiles/commit/3a770c30ecce9ea584a5c193eeca068294d2f107))

## [2.7.0](https://github.com/gametaro/dotfiles/compare/v2.6.1...v2.7.0) (2023-04-06)


### Features

* **colorscheme:** add highlight for `DiagnosticDeprecated` ([ae3d710](https://github.com/gametaro/dotfiles/commit/ae3d71002fb6ce78105eab9a44cc2d975774d1dc))
* **loader:** enable vim.loader ([440acc5](https://github.com/gametaro/dotfiles/commit/440acc5fbe0ecce343c05f57f682d552339bc7d1))
* **plugin:** add `peek` module ([e40855b](https://github.com/gametaro/dotfiles/commit/e40855b4ce4e1fccb59b402187ec2dad70e70c6f))
* **qf:** peek quickfix's item on cursor ([475f71b](https://github.com/gametaro/dotfiles/commit/475f71b91caf8443da0712415b6f8fad63e67114))


### Bug Fixes

* **edgemotion:** various fixes and refactoring ([ee677c4](https://github.com/gametaro/dotfiles/commit/ee677c4057b8b1ae5a405bf17f6d82aabf4a9b31))
* **heirline:** correct event ([2301068](https://github.com/gametaro/dotfiles/commit/2301068b20a0a1eedf94531c1a55430a35f02aca))
* **ls:** check if alt file is empty ([4ae6fce](https://github.com/gametaro/dotfiles/commit/4ae6fce47dc6ddc688f0d0fc601891ea18f970ee))
* **ls:** load on BufWinEnter instead of BufEnter ([5087270](https://github.com/gametaro/dotfiles/commit/5087270981423d4614f7739eab9d3bb17eb68a14))
* **ls:** normalize path and remove trailing (back)slash ([1d7df26](https://github.com/gametaro/dotfiles/commit/1d7df26f56d366f7c6cafd2fb55d920fe3423541))
* **ls:** pass correct buffer ([b22613b](https://github.com/gametaro/dotfiles/commit/b22613b45b8da2b0c843c0718a8fc2ad3b66e509))
* **ls:** various fixes ([e65ad2e](https://github.com/gametaro/dotfiles/commit/e65ad2e80bd4f89ad9af09aee7f86fdd6d3cf822))
* **peek:** only activate on `:` ([8b204de](https://github.com/gametaro/dotfiles/commit/8b204dec72050445cc3070d178a3b5ac79a31747))
* **qf:** set autocmd to buffer local ([11f16a7](https://github.com/gametaro/dotfiles/commit/11f16a734098f778532fe6f6a7549bb0da8248ba))


### Performance Improvements

* **ls:** improvements ([0ee48e7](https://github.com/gametaro/dotfiles/commit/0ee48e79c38a66505baebc87230746ca243c45d1))
* **ls:** use `nvim_set_decoration_provider` instead of `nvim_buf_attach` ([9823f19](https://github.com/gametaro/dotfiles/commit/9823f19e5dec4225e001672adebc7c01edf1ccef))

## [2.6.1](https://github.com/gametaro/dotfiles/compare/v2.6.0...v2.6.1) (2023-03-21)


### Bug Fixes

* **chezmoi:** correctly set exec path ([9805082](https://github.com/gametaro/dotfiles/commit/980508274dc95646cc110a60e4146ef49bda8a2a))
* **ls:** correct index ([9d8f801](https://github.com/gametaro/dotfiles/commit/9d8f801ff038a481f6ea2c26ec994dd1a90085fd))
* **ls:** exec nvim_buf_set_extmark in vim.schedule() ([ee0f16f](https://github.com/gametaro/dotfiles/commit/ee0f16fef5332a1a1152d4d0c3e5c50a2c3cfa9b))
* **ls:** more fixes and refactoring ([e44d2ba](https://github.com/gametaro/dotfiles/commit/e44d2ba9bc706c234430bf4eeef991d171cae7ee))
* **ls:** performance improvements and fixes to handle edge cases ([6c7b328](https://github.com/gametaro/dotfiles/commit/6c7b3280ced5799ae1883d596f6a7f0b7143695a))
* **ls:** rename config key ([75123ad](https://github.com/gametaro/dotfiles/commit/75123ad46c42208017b5cdec00839b00b4c9737d))
* **ls:** tweak `isfname` to ignore spaces in filename ([0f366d9](https://github.com/gametaro/dotfiles/commit/0f366d90b801c401be426431cb4ac83470e975bf))
* **ls:** use bit.band instead of getfperm to run in luv callback ([c47a801](https://github.com/gametaro/dotfiles/commit/c47a801831e261157d8153f25a1bd6f6c3e7de10))
* **ls:** various improvements & bug fixes ([337be2f](https://github.com/gametaro/dotfiles/commit/337be2f988b9d5da9cb89912f50f905127c099f1))

## [2.6.0](https://github.com/gametaro/dotfiles/compare/v2.5.0...v2.6.0) (2023-03-19)


### Features

* **plugin:** add experimental file explorer ([b8333e9](https://github.com/gametaro/dotfiles/commit/b8333e98a68ec16897549fb0208b2b399879f254))
* **plugin:** add singleton module ([a076386](https://github.com/gametaro/dotfiles/commit/a076386d82c3773f9605ce91e54680b35e2901ea))
* **plugins:** add ChatGPT.nvim ([44cc8fa](https://github.com/gametaro/dotfiles/commit/44cc8faca52c673ea5369284204c87bf4244e324))


### Bug Fixes

* **chezmoi:** correct diff/merge args ([5540f1d](https://github.com/gametaro/dotfiles/commit/5540f1d101baf774adfd603c080a1c9f6d476901))
* **command:** validate win ([9a9c0c8](https://github.com/gametaro/dotfiles/commit/9a9c0c876ef97c7f8768a6b9beb9db776924c8d5))
* **dotenv:** search downward & trim after replacing quotes ([ade89db](https://github.com/gametaro/dotfiles/commit/ade89db3a2e75d23ba5169db0ee45587e34a4474))
* **dotenv:** various fixes ([cbca099](https://github.com/gametaro/dotfiles/commit/cbca099727af0119f60c0582447f97d9083a45d6))
* **heirline:** simplify update of mode ([4816a60](https://github.com/gametaro/dotfiles/commit/4816a6034035b97a86b59e3ace61cb655fdf845f))
* **singleton:** correctly handle command repeat ([6ff75e0](https://github.com/gametaro/dotfiles/commit/6ff75e020e19d92dac6a164586ac2015da7b3bd0))
* **singleton:** support man ([57e0061](https://github.com/gametaro/dotfiles/commit/57e006171262fe7fcec77d2f2436a68ad3bc04c2))
* **singleton:** various fixes and refactoring ([0747428](https://github.com/gametaro/dotfiles/commit/07474288a92875c95ecb27abde4b46bf69d9fa06))
* **terminal:** check if fzf is running ([bc10b52](https://github.com/gametaro/dotfiles/commit/bc10b52d7a094665ca1b1c52b333b0ef7f9c8e8b))
* **terminal:** correctly get cwd ([17d92f1](https://github.com/gametaro/dotfiles/commit/17d92f1401b6058632cc45ad317e0f7dba1048aa))
* **terminal:** remove non-existent buffer ([3ad98be](https://github.com/gametaro/dotfiles/commit/3ad98beecddd1c719ee51b81e06180794d402857))

## [2.5.0](https://github.com/gametaro/dotfiles/compare/v2.4.0...v2.5.0) (2023-03-11)


### Features

* **autocmd:** create spell file if it is missing ([57c0684](https://github.com/gametaro/dotfiles/commit/57c068434ac5c5a6089eff2be70d98d41a7b7332))
* **colorscheme:** support lsp semantic tokens ([6f2641a](https://github.com/gametaro/dotfiles/commit/6f2641a5f62c65603ee674c6f9ec269d4354ebc9))
* **heirline:** handle special tabpage name ([2eeac42](https://github.com/gametaro/dotfiles/commit/2eeac4235f6d246cef0b437f0879a7b8c76d2589))
* **plugin:** add session module ([b87f57d](https://github.com/gametaro/dotfiles/commit/b87f57db3433245e3632b827904814cfac92edb9))
* **plugins:** add paint.nvim ([d67b25d](https://github.com/gametaro/dotfiles/commit/d67b25df385bab1b1ac7e48be2aa04b143f0bc55))
* **plugins:** replace nvim-colorizer with ccc.nvim ([e172bed](https://github.com/gametaro/dotfiles/commit/e172bed453f59d1fe684f88f3fa6d62fe0e1bc79))
* **terminal:** add mapping ([19cbc92](https://github.com/gametaro/dotfiles/commit/19cbc929b5a322fe94af8aca90120b857943fbee))
* **terminal:** support split modifier ([1ac9263](https://github.com/gametaro/dotfiles/commit/1ac9263d7bc970ec1b23caf0f125a5feb3814776))


### Bug Fixes

* **dotenv:** disable on some buftype/filetype ([257e273](https://github.com/gametaro/dotfiles/commit/257e2732ed584e7c8b98d9d69bb153861936a297))
* **dotenv:** disable when loaded as PAGER ([24ce8dc](https://github.com/gametaro/dotfiles/commit/24ce8dcb9b786bc961bce05949af7b65fe8489dc))
* **null-ls:** suppress warning when source is not executable ([5a88292](https://github.com/gametaro/dotfiles/commit/5a88292f69200ab828df14504791016ed9002d93))
* **session:** handle edge case ([39a0232](https://github.com/gametaro/dotfiles/commit/39a0232c4617b10aad48c737c4d199345c123588))
* **util:** check nil ([d71b78f](https://github.com/gametaro/dotfiles/commit/d71b78f182f2e12c68ab31a252e93f4844272e0d))
* **util:** follow up ([f4c8ef8](https://github.com/gametaro/dotfiles/commit/f4c8ef8bfca9ceb21920f67cf64cf9ebd9601838))


### Performance Improvements

* **autocmd:** use vim.loop instead of vimL ([bc3b5e7](https://github.com/gametaro/dotfiles/commit/bc3b5e7c3a2ecc7fc508574cdfb78a9a6bcf931f))
* **lsp:** cache resolved root ([efde115](https://github.com/gametaro/dotfiles/commit/efde1151d03560a2ae0be325a4a971e09ac267c9))
* **nvim:** more tweak when opening large file ([d256148](https://github.com/gametaro/dotfiles/commit/d2561482da1daf5c3682dba7e091e3e00114296d))

## [2.4.0](https://github.com/gametaro/dotfiles/compare/v2.3.0...v2.4.0) (2023-03-06)


### Features

* **colorscheme:** make `hue_base` configurable ([c3f47ff](https://github.com/gametaro/dotfiles/commit/c3f47ff012411b2d795bd2f553d3b1ddc3f319e2))
* **colorscheme:** support transparent ([1daaa38](https://github.com/gametaro/dotfiles/commit/1daaa38bb28296b1821a138e8afa3c44bbfcb8cc))
* **lsp:** add workspace/didChangeWatchedFiles to capabilities ([c9a2c65](https://github.com/gametaro/dotfiles/commit/c9a2c6573b72c72765ec9dc562c654d37e3f5d26))
* **plugins:** add `profile.nvim` ([f4f63b8](https://github.com/gametaro/dotfiles/commit/f4f63b8b367595d5340d8b88111929978c53b7b5))


### Bug Fixes

* **nvim:** disable some plugins when opening large file ([541e05d](https://github.com/gametaro/dotfiles/commit/541e05d8e1571b1d70269ab87af782bb32058e63))
* **nvim:** more tweak for large file ([4dd2cf4](https://github.com/gametaro/dotfiles/commit/4dd2cf478fe8465e12b4f6fc97f679d124c86151))
* **profile:** start up on top of init.lua ([53c2b96](https://github.com/gametaro/dotfiles/commit/53c2b96a3c0d90d3524b73d530b7df240391e439))
* **profile:** start up on top of init.lua ([37d0569](https://github.com/gametaro/dotfiles/commit/37d05698fb34623183cb1b22fbd36b9966954377))
* **smart-insert:** disable on `TelescopePrompt` ([6cddb6a](https://github.com/gametaro/dotfiles/commit/6cddb6a4fc8ecaff38f94871ea6c096b2e8fa495))
* **terminal:** add pattern to `TermOpen` ([8be0180](https://github.com/gametaro/dotfiles/commit/8be018022d8f5fdca4a75c08518451d24270a630))


### Performance Improvements

* **treesitter:** disable unused modules ([d5c7edb](https://github.com/gametaro/dotfiles/commit/d5c7edbce98a33753a10c51fd145904fd3ed0779))

## [2.3.0](https://github.com/gametaro/dotfiles/compare/v2.2.0...v2.3.0) (2023-03-01)


### Features

* **heirline:** add component to check if working tree is clean ([6f65bbe](https://github.com/gametaro/dotfiles/commit/6f65bbeaf399577312cc08fa18c2d72bc1139e67))
* **mapping:** add mappings to toggle options ([1550b55](https://github.com/gametaro/dotfiles/commit/1550b554738244b8de96cfcc0049bb82f0036208))
* **option:** set `exrc` to true ([abdf6a9](https://github.com/gametaro/dotfiles/commit/abdf6a90bf538efac9d2bc0a1a73b711f5f07f42))
* **plugin:** add utility to load .env file ([456d888](https://github.com/gametaro/dotfiles/commit/456d888ab658db1cc10509e6655699ecd56e5c38))
* **ui:** add ability to toggle nerd fonts ([737ec22](https://github.com/gametaro/dotfiles/commit/737ec22b28ff128d79022983269412497c3f7e6e))


### Bug Fixes

* **cmp:** correct kind for completions ([a3ffa0d](https://github.com/gametaro/dotfiles/commit/a3ffa0d25cabcde472e2b59bc8562d81992fbc33))
* **cursorline:** prevent deferred activation on ignored pattern ([71136c8](https://github.com/gametaro/dotfiles/commit/71136c82f8e363a3033b95c105fba348a5b7ea33))
* **cursorline:** respect virtcol ([2b66751](https://github.com/gametaro/dotfiles/commit/2b66751a051d441ef89328c543e58db12fadc45c))
* **devicons:** safely require module ([63c65f0](https://github.com/gametaro/dotfiles/commit/63c65f0bf40b42d71d68490e167673d3f2631c1a))
* **dotenv:** does not return ([8e56943](https://github.com/gametaro/dotfiles/commit/8e56943132863d92ffd4655d5c30559d39a71c1f))
* **notify:** always on top window ([39d65c7](https://github.com/gametaro/dotfiles/commit/39d65c7534e81c31c3c14b4fad56c65b26daebc6))
* **plugins:** correct event patterns ([7a7d51e](https://github.com/gametaro/dotfiles/commit/7a7d51e04af381e4763aa281df3e03104212d7b8))
* **substitute:** remove config related to yanky ([5f0f3c4](https://github.com/gametaro/dotfiles/commit/5f0f3c43165d83d92a9e55a8d8c1cb6b023b3892))
* **ui:** respect `vim.g.nerd` ([a354b9f](https://github.com/gametaro/dotfiles/commit/a354b9f9135d5ec579bc71fb4c046168513aa3c8))


### Performance Improvements

* **autocmd:** simplify logic ([6a4cf94](https://github.com/gametaro/dotfiles/commit/6a4cf9411f37f644b591e68d29dc67b48b99ee3e))

## [2.2.0](https://github.com/gametaro/dotfiles/compare/v2.1.0...v2.2.0) (2023-02-20)


### Features

* **cursorline:** add supports for `cursorcolumn` ([7fc517e](https://github.com/gametaro/dotfiles/commit/7fc517e7f00dfe1bbcaf23ae7aec7419e5505d92))
* **ftplugin:** add treesitter highlighting ([93e056c](https://github.com/gametaro/dotfiles/commit/93e056cfbee02dee6648a3d1592b3b50c91d9a7a))
* **lsp:** eliminate lspconfig ([ccc141c](https://github.com/gametaro/dotfiles/commit/ccc141ce2f2fa92c022cd902298cb15a6bf2ba91))
* **luasnippets:** various improvements ([5dccbf9](https://github.com/gametaro/dotfiles/commit/5dccbf90dbe5bc4d33a5743a2306fcb27e1883c8))
* **plugin:** add `edgemotion.lua` ([309e8a6](https://github.com/gametaro/dotfiles/commit/309e8a6ff3f7c2b9fd7e82b7a775fe4090740d66))


### Bug Fixes

* **autocmd:** preserve current tabpage ([750cbed](https://github.com/gametaro/dotfiles/commit/750cbed5232bad1baa295e89fa4fb329ce585ec2))
* **cursorline:** fast activate on `WinEnter` ([99cf2cd](https://github.com/gametaro/dotfiles/commit/99cf2cd5f4c9a6764e3ebef52bdf96b636e9b4ed))
* **heirline:** check nil ([42c3532](https://github.com/gametaro/dotfiles/commit/42c3532760be5a45fea1e58d87cfc8c9a0b3300b))
* **lsp:** correct pattern of match ([9b809e4](https://github.com/gametaro/dotfiles/commit/9b809e437812a14ef1bb8b86ed518d24c360616c))
* **lsp:** remove unneeded matching ([8e33507](https://github.com/gametaro/dotfiles/commit/8e33507e72b6c3af6f217cf90db3dfa4cef26fa3))
* **qf:** do not open when failed ([11486fe](https://github.com/gametaro/dotfiles/commit/11486fe96aa85fc4659ac21848beeddd099c7833))
* **qf:** preserve current window ([d91cf61](https://github.com/gametaro/dotfiles/commit/d91cf61871946a3110b62a4756fe7a45d8256b3f))
* **walkthrough:** lint errors ([dda7680](https://github.com/gametaro/dotfiles/commit/dda768028ce0f9795688c588ae83ef021a09c424))

## [2.1.0](https://github.com/gametaro/dotfiles/compare/v2.0.0...v2.1.0) (2023-02-14)


### Features

* **colorscheme:** re-invent ([10bcf02](https://github.com/gametaro/dotfiles/commit/10bcf0275f2cd3af4eedce2e05c7dcc6b3c4f4df))
* **plugins:** add `replacer.nvim` ([c35242c](https://github.com/gametaro/dotfiles/commit/c35242cc808e8a41ef8119c868a3e3c933bbf30a))


### Bug Fixes

* **lsp:** disable mapping as it conflicts with tab's one ([229bb92](https://github.com/gametaro/dotfiles/commit/229bb92bba436e52992a00595bc81b47cbf11009))
* **lsp:** rename lua-language-server ([8c8ff8a](https://github.com/gametaro/dotfiles/commit/8c8ff8a036bc6347a6bcfb32a80f540893a86ab5))
* **qf:** prefer lwindow to cwindow ([2f9e3a6](https://github.com/gametaro/dotfiles/commit/2f9e3a659c6a7bb93469a153e6d7af1fd99955a9))
* **telescope:** correct `file_ignore_patterns` ([5483aa5](https://github.com/gametaro/dotfiles/commit/5483aa5810f0931b1e5c6873956ea348d0946fe1))

## [2.0.0](https://github.com/gametaro/dotfiles/compare/v1.5.1...v2.0.0) (2023-02-12)


### ⚠ BREAKING CHANGES

* **mapping:** replace `<LocalLeader>` with `<Leader>`

### Features

* **gitsigns:** update qf/locationlist when opening window ([4b5df90](https://github.com/gametaro/dotfiles/commit/4b5df90bc2860d3a5a2e98eb0082e8ac9279d867))


### Bug Fixes

* **smart-insert:** work on empty line ([c69d2ff](https://github.com/gametaro/dotfiles/commit/c69d2ff3482649c16e7a892e7ace5ce8ed35dbd3))


### Code Refactoring

* **mapping:** replace `&lt;LocalLeader&gt;` with `<Leader>` ([995b911](https://github.com/gametaro/dotfiles/commit/995b9116add7206f06a4b9b505060be159476966))

## [1.5.1](https://github.com/gametaro/dotfiles/compare/v1.5.0...v1.5.1) (2023-02-09)


### Bug Fixes

* **colorscheme:** set name of catppuccin ([944ef7e](https://github.com/gametaro/dotfiles/commit/944ef7ecc0801ccdef6094e7dd3b6b36d6d13ec7))
* **jump:** set default config ([6f40926](https://github.com/gametaro/dotfiles/commit/6f40926267ef4e0507cdb78974456a354e585def))
* **plugins:** load on `BufNewFile` ([7b2f9b8](https://github.com/gametaro/dotfiles/commit/7b2f9b8cb2cf88f1a501aa98d30c2df64989ac7a))

## [1.5.0](https://github.com/gametaro/dotfiles/compare/v1.4.0...v1.5.0) (2023-02-08)


### Features

* **cmp:** add icons to items from path ([1492a54](https://github.com/gametaro/dotfiles/commit/1492a54509795ffaf3b4d834b8e7a0d745246fde))
* **colorscheme:** add ok and floating highlights ([b8e4dfe](https://github.com/gametaro/dotfiles/commit/b8e4dfedaff47a6af2e64a59ff7805c54e7f374d))
* **plugins:** add `term-edit.nvim` ([c444297](https://github.com/gametaro/dotfiles/commit/c444297c5f30175a961c79d949b15ddbafca3d18))


### Bug Fixes

* **noice:** close floating-window when opening help ([766ffcc](https://github.com/gametaro/dotfiles/commit/766ffcc7958e84cf279e5cbfafe33616158d8e8d))


### Performance Improvements

* **autocmd:** use `vim.loop.spawn` instead of `system` ([59a30b2](https://github.com/gametaro/dotfiles/commit/59a30b270dc2d3ea0d2b2211f9853aceb360b320))

## [1.4.0](https://github.com/gametaro/dotfiles/compare/v1.3.0...v1.4.0) (2023-01-30)


### Features

* **colorscheme:** add colors for terminal ([8b69004](https://github.com/gametaro/dotfiles/commit/8b690044a76b3d56662827d205b2c973ff1c364a))


### Bug Fixes

* **colorscheme:** lint errors ([ae0698c](https://github.com/gametaro/dotfiles/commit/ae0698cec085e4a60e36d1d60420ac983b80f82f))
* **colorscheme:** set terminal color on compile ([515c4c2](https://github.com/gametaro/dotfiles/commit/515c4c2378794f81d358a46568006ceccecea293))

## [1.3.0](https://github.com/gametaro/dotfiles/compare/v1.2.0...v1.3.0) (2023-01-29)


### Features

* **dial:** add special mappings for gitcommit and gitrebase ([6747f6f](https://github.com/gametaro/dotfiles/commit/6747f6fe062e189bed076d39506a2c5340a5b980))


### Bug Fixes

* **cursorline:** enable cursorline on BufEnter ([ca58e2b](https://github.com/gametaro/dotfiles/commit/ca58e2b567253659a0d3967f9288f6bce2b44a34))
* **dial:** load on event instead of keys ([f4efa12](https://github.com/gametaro/dotfiles/commit/f4efa128eb8e83d796128204ca04b5136c11eaf7))
* **util:** check if on headless mode each time ([a768b3d](https://github.com/gametaro/dotfiles/commit/a768b3d8cfb23c9f2f3d04d33726a406176099e4))
* **which-key:** suppress error messages about clipboard ([623cb3b](https://github.com/gametaro/dotfiles/commit/623cb3b9e0134ecb5cf70513a37970cb62041c7c))

## [1.2.0](https://github.com/gametaro/dotfiles/compare/v1.1.1...v1.2.0) (2023-01-25)


### Features

* **noice:** add mapping to redirect cmdline ouptput ([edf6611](https://github.com/gametaro/dotfiles/commit/edf6611d6d78e8a5736b6b07b71193a296d83017))


### Bug Fixes

* **heirline:** create autocmd only in git repository ([4621af9](https://github.com/gametaro/dotfiles/commit/4621af9935ad17ddea8a98b3df6c26097e7fab89))
* **util:** correct title of notification ([c9e2e1e](https://github.com/gametaro/dotfiles/commit/c9e2e1e376189dcec0fdf4c6b704b7c12993cbad))

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
