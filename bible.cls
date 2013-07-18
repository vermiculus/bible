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

\DeclareDocumentCommand{\chapter}{o}{
  \refstepcounter{chapter}
  \vspace{2ex plus .2ex minus .2ex}
  \lettrine[lines=3]{\arabic{chapter}}{}
  \IfValueTF{#1}
    {\centerline{\bfseries#1}\newline}{}
  \setcounter{verse}{0}
}

%\newcounter{verse}[chapter]
%\setcounter{verse}{0}
\DeclareDocumentCommand{\verse}{}{
  \refstepcounter{verse}
  \textsuperscript{\color{black}\arabic{verse}}
}

\DeclareDocumentCommand{\Father}{m}{
  \textcolor{red}{#1}
}
\ExplSyntaxOff


%\RequirePackage{fontspec}


% Local Variables:
% mode: latex
% TeX-master: "bible.tex"
% TeX-engine: default
% TeX-PDF-mode: t
% End:
