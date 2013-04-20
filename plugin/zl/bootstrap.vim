if !exists('g:GoldenView_zl_bundle_path') 
  let g:GoldenView_zl_bundle_path = fnamemodify(expand("<sfile>"), ":p:h:h:h")
  let g:GoldenView_zl_autoload_path = expand(g:GoldenView_zl_bundle_path . '/autoload/GoldenView/zl')
end

