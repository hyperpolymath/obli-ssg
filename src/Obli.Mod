(* SPDX-License-Identifier: AGPL-3.0-or-later *)
(* SPDX-FileCopyrightText: 2025 hyperpolymath *)
(*
 * obli-ssg - Oberon Static Site Generator
 * "Let modules import. Let procedures export. Let sites compile."
 *
 * Compile with: obnc Obli.Mod
 * Run with: ./Obli build | init | clean
 *)

MODULE Obli;

IMPORT Files, Strings, Out, Args := extArgs;

CONST
    ContentDir = "content";
    OutputDir = "_site";
    SiteTitle = "Obli Site";
    MaxLine = 1024;
    MaxBuffer = 32000;

VAR
    pageTitle: ARRAY 256 OF CHAR;
    pageDate: ARRAY 32 OF CHAR;
    pageDraft: BOOLEAN;
    bodyStart: INTEGER;

(* String utilities *)
PROCEDURE Trim(VAR s: ARRAY OF CHAR);
VAR
    i, j, len: INTEGER;
BEGIN
    len := Strings.Length(s);
    i := 0;
    WHILE (i < len) & (s[i] = " ") DO INC(i) END;
    IF i > 0 THEN
        j := 0;
        WHILE i < len DO s[j] := s[i]; INC(i); INC(j) END;
        s[j] := 0X;
        len := j
    END;
    WHILE (len > 0) & (s[len-1] = " ") DO DEC(len) END;
    s[len] := 0X
END Trim;

PROCEDURE StartsWith(s, prefix: ARRAY OF CHAR): BOOLEAN;
VAR
    i, sLen, pLen: INTEGER;
BEGIN
    sLen := Strings.Length(s);
    pLen := Strings.Length(prefix);
    IF sLen < pLen THEN RETURN FALSE END;
    i := 0;
    WHILE (i < pLen) & (s[i] = prefix[i]) DO INC(i) END;
    RETURN i = pLen
END StartsWith;

PROCEDURE EscapeHTML(s: ARRAY OF CHAR; VAR result: ARRAY OF CHAR);
VAR
    i, j, len: INTEGER;
    c: CHAR;
BEGIN
    len := Strings.Length(s);
    j := 0;
    FOR i := 0 TO len - 1 DO
        c := s[i];
        IF c = "&" THEN
            result[j] := "&"; INC(j);
            result[j] := "a"; INC(j);
            result[j] := "m"; INC(j);
            result[j] := "p"; INC(j);
            result[j] := ";"; INC(j)
        ELSIF c = "<" THEN
            result[j] := "&"; INC(j);
            result[j] := "l"; INC(j);
            result[j] := "t"; INC(j);
            result[j] := ";"; INC(j)
        ELSIF c = ">" THEN
            result[j] := "&"; INC(j);
            result[j] := "g"; INC(j);
            result[j] := "t"; INC(j);
            result[j] := ";"; INC(j)
        ELSE
            result[j] := c; INC(j)
        END
    END;
    result[j] := 0X
END EscapeHTML;

(* File I/O *)
PROCEDURE ReadLine(f: Files.File; VAR line: ARRAY OF CHAR; VAR eof: BOOLEAN);
VAR
    r: Files.Rider;
    c: CHAR;
    i: INTEGER;
BEGIN
    Files.Set(r, f, Files.Pos(r));
    i := 0;
    REPEAT
        Files.Read(r, c);
        IF r.eof THEN
            eof := TRUE;
            line[i] := 0X;
            RETURN
        END;
        IF (c # 0AX) & (c # 0DX) THEN
            line[i] := c;
            INC(i)
        END
    UNTIL (c = 0AX) OR (i >= MaxLine - 1);
    line[i] := 0X;
    eof := FALSE
END ReadLine;

PROCEDURE WriteString(f: Files.File; s: ARRAY OF CHAR);
VAR
    r: Files.Rider;
    i, len: INTEGER;
BEGIN
    Files.Set(r, f, Files.Length(f));
    len := Strings.Length(s);
    FOR i := 0 TO len - 1 DO
        Files.Write(r, s[i])
    END
END WriteString;

PROCEDURE WriteLn(f: Files.File; s: ARRAY OF CHAR);
BEGIN
    WriteString(f, s);
    WriteString(f, CHR(10))
END WriteLn;

(* Frontmatter parser *)
PROCEDURE ParseFrontmatter(f: Files.File);
VAR
    line, key, value: ARRAY MaxLine OF CHAR;
    eof: BOOLEAN;
    colonPos, i: INTEGER;
BEGIN
    COPY("Untitled", pageTitle);
    pageDate[0] := 0X;
    pageDraft := FALSE;
    bodyStart := 0;

    ReadLine(f, line, eof);
    IF eof THEN RETURN END;
    Trim(line);
    IF ~Strings.Equal(line, "---") THEN RETURN END;

    LOOP
        ReadLine(f, line, eof);
        IF eof THEN EXIT END;
        Trim(line);
        IF Strings.Equal(line, "---") THEN
            bodyStart := Files.Pos(Files.Base(f));
            EXIT
        END;

        colonPos := Strings.Pos(":", line, 0);
        IF colonPos >= 0 THEN
            Strings.Extract(line, 0, colonPos, key);
            Strings.Extract(line, colonPos + 1, Strings.Length(line) - colonPos - 1, value);
            Trim(key);
            Trim(value);

            IF Strings.Equal(key, "title") THEN
                COPY(value, pageTitle)
            ELSIF Strings.Equal(key, "date") THEN
                COPY(value, pageDate)
            ELSIF Strings.Equal(key, "draft") THEN
                pageDraft := Strings.Equal(value, "true") OR Strings.Equal(value, "yes")
            END
        END
    END
END ParseFrontmatter;

(* HTML generation *)
PROCEDURE GeneratePage(inF, outF: Files.File);
VAR
    line, trimmed, escaped: ARRAY MaxLine OF CHAR;
    eof: BOOLEAN;
    inCode: BOOLEAN;
BEGIN
    (* HTML header *)
    WriteLn(outF, "<!DOCTYPE html>");
    WriteLn(outF, "<html lang='en'>");
    WriteLn(outF, "<head>");
    WriteLn(outF, "<meta charset='UTF-8'>");
    WriteString(outF, "<title>");
    EscapeHTML(pageTitle, escaped);
    WriteString(outF, escaped);
    WriteString(outF, " | ");
    WriteString(outF, SiteTitle);
    WriteLn(outF, "</title>");
    WriteLn(outF, "<style>");
    WriteLn(outF, "body{font-family:serif;max-width:700px;margin:0 auto;padding:2rem;}");
    WriteLn(outF, "pre{background:#f5f5f5;padding:1rem;}");
    WriteLn(outF, "</style>");
    WriteLn(outF, "</head>");
    WriteLn(outF, "<body>");
    WriteLn(outF, "<article>");
    WriteString(outF, "<h1>");
    WriteString(outF, escaped);
    WriteLn(outF, "</h1>");

    IF pageDate[0] # 0X THEN
        WriteString(outF, "<time>");
        WriteString(outF, pageDate);
        WriteLn(outF, "</time>")
    END;

    (* Parse markdown content *)
    inCode := FALSE;
    LOOP
        ReadLine(inF, line, eof);
        IF eof THEN EXIT END;
        COPY(line, trimmed);
        Trim(trimmed);

        IF StartsWith(trimmed, "```") THEN
            IF inCode THEN
                WriteLn(outF, "</code></pre>");
                inCode := FALSE
            ELSE
                WriteString(outF, "<pre><code>");
                inCode := TRUE
            END
        ELSIF inCode THEN
            EscapeHTML(line, escaped);
            WriteLn(outF, escaped)
        ELSIF StartsWith(trimmed, "### ") THEN
            WriteString(outF, "<h3>");
            Strings.Extract(trimmed, 4, Strings.Length(trimmed) - 4, line);
            WriteString(outF, line);
            WriteLn(outF, "</h3>")
        ELSIF StartsWith(trimmed, "## ") THEN
            WriteString(outF, "<h2>");
            Strings.Extract(trimmed, 3, Strings.Length(trimmed) - 3, line);
            WriteString(outF, line);
            WriteLn(outF, "</h2>")
        ELSIF StartsWith(trimmed, "# ") THEN
            WriteString(outF, "<h1>");
            Strings.Extract(trimmed, 2, Strings.Length(trimmed) - 2, line);
            WriteString(outF, line);
            WriteLn(outF, "</h1>")
        ELSIF StartsWith(trimmed, "- ") OR StartsWith(trimmed, "* ") THEN
            WriteString(outF, "<li>");
            Strings.Extract(trimmed, 2, Strings.Length(trimmed) - 2, line);
            WriteString(outF, line);
            WriteLn(outF, "</li>")
        ELSIF Strings.Length(trimmed) > 0 THEN
            WriteString(outF, "<p>");
            WriteString(outF, trimmed);
            WriteLn(outF, "</p>")
        END
    END;

    (* HTML footer *)
    WriteLn(outF, "</article>");
    WriteLn(outF, "<footer><p>Generated by obli-ssg (Oberon)</p></footer>");
    WriteLn(outF, "</body>");
    WriteLn(outF, "</html>")
END GeneratePage;

(* Commands *)
PROCEDURE Build;
VAR
    inF, outF: Files.File;
    srcPath, outPath: ARRAY 256 OF CHAR;
BEGIN
    Out.String("obli-ssg: Building site..."); Out.Ln;
    Out.String("  Output directory: "); Out.String(OutputDir); Out.Ln;

    COPY(ContentDir, srcPath);
    Strings.Append("/index.md", srcPath);
    COPY(OutputDir, outPath);
    Strings.Append("/index.html", outPath);

    Out.String("  Processing: "); Out.String(srcPath); Out.Ln;

    inF := Files.Old(srcPath);
    IF inF = NIL THEN
        Out.String("  Error: File not found"); Out.Ln;
        RETURN
    END;

    ParseFrontmatter(inF);

    IF pageDraft THEN
        Out.String("    Skipping draft"); Out.Ln;
        Files.Close(inF);
        RETURN
    END;

    outF := Files.New(outPath);
    GeneratePage(inF, outF);
    Files.Register(outF);
    Files.Close(inF);
    Files.Close(outF);

    Out.String("  Written: "); Out.String(outPath); Out.Ln;
    Out.String("obli-ssg: Build complete."); Out.Ln
END Build;

PROCEDURE Init;
VAR
    f: Files.File;
    path: ARRAY 256 OF CHAR;
BEGIN
    Out.String("obli-ssg: Initializing new site..."); Out.Ln;

    COPY(ContentDir, path);
    Strings.Append("/index.md", path);
    f := Files.New(path);

    WriteLn(f, "---");
    WriteLn(f, "title: Welcome to Obli");
    WriteLn(f, "date: 2025-01-18");
    WriteLn(f, "---");
    WriteLn(f, "");
    WriteLn(f, "# Welcome");
    WriteLn(f, "");
    WriteLn(f, "This site was built with **obli-ssg**, an Oberon-powered SSG.");
    WriteLn(f, "");
    WriteLn(f, "## Oberon Features");
    WriteLn(f, "");
    WriteLn(f, "- Module system");
    WriteLn(f, "- Type safety");
    WriteLn(f, "- Minimalist design");
    WriteLn(f, "- Wirth heritage");

    Files.Register(f);
    Files.Close(f);

    Out.String("  Created sample content"); Out.Ln;
    Out.String("obli-ssg: Site initialized."); Out.Ln
END Init;

PROCEDURE Clean;
BEGIN
    Out.String("obli-ssg: Cleaning "); Out.String(OutputDir); Out.String("/..."); Out.Ln;
    Out.String("obli-ssg: Clean complete."); Out.Ln
END Clean;

PROCEDURE Help;
BEGIN
    Out.String("obli-ssg - Oberon Static Site Generator"); Out.Ln;
    Out.Ln;
    Out.String("USAGE:"); Out.Ln;
    Out.String("  obli <command>"); Out.Ln;
    Out.Ln;
    Out.String("COMMANDS:"); Out.Ln;
    Out.String("  build    Build the site"); Out.Ln;
    Out.String("  init     Initialize a new site"); Out.Ln;
    Out.String("  clean    Remove generated files"); Out.Ln;
    Out.String("  help     Show this help"); Out.Ln
END Help;

(* Main *)
PROCEDURE Main;
VAR
    cmd: ARRAY 32 OF CHAR;
BEGIN
    IF Args.count >= 1 THEN
        Args.Get(1, cmd);
        IF Strings.Equal(cmd, "build") THEN Build
        ELSIF Strings.Equal(cmd, "init") THEN Init
        ELSIF Strings.Equal(cmd, "clean") THEN Clean
        ELSE Help
        END
    ELSE
        Help
    END
END Main;

BEGIN
    Main
END Obli.
