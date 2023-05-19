%----------------------------------------------------------------------------------------
% CV class file
%
% Template adapted from http://www.latextemplates.com
%
% Original header:
% Copyright (C) 2010 by Trey Hunner
%----------------------------------------------------------------------------------------

\ProvidesClass{cv}[2013/12/12 Curriculum Vitae class]
\LoadClass[11pt,a4paper]{article} % Font size and paper type

\usepackage[left=0.75in,top=0.6in,right=0.75in,bottom=0.6in]{geometry} % Document margins
\usepackage[parfill]{parskip} % Remove paragraph indentation
\usepackage{array} % Required for boldface (\bf and \bfseries) tabular columns
\usepackage{ifthen} % Required for ifthenelse statements
\usepackage{titlesec} % Required for title styling
\RequirePackage[pdfusetitle]{hyperref}
\usepackage{bookmark}
\usepackage{enumitem} % Control layout of lists

\pagestyle{empty} % Suppress page numbers

%----------------------------------------------------------------------------------------
%	HEADINGS COMMANDS: Commands for printing name and address
%----------------------------------------------------------------------------------------

\def \name#1{\def\@name{#1}} % Defines the \name command to set name
\def \@name {} % Sets \@name to empty by default

\def \addressSep {$\cdot$}

% One, two or three address lines can be specified
\let \@addressone \relax
\let \@addresstwo \relax
\let \@addressthree \relax

% \address command can be used to set the first, second, and third address (last 2 optional)
\def \address #1{
  \@ifundefined{@addresstwo}{
    \def \@addresstwo {#1}
  }{
  \@ifundefined{@addressthree}{
  \def \@addressthree {#1}
  }{
     \def \@addressone {#1}
  }}
}

% \printaddress is used to style an address line (given as input)
\def \printaddress #1{
  \begingroup
    \def \\ {\addressSep\ }
    \centerline{#1}
  \endgroup
  \par
  \addressskip
}

% \printname is used to print the name as a page header
\def \printname {
  \begingroup
    \hfil{\MakeUppercase{\titlesize\bf \@title}}\hfil
    \titleskip\break
    \hfil{\centerline{\namesize\bf \@name}}\hfil
    \nameskip\break
  \endgroup
}

%----------------------------------------------------------------------------------------
%	PRINT THE HEADING LINES
%----------------------------------------------------------------------------------------

\let\ori@document=\document
\renewcommand{\document}{
  \ori@document  % Begin document
  \printname % Print the name specified with \name
  \@ifundefined{@addressone}{}{ % Print the first address if specified
    \printaddress{\@addressone}}
  \@ifundefined{@addresstwo}{}{ % Print the second address if specified
    \printaddress{\@addresstwo}}
     \@ifundefined{@addressthree}{}{ % Print the third address if specified
    \printaddress{\@addressthree}}
}

%----------------------------------------------------------------------------------------
%	SECTION FORMATTING
%----------------------------------------------------------------------------------------

\titlespacing*{\section}
    {0pt}{2ex plus 1ex minus .2ex}{1ex plus .2ex}

\titlespacing*{\subsection}
    {0pt}{2ex plus 1ex minus .2ex}{1ex plus .2ex}

\titleformat{\section}
    {\Large\bfseries}{}{0em}{\MakeUppercase}[{\vskip5pt\titlerule[0.4pt]}]

\titleformat{\subsection}
    {\bfseries\itshape}{}{0em}{}

%----------------------------------------------------------------------------------------
%	WORK EXPERIENCE FORMATTING
%----------------------------------------------------------------------------------------

\setlist{noitemsep, topsep=0pt, leftmargin=1em} % Compress items in list together for aesthetics
\def\labelitemi{$\cdot$}

\newenvironment{experienceplain}[4]{ % 4 input arguments - company name, year(s) employed, job title and location
 {\bf #1} \hfill {#2} % Bold job title, and date on the right
 \ifthenelse{\equal{#3}{}}{}{ % If the third argument is not specified, don't print the job title and location line
  \\
  {\em #3} \hfill {\em #4} % Italic company name and location
  \\[-1.5ex]
  }
}{
  \vspace{1.5ex} % Some space after the list of bullet points
  \pagebreak[3] % This is a very nice place to break a page
}

\newenvironment{experience}[4]{ % Plain environment but starts a list
  \begin{experienceplain}{#1}{#2}{#3}{#4}
  \begin{itemize}
}{
  \end{itemize}
  \end{experienceplain}
}

% The below commands define the whitespace after certain things in the document - they can be \smallskip, \medskip or \bigskip
\def\titlesize{\huge} % Size of the name at the top of the document
\def\namesize{\large} % Size of the name at the top of the document
\def\addressskip{\smallskip} % The space between the two address (or phone/email) lines
\def\sectionlineskip{\medskip} % The space above the horizontal line for each section
\def\titleskip{\smallskip} % The space after your name at the top
\def\nameskip{\bigskip} % The space after your name at the top
\def\sectionskip{\medskip} % The space after the heading section
