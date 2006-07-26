" Vim syntax file for the TreeDL 2.3 language
" 
" Language:		TreeDL
" Last Change:	2006 Jul 10
" Version:		0.1
"
" Options:
" 	treedl_target_language - highlight inside of code blocks,
" 							 currently "java" or "csharp"
"
" Todo:
"	- Fix comments highlighting in node, enum, flags and operation headers.
" 	- Highlight bogus parens, comments etc.
" 	- Is syncing from start ok?

if exists("b:current_syntax")
  finish
endif

syn case match

if exists("treedl_target_language")
  if treedl_target_language == "java"
    syn include @tdlTargetLang syntax/java.vim
  elseif treedl_target_language == "csharp"
    syn include @tdlTargetLang syntax/cs.vim
  endif
endif

" Properties
syn region	tdlProperties		start="\[" end="\]" contains=@tdlComment,tdlPropertiesDelim,tdlBool,tdlInt,tdlString
syn match	tdlPropertiesDelim	contained "[=;]"

" `tree' and `module'
syn match	tdlModule			"\<\(tree\|module\)\>" nextgroup=tdlModuleName skipwhite skipnl skipempty
syn match	tdlModuleName		contained "[^;]*;" contains=tdlModuleDelim,tdlUserType
syn match	tdlModuleDelim		contained "[:,;]"

" `header' and `body'
syn match	tdlHeaderBody		"\<\(header\|body\)\>" nextgroup=tdlCode skipwhite skipnl skipempty

" `enum' and `flags'
syn match	tdlConst			"\<\(enum\|flags\)\>" nextgroup=tdlConstHeader skipwhite skipnl skipempty
syn region	tdlConstHeader		contained start="\h" end="{"me=e-1 contains=tdlConstHeaderDelim nextgroup=tdlConstBody skipwhite skipnl skipempty
syn match	tdlConstHeaderDelim	contained ":"
syn region	tdlConstBody		contained start="{" end="}" contains=@tdlComment,tdlConstBodyDelim
syn match	tdlConstBodyDelim	contained ","

" `node'
syn match	tdlNodeModifier		"\<\(abstract\|root\)\>"
syn match	tdlNode				"\<node\>" nextgroup=tdlNodeHeader skipwhite skipempty skipnl
syn region	tdlNodeHeader		contained start="\h" end="{"me=e-1 contains=tdlNodeHeaderDelim,tdlUserType nextgroup=tdlNodeBody skipwhite skipnl skipempty
syn match	tdlNodeHeaderDelim	contained "[,:]"
syn region	tdlNodeBody			contained start="{" end="}" contains=@tdlComment,tdlNodeBodyDelim,tdlNodeCode,tdlNodeKeyword,tdlPredefinedType,tdlUserType
syn match	tdlNodeBodyDelim	contained "[;?\*+:]"

" `set', `get', `constructor', `body'
syn match	tdlNodeCode			contained "\<\(set\|get\|constructor\|body\)\>\|=" nextgroup=tdlCode skipwhite skipnl skipempty

" Keywords inside `node'
syn keyword tdlNodeKeyword		contained child attribute setonce noset late override custom

" `operation'
syn match	tdlOpModifier		"\<virtual\>"
syn match	tdlOp				"\<operation\>" nextgroup=tdlOpHeader skipwhite skipnl skipempty
syn region	tdlOpHeader			contained start="\h" end="{"me=e-1 contains=tdlOpHeaderDelim,tdlOpKeyword,tdlOpModifier,tdlPredefinedType,tdlUserType nextgroup=tdlOpBody skipwhite skipnl skipempty
syn match	tdlOpHeaderDelim	contained "[:,]"
syn region	tdlOpBody			contained start="{" end="}" contains=@tdlComment,tdlOpCode

" `case'
syn region	tdlOpCode			contained matchgroup=Keyword start="\<case\>" matchgroup=Delimiter end=":" nextgroup=tdlCode skipwhite skipnl skipempty

" Keywords inside `operation' header
syn keyword	tdlOpKeyword		contained void

" Predefined types
syn keyword	tdlPredefinedType	contained object bool string char short int long float double

" User type
syn region	tdlUserType			contained matchgroup=Delimiter start="<" end=">" contains=@tdlTargetLang

" Code block
syn region	tdlCode				contained start="{" end="}" contains=tdlCode,@tdlTargetLang

" Comments
syn region	tdlCommentC			start="\/\*" end="\*\/" contains=tdlCommentTodo
syn region	tdlCommentCpp		start="//" end="$" keepend contains=tdlCommentTodo
syn cluster	tdlComment			contains=tdlCommentC,tdlCommentCpp
syn match	tdlCommentTodo		contained "TODO\|XXX\|FIXME"

" Literals
syn match	tdlBool				contained "\<\(true\|false\)\>"
syn match	tdlInt				contained "-\?\d\+"
syn region	tdlString			contained start="\"" skip="\\\"" end="\"" contains=none

"hi def link tdlNodeBody			Todo

hi def link tdlProperties		Preproc
hi def link tdlPropertiesDelim	Delimiter
hi def link tdlModule			Keyword
hi def link tdlModuleDelim		Delimiter
hi def link tdlHeaderBody		Keyword
hi def link tdlConst			Type
hi def link tdlConstHeaderDelim	Delimiter
hi def link tdlConstBodyDelim	Delimiter
hi def link tdlNodeModifier		Keyword
hi def link tdlNode				Type
hi def link tdlNodeHeaderDelim	Delimiter
hi def link tdlNodeBodyDelim	Delimiter
hi def link tdlNodeCode			Keyword
hi def link tdlNodeKeyword		Keyword
hi def link tdlPredefinedType	Type
hi def link tdlOpModifier		Keyword
hi def link tdlOp				Type
hi def link tdlOpHeaderDelim	Delimiter
hi def link tdlOpKeyword		Keyword

hi def link tdlCommentC			Comment
hi def link tdlCommentCpp		Comment
hi def link tdlCommentTodo		Todo
hi def link tdlBool				Boolean
hi def link tdlInt				Number
hi def link tdlString			String

" Speed up highlighting of the c-style comments
syn sync ccomment tdlCommentC
" Make highlighting slow but accurate
syn sync fromstart

let b:current_syntax = "tdl"

" vim: ts=4
