program tp1ej1;
type archivoInts = file of integer;
var archivo_logico:archivoInts;
	archivo_fisico: string;
	num:integer;
begin
	writeln('nombre de archivo fisico: ');
	readln(archivo_fisico);
	assign(archivo_logico, archivo_fisico);
	rewrite(archivo_logico);
	writeln('ingrese num: ');readln(num);
	while(num <> 30000) do begin
		write(archivo_logico, num);
		writeln('ingrese num: ');readln(num);
	end;
	close(archivo_logico);
end.
