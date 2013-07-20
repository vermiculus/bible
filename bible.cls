\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bible}[2013/07/14 A LaTeX Class for typestting Bibles]
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

\ExplSyntaxOn
\RequirePackage{xspace}
\NewDocumentCommand{\LORD}{}{
  \textsc{Lord}\xspace
}

%\newcounter{book}
\setcounter{book}{0}
\DeclareDocumentCommand{\book}{omo}{
  % #1 Subtitle
  % #2 Title
  % #3 key (default #2)

  % Step the book counter
  \refstepcounter{book}

  % define book key (used in notes)
  \edef\@currbook{\IfNoValueTF{#3}{#2}{#3}}

  % Don't display page numbers on pages that list a book
  \thispagestyle{empty}

  % Typeset main title
  \par\noindent
  {\Huge #2\vspace{1ex}\newline}

  % Typeset subtitle if it exists, otherwise do nothing
  \IfValueTF{#1}{{\LARGE #1}\par\vspace{4ex}}{}

  % Reset the chapter counter
  \setcounter{chapter}{0}
}

\RequirePackage{lettrine}
\bool_new:c{is_first_verse}
\DeclareDocumentCommand{\chapter}{o}{
  % #1 Title

  % Step the chapter counter
  \refstepcounter{chapter}

  % Seperate chapters with a bit of space
  \vspace{2ex plus .2ex minus .2ex}

  % Fancy chapter numbers
  \lettrine[findent=0.5em,nindent=0pt]{\arabic{chapter}}{}

  % If we have a chapter title, typeset it centered on the first line
  \IfValueTF{#1}
    {\centerline{\bfseries#1}}{}

  % Reset the verse counter

  \setcounter{verse}{0}

  % Set prohibit typesetting the index of the first verse
  \bool_set_true:c{is_first_verse}
}

\DeclareDocumentCommand{\verse}{}{
  % Step the verse counter
  \refstepcounter{verse}

  % If this is the first verse, don't typeset its little index
  \bool_if:cTF{is_first_verse}
    {\bool_set_false:c{is_first_verse}}
    {\textsuperscript{\color{black}\arabic{verse}}}
  }

\RequirePackage{csquotes,xcolor}
\DeclareDocumentCommand{\NewSpeaker}{mommo}{
  % #1 csname
  % #2 arbitrary insert code before
  % #3 text color direct
  % #4 text color indirect
  % #5 arbitrary insert code after
  \NewDocumentCommand{#1}{sm}{
    % If starred, change the color and star the quote
    \IfBooleanTF{##1}
      {
        \textcolor{black}{
          \enquote*{\textcolor {#4} {##2}}
        }
      }
      {
        \textcolor{black}{
          \enquote{\textcolor {#3} {##2}}
        }
      }
    }
  }



\RequirePackage{xstring}
\newcommand{\testbook}[1]{\def\inputbook@only{#1}}
\newcommand{\inputbook}[1]{
  \begingroup
    \cs_if_exist:NTF{\inputbook@only}
      {\IfStrEq{#1}{\inputbook@only}{\input{\bibleversion/#1}\clearpage}}
      {\input{\bibleversion/#1}\clearpage}
  \endgroup
}

\ExplSyntaxOff

\newcommand{\SetVersion}[1]{\def\bibleversion{#1}}


% Local Variables:
% mode: latex
% TeX-master: "bible.tex"
% TeX-engine: default
% TeX-PDF-mode: t
% End:
