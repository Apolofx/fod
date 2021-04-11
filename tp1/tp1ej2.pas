program tp1ej2;
const menorA = 1500;
type archivoNumeros = file of integer;

procedure informar(var archivo:archivoNumeros);
var cantMenor, sumaTotal, cant, num:integer;
promedio:real;
begin
	cantMenor:=0;
	sumaTotal:=0;
	promedio:=0;
	cant:=0;
	reset(archivo);
	while(not EOF(archivo)) do begin
		read(archivo, num);
		writeln(num);
		if (num < menorA) then cantMenor := cantMenor + 1;
		sumaTotal := sumaTotal + num;
		cant:= cant + 1;
	end;
	close(archivo);
	if (cant <> 0) then promedio := sumaTotal / cant;
	Writeln('Cantidad menor a ', menorA,': ', cantMenor);
	Writeln('Promedio: ', promedio:4:2);
end;

var archivoNums: archivoNumeros;
	nombreFisico:string;
Begin
	writeln('Ingrese el nombre del archivo fisico');
	readln(nombreFisico);
	assign(archivoNums, nombreFisico);
	reset(archivoNums);
	informar(archivoNums);
end.
