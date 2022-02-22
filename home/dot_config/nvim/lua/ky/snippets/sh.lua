local sn = require('ky.snippets.helpers').sn
local s = require('ky.snippets.helpers').s
local t = require('ky.snippets.helpers').t
local c = require('ky.snippets.helpers').c
local i = require('ky.snippets.helpers').i
local r = require('ky.snippets.helpers').r
local fmt = require('ky.snippets.helpers').fmt
local fmta = require('ky.snippets.helpers').fmta
local ins_generate = require('ky.snippets.helpers').ins_generate
local rep_generate = require('ky.snippets.helpers').rep_generate

return {
  s(
    'sh',
    c(1, {
      t('#!/bin/sh'),
      t('#!/usr/bin/env sh'),
    })
  ),
  s(
    'bash',
    c(1, {
      t('#!/bin/bash'),
      t('#!/usr/bin/env bash'),
    })
  ),
  s('echo', fmt('echo "{}"', ins_generate())),
  s('read', fmt('read -r {}', ins_generate())),
  s(
    'f',
    c(1, {
      sn(
        nil,
        fmta(
          [[
          <> () {
            <>
          }
          ]],
          rep_generate()
        )
      ),
      sn(
        nil,
        fmta(
          [[
          function <> () {
            <>
          }
          ]],
          rep_generate()
        )
      ),
    })
  ),
  s(
    'for',
    fmt(
      [[
      for {} in {}; do
        {}
      done
      ]],
      ins_generate()
    )
  ),
  s(
    'if',
    c(1, {
      sn(
        nil,
        fmt(
          [[
          if [ {} ]; then
            {}
          fi
          ]],
          rep_generate()
        )
      ),
      sn(
        nil,
        fmt(
          [=[
          if [[ {} ]]; then
            {}
          fi
          ]=],
          rep_generate()
        )
      ),
    })
  ),
  s(
    'else',
    fmt(
      [[
      else
        {}
      ]],
      ins_generate()
    )
  ),
  s(
    'elif',
    c(1, {
      sn(
        nil,
        fmt(
          [[
          elif [ {} ]; then
            {}
          ]],
          rep_generate()
        )
      ),
      sn(
        nil,
        fmt(
          [=[
          elif [[ {} ]]; then
            {}
          ]=],
          rep_generate()
        )
      ),
    })
  ),
  s(
    'ifelse',
    c(1, {
      sn(
        nil,
        fmt(
          [[
          if [ {} ]; then
            {}
          else
            {}
          fi
          ]],
          rep_generate()
        )
      ),
      sn(
        nil,
        fmt(
          [=[
          if [[ {} ]]; then
            {}
          else
            {}
          fi
          ]=],
          rep_generate()
        )
      ),
    })
  ),
  s(
    'while',
    c(1, {
      sn(
        nil,
        fmt(
          [[
          while [ {} ]; do
            {}
          done
          ]],
          rep_generate()
        )
      ),
      sn(
        nil,
        fmt(
          [=[
          while [[ {} ]]; do
            {}
          done
          ]=],
          rep_generate()
        )
      ),
    })
  ),
  s(
    'while read',
    fmt(
      [[
      while read -r {}; do
        {}
      done
      ]],
      ins_generate()
    )
  ),
  s(
    'until',
    c(1, {
      sn(
        nil,
        fmt(
          [[
          until [ {} ]; do
            {}
          done
          ]],
          rep_generate()
        )
      ),
      sn(
        nil,
        fmt(
          [=[
          until [[ {} ]]; do
            {}
          done
          ]=],
          rep_generate()
        )
      ),
    })
  ),
}
