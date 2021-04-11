program tp1ej3y4;
const corte = 'fin';
const edadJubilacion = 70;
//Registro empleado
type 
    empleado = record
        numero:integer;
        apellido:string;
        nombre:string;
        edad:integer;
        dni:integer;
    end;
    archivoEmpleados = file of empleado;
procedure leerEmpleado(var e:empleado);
begin
  with e do begin
    Writeln('apellido: '); Readln(apellido);
    if (apellido <> corte) then begin
      writeln('nombre: ');readln(nombre);
      writeln('dni: ');readln(dni);
      writeln('edad: ');readln(edad);
      writeln('numero: ');readln(numero);
      writeln('-----------------');
    end;
  end;
end;

procedure cargarEmpleados(var archivo:archivoEmpleados);
var e:empleado;
begin
  Rewrite(archivo);  
  leerEmpleado(e);
  while e.apellido <> corte do begin
    write(archivo, e);
    leerEmpleado(e);
  end;
  close(archivo);
end;

procedure agregarEmpleados(var archivo:archivoEmpleados);
var e:empleado;
begin
  reset(archivo);
  leerEmpleado(e);
  while(e.apellido <> corte) do begin
    Seek(archivo, FileSize(archivo));
    write(archivo, e);
    leerEmpleado(e);
  end;
  close(archivo);
end;

procedure modificarEdadEmpleados(var archivo:archivoEmpleados);
var e:empleado;
nombre,apellido:string;
nueva_edad:integer;
begin
  reset(archivo);
  writeln('Ingrese nombre y apellido del empleado que quiere modificar');
  writeln('nombre: ');readln(nombre);
  writeln('apellido: ');readln(apellido);
  read(archivo, e);
  while(not Eof(archivo) and (e.apellido <> apellido) and (e.nombre <> nombre)) do read(archivo,e);
  if ((e.apellido = apellido) and (e.nombre = nombre)) then begin
    Write('Ingrese la nueva edad: ');readln(nueva_edad);
    e.edad := nueva_edad;
    seek(archivo, FilePos(archivo) - 1);
    Write(archivo, e); 
  end
  else writeln('No se encontro ningun empleado con esos datos');
  close(archivo);
end;

procedure exportarATexto(var archivo_binario:archivoEmpleados;var archivo_txt:Text);
var e:empleado;
nombre_fisico_txt:string;
begin
  writeln('Nombre del archivo de texto: ');readln(nombre_fisico_txt);
  Assign(archivo_txt, nombre_fisico_txt);
  reset(archivo_binario);
  Rewrite(archivo_txt);
  while(not eof(archivo_binario)) do begin
    read(archivo_binario, e);
    with e do begin
      writeln(e.nombre:5, e.apellido:5, e.edad:5, e.numero:5, e.dni:5);
    end;
    with e do begin
      writeln(archivo_txt, ' ', e.edad, ' ', e.dni, ' ', e.numero,' ', e.nombre +' '+e.apellido);
    end;
  end;
  close(archivo_binario);
  close(archivo_txt);
end;


procedure listarEmpleado(e:empleado);
begin
    with e do begin
        Writeln('-------------------');
        writeln('Nombre: ', nombre);
        writeln('apellido: ', apellido);
        writeln('dni: ', dni);
        writeln('numero: ', numero);
        writeln('edad: ', edad);
        Writeln('-------------------');
    end;
end;

procedure imprimirEmpleado(var archivo:archivoEmpleados);
var e:empleado;
dato:String;
begin
  Reset(archivo);
  Write('Ingrese nombre o apellido a buscar: '); readln(dato);
  while(not eof(archivo)) do begin
    read(archivo, e);
    if( (dato = e.apellido) or (dato = e.nombre)) then listarEmpleado(e) ;
  end;
    close(archivo);
end;

procedure listarEmpleados(var archivo:archivoEmpleados);
var e:empleado;
begin
  reset(archivo);
  while(not Eof(archivo)) do begin
    read(archivo,e);
    listarEmpleado(e);
  end;
  close(archivo);
end;

procedure listarCasiJubilado(var archivo:archivoEmpleados);
var e:empleado;
begin
  reset(archivo);
  while(not eof(archivo)) do begin
    read(archivo,e);
    if (e.edad > edadJubilacion) then listarEmpleado(e);
  end;
  close(archivo);
end;


var archivo_logico : archivoEmpleados;
archivo_fisico:string;
txt: Text;
opcion:integer;
begin
opcion := -1;
  Writeln('Ingrese el nombre del archivo fisico');
  ReadLn(archivo_fisico);
  Assign(archivo_logico, archivo_fisico);   
while(opcion <> 0) do begin
  Writeln('Elija una de las siguientes opciones de la lista o 0 para salir: ');
  writeln('1. Crear registro de empleados.');
  writeln('2. Buscar y listar empleado en pantalla.');
  writeln('3. Listar empleados de a uno por linea.');
  writeln('4. Listar en pantalla empleados mayores de 70.');
  writeln('5. Añadir uno o mas empleados al final del archivo.');
  writeln('6. Cambiar la edad de un empleado.');
  writeln('7. Exportar todos los empleados a texto.');
  Readln(opcion);
  case opcion of
  1: cargarEmpleados(archivo_logico);
  2: imprimirEmpleado(archivo_logico);
  3: listarEmpleados(archivo_logico);
  4: listarCasiJubilado(archivo_logico);
  5: agregarEmpleados(archivo_logico);
  6: modificarEdadEmpleados(archivo_logico);
  7: exportarATexto(archivo_logico, txt);
  end;
end;
end.