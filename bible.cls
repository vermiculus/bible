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
%\RequirePackage{microtype}
%\microtypesetup{enable}
%\microtypesetup{expansion=true}
%\microtypesetup{protrusion=true}
%\microtypesetup{kerning=true}
%\microtypesetup{tracking=true}
\RequirePackage{xparse}
\RequirePackage{hyperref}

%\usepackage[asymmetric,top=2cm,bottom=4cm,inner=5cm,outer=1.5cm]{geometry}
\usepackage[top=2cm,bottom=4cm,inner=2.5cm,outer=1cm]{geometry}

\newcommand{\LORD}{\textsc{Lord}\xspace}

\ExplSyntaxOn
%\newcounter{book}
\setcounter{book}{0}
\DeclareDocumentCommand{\book}{om}{
  % #1 Subtitle
  % #2 Title
  \thispagestyle{empty}
  \refstepcounter{book}
  \def\@currbiblebook{#2}
  \par\noindent
  {\Huge #2\vspace{1ex}\newline}
  {\LARGE #1}\par\vspace{4ex}
  \addcontentsline{toc}{book}{#2}
  \setcounter{chapter}{0}
}

%\newcounter{chapter}[book]
%\setcounter{chapter}{0}
\DeclareDocumentCommand{\chapter}{o}{
  \refstepcounter{chapter}
  \vspace{2ex plus .2ex minus .2ex}
  {{\Large \arabic{chapter}}
    \IfNoValueTF{#1}
      {}
      {\quad{\bfseries #1}}
  }
  \setcounter{verse}{0}
}

%\newcounter{verse}[chapter]
%\setcounter{verse}{0}
\DeclareDocumentCommand{\verse}{}{
  \refstepcounter{verse}
  \textsuperscript{\arabic{verse}}
}

\DeclareDocumentCommand{\LordSays}{m}{
  \textcolor{red}{#1}
}
\ExplSyntaxOff


%\RequirePackage{fontspec}


% Local Variables:
% mode: latex
% TeX-master: "bible.tex"
% TeX-engine: xetex
% TeX-PDF-mode: t
% End:
