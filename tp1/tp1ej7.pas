program tp1ej7;
const corte = -1;
type
    novela = record
        codigo:integer;
        nombre:string;
        genero:string;
        precio:real;
    end;
    bin_novela = file of novela; 

procedure leerNovela(var n:novela);
begin
  with n do begin
    writeln('codigo: ');readln(codigo);
    if (codigo <> corte) then begin
        writeln('nombre: ');readln(nombre);
        writeln('genero: ');readln(genero);
        writeln('precio: ');readln(precio);      
        writeln('-----------');
    end;
  end;
end;

procedure crearBinarioDesdeTxt(var archivo:bin_novela;var txt:Text);
var n:novela;
begin
  reset(txt);
  Rewrite(archivo);
  while(not eof(txt)) do begin
    with n do begin
    readln(txt, codigo, precio, genero);
    readln(txt,nombre);
    write(archivo, n);
    end;
  end;
  close(archivo);
  close(txt);
end;

procedure agregarNovela(var archivo:bin_novela);
var n:novela;
begin
  reset(archivo);
  leerNovela(n);
  while(n.codigo <> corte) do begin
    seek(archivo, FileSize(archivo) - 1);
    write(archivo, n);
    leerNovela(n);
  end;
end;

procedure modificarNovela(var archivo:bin_novela);
var n:novela;
encontro: boolean;
codigo, opcion:integer;
begin
  opcion := -1;
  encontro:=false;
  reset(archivo);
  writeln('Ingrese el codigo de la novela que desea modificar: '); ReadLn(codigo);
  while(not eof(archivo) and not encontro) do begin
    read(archivo, n);
    if(codigo = n.codigo) then begin
      encontro := true;
    end;
  end;
  if encontro then begin
      while(opcion <> 0) do begin
      writeln('Ingrese el campo a modificar y su nuevo valor o 0 para salir: '); 
      writeln('1. Nombre'); 
      writeln('2. Precio'); 
      writeln('3. Genero'); 
      readln(opcion);
        case opcion of
            1: ReadLn(n.nombre); 
            2: ReadLn(n.precio);
            3: ReadLn(n.genero);
        end;
        Write(archivo, n);
        Writeln('Registro modificado: ');
        with n do begin
            writeln(nombre:5, codigo:5, precio:4:2, genero);
        end;
      end;
  end
  else Writeln('No se encontro ninguna novela con ese codigo');
end;

var novelas_binario_logico: bin_novela; 
novelas_txt_logico: Text;
opcion:integer;
begin
  Assign(novelas_binario_logico, 'novelas');
  Assign(novelas_txt_logico, 'novelas.txt');
  opcion := -1;
  while opcion <> 0 do begin
    writeln('1. Crear un archivo binario a partir a partir del archivo novelas.txt');
    writeln('2. Actualizar contenido de archivo novelas');
    ReadLn(opcion);
    case opcion of 
    1: crearBinarioDesdeTxt(novelas_binario_logico,  novelas_txt_logico);
    2: modificarNovela(novelas_binario_logico);
    end;
  end;
end.