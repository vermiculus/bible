\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bible}[2013/07/14 A LaTeX Class for typestting Bibles]

%\newcounter{Hpagenote}
%\PassOptionToClass{twocolumn}{memoir}
%\def\Huge{\@setfontsize \Huge \@xxpt {25}}
%\def\LARGE{\@setfontsize \LARGE \@xivpt {18}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax
\LoadClass{memoir}

\RequirePackage{xspace}
\RequirePackage{xcolor}
%\RequirePackage{microtype}\microtypesetup{protrusion=true}
\RequirePackage{xparse}
\RequirePackage{type1cm}
\RequirePackage{lettrine}
\RequirePackage{csquotes}

\usepackage[top=2cm,bottom=3cm,inner=2.5cm,outer=1cm]{geometry}

\newcommand{\LORD}{\textsc{Lord}\xspace}

\ExplSyntaxOn
%\newcounter{book}
\setcounter{book}{0}
\DeclareDocumentCommand{\book}{omo}{
  % #1 Subtitle
  % #2 Title
  \edef\@currbook{\IfNoValueTF{#3}{#2}{#3}}
  \thispagestyle{empty}
  \refstepcounter{book}
  \par\noindent
  {\Huge #2\vspace{1ex}\newline}
  \IfValueTF{#1}{{\LARGE #1}\par\vspace{4ex}}{}
  \addcontentsline{toc}{book}{#2}
  \setcounter{chapter}{0}
}
\bool_new:c{is_first_verse}
\DeclareDocumentCommand{\chapter}{o}{
  \refstepcounter{chapter}
  \vspace{2ex plus .2ex minus .2ex}
  \lettrine[findent=0.5em,nindent=0pt]{\arabic{chapter}}{}
  \IfValueTF{#1}
    {\centerline{\bfseries#1}}{}
  \setcounter{verse}{0}
  \bool_set_true:c{is_first_verse}
}

%\newcounter{verse}[chapter]
%\setcounter{verse}{0}
\DeclareDocumentCommand{\verse}{}{
  \refstepcounter{verse}
  % \ifnum\value{verse} > 1
  \bool_if:cTF{is_first_verse}
    {\bool_set_false:c{is_first_verse}}
    {\textsuperscript{\color{black}\arabic{verse}}
      % \fi
      % 
      % \cs_if_exist_use:c{note \@currbook \arabic{chapter}:\arabic{verse}}
    }
  }

\DeclareDocumentCommand{\Father}{m}{
  \enquote{\textcolor{blue}{#1}}
}
\usepackage{xstring}
\newcommand{\testbook}[1]{\def\inputbook@only{#1}}
\newcommand{\inputbook}[1]{%
  \cs_if_exist:NTF{\inputbook@only}%
    {\IfStrEq{#1}{\inputbook@only}{\input{\bibleversion/#1}\newpage}}
    {\input{\bibleversion/#1}\newpage}%
}

\ExplSyntaxOff

\newcommand{\SetVersion}[1]{\def\bibleversion{#1}}

%\RequirePackage{fontspec}


% Local Variables:
% mode: latex
% TeX-master: "bible.tex"
% TeX-engine: default
% TeX-PDF-mode: t
% End:
