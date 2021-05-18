-- Render TeX and LaTeX like the `\TeX` and `\LaTeX{}` macros do.
-- Copyright © 2020 Albert Krewinkel <albert+pandoc@zeitkraut.de>
-- License: MIT License

-- Style inspired by https://tess.oconnor.cx/2007/08/tex-poshlet
local style = pandoc.RawBlock('html', [[
<style>
.tex-logo sub, .latex-logo sub {
  font-size: 100%;
  margin-left: -0.1667em;
  margin-right: -0.125em;
  vertical-align: -0.5ex;
}
.latex-logo sup {
  font-size: 0.85em;
  margin-left: -0.36em;
  margin-right: -0.15em;
  vertical-align: 0.15em;
}
</style>
]])

local tex_text = pandoc.List{
  pandoc.Str 'T',
  pandoc.Subscript{pandoc.Str 'E'},
  pandoc.Str 'X'
}
local latex_text = pandoc.List{
  pandoc.Str 'L',
  pandoc.Superscript{pandoc.Str 'A'}
} .. tex_text

local make_logo

if FORMAT:match 'tex$' then
  make_logo = function (logo_text)
    if logo_text == 'LaTeX' then
      return pandoc.RawInline('latex', '\\LaTeX{}')
    elseif logo_text == 'TeX' then
      return pandoc.RawInline('tex', '\\TeX{}')
    else
      return nil
    end
  end
else
  make_logo = function (logo_text)
    if logo_text == 'TeX' then
      return pandoc.Span(
        tex_text,
        pandoc.Attr("", {"tex-logo"})
      )
    elseif logo_text == 'LaTeX' then
      return pandoc.Span(
        latex_text,
        pandoc.Attr("", {"latex-logo"})
      )
    else
      return nil
    end
  end
end

function RawInline (raw)
  if not raw.format:match 'tex$' then return nil end
  local logo_text = raw.text:match '^\\(L?a?TeX)[%b{}]?'
  return make_logo(logo_text)
end

function Str (str)
  local logo_text, suffix = str.text:match '^(L?a?TeX)([^%a%*]?.*)'
  if logo_text then
    return {
      make_logo(logo_text),
      suffix ~= '' and pandoc.Str(suffix) or nil
    }
  end
end

if FORMAT:match 'html' then
  function Meta (meta)
    local header_includes = meta['header-includes'] or pandoc.MetaList{}
    if header_includes.t ~= 'MetaList' then
      header_includes = pandoc.MetaList(header_includes)
    end
    header_includes:insert{style}
    meta['header-includes'] = header_includes
    return meta
  end
end
