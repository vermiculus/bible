\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{bible}{2013/07/14}{1.0}{Typesetting bibles}

\RequirePackage{xparse}

%\newcounter{Hpagenote}
%\PassOptionToClass{twocolumn}{memoir}
%\def\Huge{\@setfontsize \Huge \@xxpt {25}}
%\def\LARGE{\@setfontsize \LARGE \@xivpt {18}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax
\LoadClass{memoir}

\RequirePackage{geometry}
\geometry{top=2cm,bottom=3cm,inner=2.5cm,outer=1cm}

\let\footruleskip\relax
\RequirePackage{fancyhdr}
\fancyhead[LE,RO]{\@ifundefined{@currbook}{}{\@currbook}}

\RequirePackage{xspace}
\RequirePackage{csquotes}
\RequirePackage{hyperref}
\RequirePackage{xcolor}
\NewDocumentCommand {\LORD} {} { \textsc{Lord} \xspace }

\int_new:N \g_bible_book_index_int
\int_new:N \g_bible_chap_index_int

\cs_new:Nn \bible_tl_default_to:NN {
  \tl_if_empty:NT #1 { \tl_set_eq:NN #1 #2 }
}

\setcounter{book}{0}

\keys_define:nn { bible / book } {
  name              .tl_gset:N  = \g_bible_book_name_tl,
  reference-label   .tl_gset:N  = \g_bible_book_reference_label_tl,
  toc-name          .tl_gset:N  = \g_bible_book_toc_name_tl,
  subtitle          .tl_gset:N  = \g_bible_book_subtitle_tl,
  author            .tl_gset:N  = \g_bible_book_author_tl,
  year-start        .int_gset:N = \g_bible_book_year_start_int,
  year-end          .int_gset:N = \g_bible_book_year_end_int,
  pdf-bookmark-name .tl_gset:N  = \g_bible_book_pdf_bookmark_name_tl,
}

\cs_new:Nn \bible_book_process_keys:n {
  \keys_set:nn { bible / book } { #1 }
  \bible_tl_default_to:NN \g_bible_book_toc_name_tl \g_bible_book_name_tl
  \bible_tl_default_to:NN \g_bible_book_pdf_bookmark_name_tl \g_bible_book_toc_name_tl
}

\DeclareDocumentCommand \Book { m } {
  \int_gincr:N \g_bible_book_index_int
  \bible_book_process_keys:n { #1 }

  \pdfbookmark[0]{ \g_bible_book_toc_name_tl }{ \g_bible_book_toc_name_tl }

  % Typeset main title
  \par\noindent
  {\Huge \tl_use:N \g_bible_book_name_tl \vspace{1ex}\par\noindent}

  % Typeset subtitle if it exists, otherwise do nothing
  \tl_if_empty:NF \g_bible_book_subtitle_tl {
    {\LARGE \tl_use:N \g_bible_book_subtitle_tl \par \vspace{4ex}}
  }

  \int_gzero:N \g_bible_chap_index_int
}

\RequirePackage{lettrine}
\keys_define:nn { bible / chapter } {
  name .tl_set:N = \g_bible_chap_name_tl
}
\DeclareDocumentCommand \Chapter {o}{
  \int_gincr:N \g_bible_chap_index_int
  \tl_gclear:N \g_bible_chap_name_tl
  \IfValueT{#1}{ \keys_set:nn { bible / chap } {#1} }

  \bigskip

  \int_compare:nF { \g_bible_chap_index = 1 } {
    \lettrine[findent=0.5em,nindent=0pt]
    {
      \tl_set:No \l_tmpa_tl { \int_to_arabic:n { \int_use:N \g_bible_chap_index_int } }
      {\Large \l_tmpa_tl}
      \pdfbookmark[1]{ Chapter~\l_tmpa_tl }{\g_bible_book_toc_name_tl / \l_tmpa_tl }
    }{}\relax
  }

  \tl_if_empty:NF \g_bible_chap_name_tl {
    \centerline{\bfseries \tl_use:N \g_bible_chap_name_tl }
  }

  \int_gzero:N \g_bible_verse_index_int
}

\DeclareDocumentCommand \Verse {} {
  \int_gincr:N \g_bible_verse_index_int
  \tl_set:No \l_tmpa_tl { \int_to_arabic:n { \int_use:N \g_bible_verse_index_int } }

  % If this is the first verse, don't typeset its little index
  \int_compare:nF { \g_bible_verse_index_int = 1 }
    {\textsuperscript{\color{black}\tl_use:N \l_tmpa_tl}}
    \noindent

  \relax
}

\DeclareDocumentCommand {\NewSpeaker} {mmmoo}
 {
  % interface to \bible_speaker_new:Nnnnn
  \bible_speaker_new:Nnnnn #1 {#2} {#3} { \IfValueT {#4} {#4} } { \IfValueT {#5} {#5} }
 }

\cs_new_nopar:Nn \bible_speaker_new:Nnnnn
 {
  % #1 csname
  % #2 text color direct
  % #3 text color indirect
  % #4 arbitrary insert code before
  % #5 arbitrary insert code after
  \NewDocumentCommand {#1} { s m }
   {
    #4
    \IfBooleanTF{##1}
     { \enquote* { \textcolor {#3} {##2} } }
     { \enquote  { \textcolor {#2} {##2} } }
    #5
   }
 }

\tl_new:N \g_bible_input_only_book_tl
\tl_new:N \g_bible_version_tl
\NewDocumentCommand \InputOnlyBook { m } {
  \tl_gset:Nn \g_bible_input_only_book_tl { #1 }
}
\NewDocumentCommand \BibleVersion { m } {
  \tl_gset:Nn \g_bible_version_tl { #1 }
}
\NewDocumentCommand \InputBook { mm } {
  \Book{#1}
  \bool_if:nT {
    ! \tl_if_empty_p:N \g_bible_input_only_book_tl ||
    \tl_if_eq_p:NN \g_bible_input_only_book_tl \l_tmpa_tl
  } {
    \input{\g_bible_version_tl / #2}
  }
}

% Local Variables:
% mode: latex
% TeX-master: "bible.tex"
% TeX-engine: default
% TeX-PDF-mode: t
% End: