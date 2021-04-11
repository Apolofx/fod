program tp1ej5;
type
    celular = record
        codigo:integer;
        nombre:string;
        descripcion:string;
        marca:string;
        precio:real;
        stock_min:integer;
        stock_actual:integeR;
    end;
archivoCelulares = file of celular;

procedure imprimirCelular(cel:celular);
begin
  with cel do begin
    Writeln('nombre:', nombre);
    Writeln('codigo:', codigo);
    Writeln('descripcion:', descripcion);
    Writeln('marca:', marca);
    Writeln('precio:', precio:4:2);
    Writeln('stock_min:', stock_min);
    Writeln('stock_actual:', stock_actual);
    writeln('--------');
  end;
end;

procedure leerCelular(var cel:celular);
begin
  with cel do begin
    Writeln('codigo:');ReadLn(codigo);
    if codigo <> -1 then begin      
    Writeln('nombre:');readln(nombre);
    Writeln('descripcion:');readln(descripcion);
    Writeln('marca:');readln(marca);
    Writeln('precio:'); ReadLn(precio);
    Writeln('stock_min:');readln(stock_min);
    Writeln('stock_actual:');ReadLn(stock_actual);
    writeln('--------');
    end;
  end;
end;

procedure crearBinarioDesdeTxt(var bin:archivoCelulares; var txt:Text);
var cel:celular;
begin
  reset(txt);
  Rewrite(bin);
  while not eof(txt) do begin
    with cel do begin
      readln(txt, codigo, precio, marca);
      readln(txt, stock_actual, stock_min, descripcion);
      readln(txt, nombre);
    end;
    write(bin, cel);
  end;
  close(txt);
  close(bin);
end;

procedure agregarCelular(var archivo:archivoCelulares);
var cel:celular;
begin
  reset(archivo);
  leerCelular(cel);
  while(cel.codigo <> -1) do begin
    seek(archivo, FileSize(archivo));
    write(archivo, cel);
    leerCelular(cel);
  end;
  close(archivo);
end;

procedure imprimirCelulares(var archivo:archivoCelulares);
var cel:celular;
begin
  reset(archivo);
  while(not eof(archivo)) do begin
    read(archivo, cel);
    imprimirCelular(cel);
  end;
  close(archivo);
end;

procedure listarStockMenorAlMinimo(var archivo: archivoCelulares);
var cel:celular;
begin
  reset(archivo);
  while(not eof(archivo)) do begin
    read(archivo,cel);
    with cel do begin
      if (stock_actual < stock_min) then imprimirCelular(cel); 
    end;
  end;
  close(archivo);
end;

procedure listarPorDescripcion(var archivo:archivoCelulares);
var cadena:string;
cel:celular;
begin
  reset(archivo);
  Write('Ingrese la cadena que espera que tenga la descripcion: ');Readln(cadena);
  while(not eof(archivo)) do begin
    read(archivo,cel);
    if(cel.descripcion = cadena) then imprimirCelular(cel);
  end;
  close(archivo);
end;

procedure exportarATexto(var archivo:archivoCelulares; var txt: Text);
var cel:celular;
begin
  reset(archivo);
  rewrite(txt);
  while(not eof(archivo)) do begin
    read(archivo, cel);
    with cel do begin
        writeln(txt, codigo, ' ', precio:4:2, ' ', marca);
        writeln(txt, stock_actual, ' ', stock_min, ' ', descripcion);
        writeln(txt, nombre);
    end;
  end;
  close(archivo);
  close(txt);
end;

procedure modificarStock(var archivo:archivoCelulares);
var cel:celular;
codigo:integer;
encontro:boolean;
begin
  reset(archivo);
  encontro := false;
  Write('Ingrese el codigo del celular que desea modificar: ');ReadLn(codigo);
  while (not eof(archivo) and not encontro) do begin
    read(archivo, cel);
    if(cel.codigo = codigo) then encontro := true;
  end;
  if encontro then begin
    write('Ingrese el nuevo stock: '); ReadLn(cel.stock_actual);
    seek(archivo, FilePos(archivo) - 1);
    write(archivo, cel);
  end else Writeln('No se encontro ningun celular con ese codigo');
  close(archivo);
end;

procedure exportarSinStock(var archivo:archivoCelulares; var txt:Text);
var cel:celular;
begin
  reset(archivo);
  Rewrite(txt);
  while(not eof(archivo)) do begin
    read(archivo, cel);
    if cel.stock_actual = 0 then begin
        with cel do begin
            writeln(txt, codigo, ' ', precio:4:2, ' ', marca);
            writeln(txt, stock_actual, ' ', stock_min, ' ', descripcion);
            writeln(txt, nombre);
        end;
    end;
  end;
  Close(archivo);
  Close(txt);
end;

var 
    celularesBin:archivoCelulares;
    celularesTxt:Text;
    sinStockTxt:Text;
    opcion:integer;
begin
Assign(celularesBin, 'celulares');
Assign(celularesTxt, 'celulares.txt');
Assign(sinStockTxt, 'SinStock.txt');
opcion := -1;
while(opcion <> 0) do begin
  Writeln('Elija una de las siguientes opciones de la lista o 0 para salir: ');
  writeln('1. Crear registro de celulares a partir de archivo de texto.');
  writeln('2. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.');
  writeln('3. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.');
  writeln('4. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.');
  writeln('5. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.');
  writeln('6. Modificar stock de un celular buscado por codigo.');
  writeln('7. Exportar celulares sin stock a SinStock.txt.');
  Readln(opcion);
  case opcion of
  1: crearBinarioDesdeTxt(celularesBin, celularesTxt);
  2: listarStockMenorAlMinimo(celularesBin);
  3: listarPorDescripcion(celularesBin);
  4: exportarATexto(celularesBin, celularesTxt);
  5: agregarCelular(celularesBin);
  6: modificarStock(celularesBin);
  7: exportarSinStock(celularesBin, sinStockTxt);
  end;
end;
end.




